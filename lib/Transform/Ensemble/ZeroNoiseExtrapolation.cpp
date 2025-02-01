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
#include "unordered_map"

namespace mlir {
namespace qe {
namespace ensemble {

#define GEN_PASS_DEF_ZERONOISEEXTRAPOLATION
#include "lib/Transform/Ensemble/Passes.h.inc"

using arith::ConstantOp;
using mlir::affine::AffineForOp;
using mlir::affine::AffineYieldOp;

// template <typename T>
// LogicalResult zneRewritePattern(T &op, PatternRewriter &rewriter) {
//   // if we have already processed the op, exit.
//   if (op->getAttr("zne-applied")) {
//     return failure();
//   } else {
//     // Save the current insertion point and get the op location
//     auto insertionPoint = rewriter.saveInsertionPoint();
//     auto loc = op.getLoc();
//     rewriter.setInsertionPointAfter(op);

//     // get the Operation object associated with the op
//     mlir::Operation *operation = op.getOperation();

//     // Insert an affine for loop
//     auto forOp = rewriter.create<AffineForOp>(loc, 0, 10, 1);
    

//     // Set the insertion point to the start of the loop body
//     rewriter.setInsertionPointToStart(forOp.getBody());

//     // Clone the original operation inside the loop body
//     // and create two copies of the original gate
//     mlir::Operation *newGateOp = rewriter.clone(*operation);
//     mlir::Operation *newGateOpAdjoint = rewriter.clone(*operation);

//     // mark the second copy as adjoint
//     newGateOpAdjoint->setAttr("adjoint", rewriter.getUnitAttr());

//     // set the operands of the first new gate as the results
//     // of the original gate
//     newGateOp->setOperands(operation->getResults());

//     // set the operands of the adjoint gate as the
//     // results of the first new gate
//     newGateOpAdjoint->setOperands(newGateOp->getResults());

//     // replaces all uses of the result of the original gate
//     // with the result of the new adjoint gate
//     int numResults = (int) operation->getNumResults();

//     for (int resultIndex = 0; resultIndex < numResults; resultIndex++) {
//       operation->replaceUsesOfWith(operation->getResult(resultIndex),
//                                    newGateOpAdjoint->getResult(resultIndex));
//     }

//     // mark the new gates as already processed
//     // to prevent infinite loops
//     newGateOp->setAttr("zne-applied", rewriter.getUnitAttr());
//     newGateOpAdjoint->setAttr("zne-applied", rewriter.getUnitAttr());

//     // Restore the original insertion point
//     rewriter.restoreInsertionPoint(insertionPoint);

//     rewriter.updateRootInPlace(
//         op, [&]() { op->setAttr("zne-applied", rewriter.getUnitAttr()); });

//     return success();
//   }
// }



// // Add an affine for loop after every gate op containing
// // the same gate and its adjoint.
// struct AddGateAndAdjointPairs1Q : public OpRewritePattern<Gate1QOp> {
//   AddGateAndAdjointPairs1Q(mlir::MLIRContext *context)
//     // benefit: 1
//       : OpRewritePattern<Ensemble>(context, 1) {}

//   LogicalResult matchAndRewrite(Gate1QOp op,
//                                 PatternRewriter &rewriter) const override {
//     return zneRewritePattern<Gate1QOp>(op, rewriter);
//   }
// };

// struct AddGateAndAdjointPairs2Q : public OpRewritePattern<Gate2QOp> {
//   AddGateAndAdjointPairs2Q(mlir::MLIRContext *context)
//   // benefit: 1
//       : OpRewritePattern<Gate2QOp>(context, 1) {}

//   LogicalResult matchAndRewrite(Gate2QOp op,
//                                 PatternRewriter &rewriter) const override {
//     return zneRewritePattern<Gate2QOp>(op, rewriter);
//   }
// };

struct AddTensorBeforeProgramIteration : public OpRewritePattern<QuantumProgramIteration> {
  AddTensorBeforeProgramIteration(mlir::MLIRContext *context)
  // benefit: 1
    : OpRewritePattern<QuantumProgramIteration>(context, 1) {}
  
  LogicalResult matchAndRewrite(QuantumProgramIteration op, PatternRewriter & rewriter) const override {
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
    auto constantOp = rewriter.create<arith::ConstantOp>(loc, tensorType, denseAttr);

    // create a loop from 0 to 8
    auto loop = rewriter.create<AffineForOp>(loc, 0, 8, 1);
    rewriter.setInsertionPointToStart(loop.getBody());

    // move the QuantumProgramIteration op inside the loop
    

    

    


    rewriter.restoreInsertionPoint(insertionPoint);
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
    if (op->hasAttr("zero-noise-created") || op->hasAttr("zero-noise-touched")) {
      // print this op, its gate name and inverse attribute and print the one after it
      std::cout << "This one already touched:" << op.getOperation()->getName().getStringRef().str() << std::endl;
      if (auto inverseAttr = op.getOperation()->getAttr("inverse")) {
        std::cout << "Inverse attribute: " << inverseAttr.cast<StringAttr>().getValue().str() << std::endl;
      }
      // if it has a next node and the next node is a gate constructor op, then print it too
      if (op.getOperation()->getNextNode() && llvm::isa<GateConstructorOp>(op.getOperation()->getNextNode())) {
        std::cout << "This one after it already touched:" << op.getOperation()->getNextNode()->getName().getStringRef().str() << std::endl;
        if (auto nextInverseAttr = op.getOperation()->getNextNode()->getAttr("inverse")) {
          std::cout << "Inverse attribute: " << nextInverseAttr.cast<StringAttr>().getValue().str() << std::endl;
        }
      }

      std::cout << std::endl;
      return failure();
    }

    // Get the location for the new operations
    auto loc = op.getLoc();

    // Create a transpose version of the gate right after the original
    rewriter.setInsertionPointAfter(op);
    auto transposeGate = rewriter.clone(*op.getOperation());
    // make a mapping from the original gate to the transpose gate
    // mark both gates as transpose-created
    op->setAttr("zero-noise-touched", rewriter.getUnitAttr());
    transposeGate->setAttr("zero-noise-created", rewriter.getUnitAttr());
    // mark the transpose gate by setting the inverse attribute as transpose
    transposeGate->setAttr("inverse", rewriter.getStringAttr("transpose"));


    
    // auto transposeGate = rewriter.create<GateConstructorOp>(
    //     loc, 
    //     op.getType(),
    //     op.getNameAttr(),
    //     rewriter.getStringAttr("inverse"),
    //     op.getNum_operandsAttr(),
    //     op.getParameters());

    // Mark the original operation as processed
    rewriter.updateRootInPlace(op, [&]() {
      op->setAttr("zero-noise-touched", rewriter.getUnitAttr());
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

    (void)applyPatternsAndFoldGreedily(getOperation(), std::move(patterns));
  }
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir
