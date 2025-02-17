#include "lib/Transform/Ensemble/GateMerging.h"

#include <iostream>
#include <cassert>

#include "lib/Dialect/Ensemble/EnsembleOps.h"
#include "lib/Dialect/Ensemble/EnsembleTypes.h"

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

#define GEN_PASS_DEF_GATEMERGING
#include "lib/Transform/Ensemble/Passes.h.inc"

using arith::ConstantOp;
using mlir::affine::AffineForOp;
using mlir::affine::AffineYieldOp;
using mlir::scf::ForOp;
// Macro to check the number of operands and return failure if condition is met
#define CHECK_AND_RETURN_ON_OPERAND_COUNT(op, num) \
  if ((op).getOperation()->getNumOperands() >= (num+1)) { \
    return failure(); \
  }


struct RemoveUnusedGateConstructor : public OpRewritePattern<GateConstructorOp> {
  RemoveUnusedGateConstructor(MLIRContext *context)
      : OpRewritePattern<GateConstructorOp>(context, /*benefit=*/1) {}

  LogicalResult matchAndRewrite(GateConstructorOp op,
                               PatternRewriter &rewriter) const override {
    // Check if the operation has already been processed
    // check if the operation has no uses
    if (op.getOperation()->use_empty()) {
      rewriter.eraseOp(op.getOperation());
    }

    return success();
  }
};

std::vector<mlir::Value> mergedU3GateParameters(mlir::Value g0_p0, mlir::Value g0_p1, mlir::Value g0_p2, mlir::Value g1_p0, mlir::Value g1_p1, mlir::Value g1_p2, PatternRewriter &rewriter, mlir::Location loc)  {
    auto merged_p0 = rewriter.create<arith::AddFOp>(loc, g0_p0, g1_p0);
    auto merged_p1 = rewriter.create<arith::AddFOp>(loc, g0_p1, g1_p1);
    auto merged_p2 = rewriter.create<arith::AddFOp>(loc, g0_p2, g1_p2);
    return std::vector<mlir::Value>({merged_p0, merged_p1, merged_p2});
  }


struct MergeEnsembleApply : public OpRewritePattern<ApplyGate> {
  MergeEnsembleApply(MLIRContext *context)
      : OpRewritePattern<ApplyGate>(context, /*benefit=*/1) {}

  


  LogicalResult matchAndRewrite(ApplyGate op,
                               PatternRewriter &rewriter) const override {
    
    CHECK_AND_RETURN_ON_OPERAND_COUNT(op, 2);

    if (op->hasAttr("cannot-merge")) {
      return failure();
    }

    // Get the gate operation
    GateConstructorOp gateOp = op.getGate().getDefiningOp<GateConstructorOp>();
    bool isU3 = gateOp.getName() == "U3";
    if (!isU3) {
      return failure();
    }

    // Get the block containing the operation
    Block *block = op->getBlock();
    assert(block && "Block is null");

    // Create a vector to store the apply operations
    Operation* mergingWith = nullptr;

    // Iterate over the operations in the block that are after the apply operation and find an apply gate one that has two operands
    Operation *nextOp = op->getNextNode();
    // check that nextOp is not nullptr and is an apply gate, and that its second operand is the same as the second operand of the apply operation
    while (nextOp != nullptr) {
      if (isa<ApplyGate>(nextOp) && nextOp->getOperands()[1] == op.getOperands()[1]) {
        GateConstructorOp nextGateOp = nextOp->getOperands()[0].getDefiningOp<GateConstructorOp>();
        if (nextGateOp && nextGateOp.getName() == "U3") {
          mergingWith = nextOp;
          break;
        }
      }
      if (isa<AffineForOp>(nextOp) || isa<scf::ForOp>(nextOp) || isa<scf::IfOp>(nextOp) || nextOp->getBlock() != block) {
        break;
      }
      nextOp = nextOp->getNextNode();
    }



    if (!mergingWith) {
      op->setAttr("cannot-merge", rewriter.getUnitAttr());
      return failure();
    }

    // assert that the gate operation is U3 for both the apply operation and the mergingWith operation
    GateConstructorOp mergingWithGateOp = mergingWith->getOperands()[0].getDefiningOp<GateConstructorOp>();
    bool mergingWithIsU3 = mergingWithGateOp.getName() == "U3";
    assert(isU3 && mergingWithIsU3);



    // get the parameters of the gate operation
    auto params = gateOp.getOperands();
    assert(params.size() == 3 && "Gate operation parameters size is not 3");

    // get the parameters of the mergingWith operation
    auto mergingParams = mergingWithGateOp.getOperands();
    assert(mergingParams.size() == 3 && "MergingWith operation parameters size is not 3");


  


    auto mergedParameters = mergedU3GateParameters(params[0], params[1], params[2], mergingParams[0], mergingParams[1], mergingParams[2], rewriter, op->getLoc());

    Operation* fusedGateConstructor = rewriter.clone(*mergingWithGateOp);


    fusedGateConstructor->setOperands(mergedParameters);
    fusedGateConstructor->setAttr("generated-by-merging", rewriter.getUnitAttr());

    // since they are both U3, we can fuse the gates by using elementwise addition to elementwise add each element of the params, creating a new gate operation. Then, remove the old apply operations and replace with a new fused apply operation
    // create a new gate operation with the fused parameters
  
    // replace the old apply operations with a new fused apply operation
    mergingWith->setOperand(0, fusedGateConstructor->getResult(0));

    // delete the original apply gate op 
    rewriter.eraseOp(op);
  

    return success();
  }
};

void printOperation(Operation *op) {
  // Print operation name and location
  llvm::outs() << "Operation: " << op->getName() << "\n";
  llvm::outs() << "Location: " << op->getLoc() << "\n";
  
  // Print operands
  llvm::outs() << "Operands:\n";
  for (Value operand : op->getOperands()) {
    llvm::outs() << "  " << operand << "\n";
  }
  
  // Print results
  llvm::outs() << "Results:\n"; 
  for (Value result : op->getResults()) {
    llvm::outs() << "  " << result << "\n";
  }
  
  llvm::outs() << "\n";
}

Operation* getTopOfTree(Operation *op) {
  Operation* currentop = op;
  while (currentop->getParentOp() != nullptr) {
    currentop = currentop->getParentOp();
  }
  return currentop;
}

void printEverything(Operation *op) {
  if (op == nullptr) {
    return;
  }
  printOperation(op);
  for (Region &child : op->getRegions()) {
    for (Operation &child2 : child.getOps()) {
      printEverything(&child2);
    }
  }
}
struct MergeEnsembleApplyDistribution : public OpRewritePattern<ApplyGateDistribution> {
  MergeEnsembleApplyDistribution(MLIRContext *context)
      : OpRewritePattern<ApplyGateDistribution>(context, /*benefit=*/1) {}

  LogicalResult matchAndRewrite(ApplyGateDistribution op,
                               PatternRewriter &rewriter) const override {

    CHECK_AND_RETURN_ON_OPERAND_COUNT(op, 3);
    if (op->hasAttr("cannot-merge")) {
      return failure();
    }

    // Get the gate distribution operation
    GateDistributionConstructor gateDistributionConstructorOp = op.getGates().getDefiningOp<GateDistributionConstructor>();
    if (!gateDistributionConstructorOp) {
      return failure();
    }

    // Get the gates from the gate distribution operation
    auto gates = gateDistributionConstructorOp.getGates();
    assert(!gates.empty() && "Gates are empty");

    // Check if the gates are all U3 gates
    for (auto gate : gates) {
      GateConstructorOp gateOp = gate.getDefiningOp<GateConstructorOp>();
      assert(gateOp && gateOp.getName() == "U3");
    }

    Block *block = op->getBlock();
    assert(block && "Block is null");

    Operation* mergingWith = nullptr;

    // Iterate over the operations in the block that are after the apply operation and find an apply gate one that has two operands
    Operation *nextOp = op->getNextNode();
    while (nextOp != nullptr) {
      if (isa<ApplyGate>(nextOp) && nextOp->getOperands()[1] == op.getOperands()[2]) {
        GateConstructorOp nextGateOp = nextOp->getOperands()[0].getDefiningOp<GateConstructorOp>();
        if (nextGateOp && nextGateOp.getName() == "U3") {
          mergingWith = nextOp;
          break;
        }
      }
      if (isa<AffineForOp>(nextOp) || isa<scf::ForOp>(nextOp) || isa<scf::IfOp>(nextOp) || nextOp->getBlock() != block) {
        break;
      }
      nextOp = nextOp->getNextNode();
    }

    if (!mergingWith) {
      op->setAttr("cannot-merge", rewriter.getUnitAttr());
      return failure();
    }

    GateConstructorOp mergingWiths_GateConstructorOp = mergingWith->getOperands()[0].getDefiningOp<GateConstructorOp>();
    bool mergingWithIsU3 = mergingWiths_GateConstructorOp.getName() == "U3";
    assert(mergingWithIsU3);

    // Set insertion point after the last gate in the distribution
    rewriter.setInsertionPointAfter(mergingWith);

    // Create a new gate distribution constructor
    Operation* fusedDistributionGateConstructor = rewriter.clone(*gateDistributionConstructorOp);

    // For each of the gates, fuse the parameters with the mergingWithGateOp
    int i = 0;
    for (auto gate : gates) {
      rewriter.setInsertionPointAfter(mergingWith);
      Operation* fusedGateConstructor = rewriter.clone(*gate.getDefiningOp<GateConstructorOp>());
      auto params = fusedGateConstructor->getOperands();
      assert(params.size() == 3 && "Gate operation parameters size is not 3");
      auto mergingParams = mergingWiths_GateConstructorOp.getOperands();
      assert(mergingParams.size() == 3 && "MergingWith operation parameters size is not 3");
      rewriter.setInsertionPointAfter(fusedGateConstructor->getPrevNode());
      auto mergedParameters = mergedU3GateParameters(params[0], params[1], params[2], mergingParams[0], mergingParams[1], mergingParams[2], rewriter, fusedGateConstructor->getPrevNode()->getLoc());
      fusedGateConstructor->setOperands(mergedParameters);
      fusedDistributionGateConstructor->setOperand(i, fusedGateConstructor->getResult(0));
      fusedGateConstructor->setAttr("generated-by-merging-here", rewriter.getUnitAttr());
      i++;
    }

    rewriter.setInsertionPointAfter(fusedDistributionGateConstructor);
    Operation* fusedApplyDistribution = rewriter.clone(*op);

    fusedApplyDistribution->setOperand(0, fusedDistributionGateConstructor->getResult(0));

  
    rewriter.eraseOp(mergingWith);
    rewriter.eraseOp(op);
    return success();
  }
};

struct GateMerging
    : impl::GateMergingBase<GateMerging> {
  using GateMergingBase::GateMergingBase;

  void runOnOperation() {
    mlir::RewritePatternSet patterns(&getContext());
    patterns.add<MergeEnsembleApply>(&getContext());
    // patterns.add<MergeEnsembleApplyDistribution>(&getContext());
 

    (void)applyPatternsAndFoldGreedily(getOperation(), std::move(patterns));
  }
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir
