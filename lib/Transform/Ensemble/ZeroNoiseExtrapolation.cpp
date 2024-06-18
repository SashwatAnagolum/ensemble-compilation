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
      auto insertionPoint = rewriter.saveInsertionPoint();
      rewriter.setInsertionPointAfter(op);

      auto opLocation = op.getLoc();
      auto forLoopOp = rewriter.create<AffineForOp>(opLocation, 0, 10, 1);

      rewriter.setInsertionPointToStart(forLoopOp.getBody());
      auto newGateOp = rewriter.clone(*op.getOperation());
      auto yeildOp = rewriter.create<AffineYieldOp>(opLocation);
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