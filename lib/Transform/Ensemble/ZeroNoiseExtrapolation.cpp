#include "lib/Transform/Ensemble/ZeroNoiseExtrapolation.h"

#include <iostream>

#include "lib/Dialect/Ensemble/EnsembleOps.h"
#include "lib/Dialect/Ensemble/EnsembleTypes.h"

// three steps needed for ZNE:
// 0. insert a tensor T at the top of the file with the loop repetition counts 0, 1, 2, 3, 4. This should be of type index
// 1. put the program iteration block inside of a scf for loop from 0 to 4, it should be circuit iteration variable i
// 2. Let k = T[i], which should be the number of times the gate conjugate transpose gate be applied.
// 3. For each ensemble.gate construction operation, create a transpose gate right next to it, and create an internal mapping from each gate to its transpose gate
// 4. For each operation of ensemble.apply, create a for loop from 0 to k, applying that gate, then the transpose gate. (don't worry about ensemble operations for now)

#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/include/mlir/Pass/Pass.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "unordered_map"

namespace mlir {
namespace qe {
namespace ensemble {

#define GEN_PASS_DEF_ZERONOISEEXTRAPOLATION
#include "lib/Transform/Ensemble/Passes.h.inc"

using arith::ConstantOp;
using mlir::affine::AffineForOp;
using mlir::affine::AffineYieldOp;
using mlir::scf::ForOp;


struct AddTensorBeforeProgramIteration : public OpRewritePattern<QuantumProgramIteration> {
  AddTensorBeforeProgramIteration(mlir::MLIRContext *context)
  // benefit: 1
    : OpRewritePattern<QuantumProgramIteration>(context, 1) {}
  
  LogicalResult matchAndRewrite(QuantumProgramIteration op, PatternRewriter & rewriter) const override {
    // if the op has already been peeked, skip it
    if (op->hasAttr("zero-noise-peeked")) {
      return failure();
    }
    auto the_one_before = op.getOperation()->getPrevNode();
    auto insertionPoint = rewriter.saveInsertionPoint();
    auto loc = the_one_before->getLoc();
    // std::cout << "This one:" << op.getOperation()->getName().getStringRef().str() << std::endl;
    // std::cout << "// the_one_before: " << the_one_before->getName().getStringRef().str() << std::endl;
    rewriter.setInsertionPointAfter(the_one_before);
    
    // Create a dense tensor attribute with repetition values [0,1,2,3,4,5,6,7,8]
    SmallVector<int32_t, 9> values = {0, 1, 2, 3, 4, 5, 6, 7, 8};
    auto tensorType = RankedTensorType::get({9}, rewriter.getI32Type());
    auto denseAttr = DenseIntElementsAttr::get(tensorType, values);
    
    // Create the constant operation with the dense tensor attribute
    rewriter.create<arith::ConstantOp>(loc, tensorType, denseAttr);

    // create a loop from 0 to 8
    auto loop = rewriter.create<AffineForOp>(loc, 0, 8, 1);
    rewriter.setInsertionPointToStart(loop.getBody());
    // rewriter.create<AffineYieldOp>(loop.getBody()->getTerminator()->getLoc());
    
    // move the QuantumProgramIteration op inside the loop
    op.getOperation()->moveBefore(loop.getBody()->getTerminator());

    rewriter.restoreInsertionPoint(insertionPoint);
    rewriter.updateRootInPlace(op, [&]() {
      op->setAttr("zero-noise-peeked", rewriter.getUnitAttr());
    });
    return success();
  }
};



struct AddTransposeToGateConstructor : public OpRewritePattern<GateConstructorOp> {
  std::unordered_map<Operation *, Operation *> *transpose_map;
  AddTransposeToGateConstructor(MLIRContext *context)
      : OpRewritePattern<GateConstructorOp>(context, /*benefit=*/1) {}

  LogicalResult matchAndRewrite(GateConstructorOp op,
                               PatternRewriter &rewriter) const override {
    // If we have already processed this operation, skip it
    if (op->hasAttr("zero-noise-created") || op->hasAttr("zero-noise-peeked")) {
      // print this op, its gate name and inverse attribute and print the one after it
      
      // if it has a next node and the next node is a gate constructor op, then print it too
      if (op.getOperation()->getNextNode() && llvm::isa<GateConstructorOp>(op.getOperation()->getNextNode())) {
        if (auto nextInverseAttr = op.getOperation()->getNextNode()->getAttr("inverse")) {
        }
      }

      return failure();
    }

    // Get the location for the new operations
    // auto loc = op.getLoc();

    // Create a transpose version of the gate right after the original
    rewriter.setInsertionPointAfter(op);
    auto transposeGate = rewriter.clone(*op.getOperation());
    // make a mapping from the original gate to the transpose gate
    // mark both gates as transpose-created
    op->setAttr("zero-noise-peeked", rewriter.getUnitAttr());
    transposeGate->setAttr("zero-noise-created", rewriter.getUnitAttr());
    // mark the transpose gate by setting the inverse attribute as transpose
    transposeGate->setAttr("inverse", rewriter.getStringAttr("transpose"));


  

    // Mark the original operation as processed
    rewriter.updateRootInPlace(op, [&]() {
      op->setAttr("zero-noise-peeked", rewriter.getUnitAttr());
    });

    return success();
  }
};

struct AddZNEToEachApplyGate : public OpRewritePattern<ApplyGate> {
  AddZNEToEachApplyGate(MLIRContext *context)
      : OpRewritePattern<ApplyGate>(context, /*benefit=*/1) {}

  LogicalResult matchAndRewrite(ApplyGate op,
                               PatternRewriter &rewriter) const override {
    
    // if the op has already been peeked, skip it
    if (op->hasAttr("zero-noise-peeked") || op->hasAttr("zero-noise-created")) {
      return failure();
    }

    // get the gate constructor op
    auto gateConstructor = op.getOperation()->getOperand(0).getDefiningOp<GateConstructorOp>();
    if (!gateConstructor) {
      return failure();
    }

    // get the op after the gate constructor op
    auto opAfterGateConstructor = gateConstructor.getOperation()->getNextNode();
    if (!opAfterGateConstructor || !llvm::isa<GateConstructorOp>(opAfterGateConstructor)) {
      return failure();
    } 

    // get the loop op, one step above the quantum program iteration op
    Operation *quantumprogiter_maybe = op.getOperation()->getParentOfType<QuantumProgramIteration>();
    if (!quantumprogiter_maybe) {
      return failure();
    }
    auto loop = quantumprogiter_maybe->getParentOfType<AffineForOp>();
    if (!loop) {
      return failure();
    }

    // get the index of the loop
    auto index_value = loop.getInductionVar();

    // get the value of the index
    // auto index_value = loop.getBody()->getTerminator()->getOperand(0);
    auto loc = op.getOperation()->getLoc();
    rewriter.setInsertionPointAfter(op);
    // create an scf for loop from 0 to index_value
    // create a 0 Value of type index
    auto zero = rewriter.create<arith::ConstantIndexOp>(loc, 0);
    // create a 1 Value of type index
    auto one = rewriter.create<arith::ConstantIndexOp>(loc, 1);
    auto forLoop = rewriter.create<scf::ForOp>(loc, zero, index_value, one);
    // clone the apply gate op inside the loop
    auto clonedApplyGate = rewriter.clone(*op.getOperation());
    // move the cloned apply gate op inside the loop
    clonedApplyGate->moveBefore(forLoop.getBody()->getTerminator());
    rewriter.setInsertionPointAfter(clonedApplyGate);

    auto clonedApplyGateTranspose = rewriter.clone(*op.getOperation());
    clonedApplyGateTranspose->moveAfter(clonedApplyGate);
    
    clonedApplyGateTranspose->setOperand(0, clonedApplyGate->getOperand(0).getDefiningOp<GateConstructorOp>()->getNextNode()->getResult(0));
    // replace the operands of the cloned apply gate op with the results of the original apply gate op
    // for (int i = 0; i < op.getOperation()->getNumOperands(); i++) {
    //   clonedApplyGate->setOperand(i, op.getOperation()->getOperand(i));
    // }
    
    
    // mark the cloned apply gate op as zero-noise-peeked
    clonedApplyGate->setAttr("zero-noise-created", rewriter.getUnitAttr());  
    clonedApplyGateTranspose->setAttr("zero-noise-created", rewriter.getUnitAttr());

    op->setAttr("zero-noise-peeked", rewriter.getUnitAttr());
    
    // update the original apply gate op as zero-noise-peeked
    rewriter.updateRootInPlace(op, [&]() {
      op->setAttr("zero-noise-peeked", rewriter.getUnitAttr());
    });
    
    return success();
    
    
    
  }
};
struct ZeroNoiseExtrapolation
    : impl::ZeroNoiseExtrapolationBase<ZeroNoiseExtrapolation> {
  using ZeroNoiseExtrapolationBase::ZeroNoiseExtrapolationBase;

  void runOnOperation() {
    mlir::RewritePatternSet patterns(&getContext());
    std::unordered_map<Operation *, Operation *> transpose_map;
    patterns.add<AddTensorBeforeProgramIteration>(&getContext());
    // patterns.add<AddGateAndAdjointPairs1Q>(&getContext());
    // patterns.add<AddGateAndAdjointPairs2Q>(&getContext());
    // patterns.add<AddTransposeBeforeGate>(&getContext());
    patterns.add<AddTransposeToGateConstructor>(&getContext());
    patterns.add<AddZNEToEachApplyGate>(&getContext());
    (void)applyPatternsAndFoldGreedily(getOperation(), std::move(patterns));
  }
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir