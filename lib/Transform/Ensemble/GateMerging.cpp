#include "lib/Transform/Ensemble/GateMerging.h"

#include <iostream>

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

// struct MoveEnsembleApplyDownPattern : public OpRewritePattern<ApplyGate> {
//   MoveEnsembleApplyDownPattern(MLIRContext *context)
//       : OpRewritePattern<ApplyGate>(context, /*benefit=*/1) {}

//   LogicalResult matchAndRewrite(ApplyGate op,
//                                PatternRewriter &rewriter) const override {
//     // Get the block containing the operation
//     Block *block = op->getBlock();

//     // Create a vector to store the apply operations
//     SmallVector<Operation *, 4> applyOps;

//     // Iterate over the operations in the block
//     for (Operation &operation : *block) {
//       if (isa<ApplyGate>(&operation)) {
//         applyOps.push_back(&operation);
//       }
//     }

//     // Move each apply operation as far down as possible without crossing nested loops or blocks
//     for (Operation *applyOp : applyOps) {
//       Operation *nextOp = applyOp->getNextNode();
//       while (nextOp && !isa<AffineForOp>(nextOp) && nextOp->getBlock() == block) {
//         nextOp = nextOp->getNextNode();
//       }
//       if (nextOp) {
//         applyOp->moveBefore(nextOp);
//       } else {
//         applyOp->moveBefore(block->getTerminator());
//       }
//     }

//     return success();
//   }
// };

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

    // get the parameters of the mergingWith operation
    auto mergingParams = mergingWithGateOp.getOperands();

    Operation* fusedGateConstructor = rewriter.clone(*mergingWithGateOp);
    
    for (int i = 0; i < 3; i++) {
      fusedGateConstructor->setOperand(i, rewriter.create<arith::AddFOp>(op.getLoc(), params[i], mergingParams[i]));
      fusedGateConstructor->setAttr("generated-by-merging", rewriter.getUnitAttr());
    }

    // since they are both U3, we can fuse the gates by using elementwise addition to elementwise add each element of the params, creating a new gate operation. Then, remove the old apply operations and replace with a new fused apply operation
    // create a new gate operation with the fused parameters
  
    // replace the old apply operations with a new fused apply operation
    mergingWith->setOperand(0, fusedGateConstructor->getResult(0));

    // delete the original apply gate op 
    rewriter.eraseOp(op);
  

    return success();
  }
};


struct GateMerging
    : impl::GateMergingBase<GateMerging> {
  using GateMergingBase::GateMergingBase;

  void runOnOperation() {
    mlir::RewritePatternSet patterns(&getContext());
    patterns.add<IdentifyEnsembleApply>(&getContext());
    //patterns.add<MoveEnsembleApplyDownPattern>(&getContext());
    patterns.add<MergeEnsembleApply>(&getContext());
 

    (void)applyPatternsAndFoldGreedily(getOperation(), std::move(patterns));
  }
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir
