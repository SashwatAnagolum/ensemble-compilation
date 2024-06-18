#include "lib/Transform/Ensemble/ZeroNoiseExtrapolation.h"

#include <iostream>

#include "lib/Dialect/Ensemble/EnsembleOps.h"
#include "lib/Dialect/Ensemble/EnsembleTypes.h"

//

#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/include/mlir/Pass/Pass.h"

namespace mlir {
namespace qe {
namespace ensemble {

#define GEN_PASS_DEF_ZERONOISEEXTRAPOLATION
#include "lib/Transform/Ensemble/Passes.h.inc"

using arith::ConstantOp;
using mlir::affine::AffineForOp;
using mlir::affine::AffineYieldOp;

// Add an affine for loop after every gate op containing
// the same gate and its adjoint.
struct AddGateAndAdjointPairs : public OpRewritePattern<Gate1QOp> {
  AddGateAndAdjointPairs(mlir::MLIRContext *context)
      : OpRewritePattern<Gate1QOp>(context, /*benefit=*/1) {}

  LogicalResult matchAndRewrite(Gate1QOp op,
                                PatternRewriter &rewriter) const override {
    // if we have already processed the op, exit.
    if (op->getAttr("zne-applied")) {
      return failure();
    } else {
      // Save the current insertion point and get the op location
      auto insertionPoint = rewriter.saveInsertionPoint();
      auto loc = op.getLoc();
      rewriter.setInsertionPointAfter(op);

      // get the Operation object associated with the op
      mlir::Operation *operation = op.getOperation();

      // Insert an affine for loop
      auto forOp = rewriter.create<AffineForOp>(loc, 0, 10, 1);

      // Set the insertion point to the start of the loop body
      rewriter.setInsertionPointToStart(forOp.getBody());

      // Clone the original operation inside the loop body
      // and create two copies of the original gate
      mlir::Operation *newGateOp = rewriter.clone(*operation);
      mlir::Operation *newGateOpAdjoint = rewriter.clone(*operation);

      // mark the second copy as adjoint
      newGateOpAdjoint->setAttr("adjoint", rewriter.getUnitAttr());

      // set the operands of the first new gate as the results
      // of the original gate
      newGateOp->setOperands(operation->getResults());

      // set the operands of the adjoint gate as the
      // results of the first new gate
      newGateOpAdjoint->setOperands(newGateOp->getResults());

      // replaces all uses of the result of the original gate
      // with the result of the new adjoint gate
      // operation.replaceUsesOfWith()

      // mark the new gates as already processed
      // to prevent infinite loops
      newGateOp->setAttr("zne-applied", rewriter.getUnitAttr());
      newGateOpAdjoint->setAttr("zne-applied", rewriter.getUnitAttr());

      // Restore the original insertion point
      rewriter.restoreInsertionPoint(insertionPoint);

      rewriter.updateRootInPlace(
          op, [&]() { op->setAttr("zne-applied", rewriter.getUnitAttr()); });

      return success();
    }
  }
};

struct ZeroNoiseExtrapolation
    : impl::ZeroNoiseExtrapolationBase<ZeroNoiseExtrapolation> {
  using ZeroNoiseExtrapolationBase::ZeroNoiseExtrapolationBase;

  void runOnOperation() {
    mlir::RewritePatternSet patterns(&getContext());
    patterns.add<AddGateAndAdjointPairs>(&getContext());

    (void)applyPatternsAndFoldGreedily(getOperation(), std::move(patterns));
  }
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir