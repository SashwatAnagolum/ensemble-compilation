#include "lib/Transform/Ensemble/ZeroNoiseExtrapolation.h"

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

#define GEN_PASS_DEF_ZERONOISEEXTRAPOLATION
#include "lib/Transform/Ensemble/Passes.h.inc"

using arith::ConstantOp;
using mlir::affine::AffineForOp;

// Add an affine for loop after every gate op containing
// the same gate and its adjoint.
struct AddGateAndAdjointPairs : public OpRewritePattern<Gate1QOp> {
  PeelFromMul(mlir::MLIRContext *context)
      : OpRewritePattern<MulIOp>(context, /*benefit=*/1) {}

  LogicalResult matchAndRewrite(Gate1QOp op,
                                PatternRewriter &rewriter) const override {
    return failure();
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

}  // namespace qe
}  // namespace mlir