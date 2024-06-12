#include <cmath>

#include "lib/Transform/Arith/MulToAdd.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/include/mlir/Pass/Pass.h"

namespace mlir {
namespace qe {

using arith::AddIOp;
using arith::ConstantOp;
using arith::MulIOp;
using arith::ShLIOp;

// Replace y = C*x with y = x << a, when C is a power of 2, a = log_2(C),
// otherwise do nothing.
struct PowerOfTwoShiftLeft : public OpRewritePattern<MulIOp> {
  PowerOfTwoExpand(mlir::MLIRContext *context)
      : OpRewritePattern<MulIOp>(context, /*benefit=*/2) {}

  LogicalResult matchAndRewrite(MulIOp op,
                                PatternRewriter &rewriter) const override {
    Value lhs = op.getOperand(0);

    // canonicalization patterns ensure the constant is on the right, if there
    // is a constant See
    // https://mlir.llvm.org/docs/Canonicalization/#globally-applied-rules
    Value rhs = op.getOperand(1);
    auto rhsDefiningOp = rhs.getDefiningOp<arith::ConstantIntOp>();

    // if the RHS operand is not a ConstantIntOp, then exit.
    if (!rhsDefiningOp) {
      return failure();
    }

    int64_t value = rhsDefiningOp.value();
    bool is_power_of_two = (value & (value - 1)) == 0;

    // if it is not a power of two, we cannot left shift, so exit.
    if (!is_power_of_two) {
      return failure();
    }

    // if it is a power of two, we can perform a left shift instead of a mul
    // first, find out what power of two it is
    int exponent = (int)log2(value);

    ConstantOp newConstant = rewriter.create<ConstantOp>(
        rhsDefiningOp.getLoc(),
        rewriter.getIntegerAttr(rhs.getType(), exponent));

    ShLIOp newShiftOp = rewriter.create<ShLIOp>(op.getLoc(), lhs, newConstant);

    rewriter.replaceOp(op, {newShiftOp});
    rewriter.eraseOp(rhsDefiningOp);

    return success();
  }
};

// Replace y = 9*x with y = 8*x + x
struct PeelFromMul : public OpRewritePattern<MulIOp> {
  PeelFromMul(mlir::MLIRContext *context)
      : OpRewritePattern<MulIOp>(context, /*benefit=*/1) {}

  LogicalResult matchAndRewrite(MulIOp op,
                                PatternRewriter &rewriter) const override {
    Value lhs = op.getOperand(0);
    Value rhs = op.getOperand(1);
    auto rhsDefiningOp = rhs.getDefiningOp<arith::ConstantIntOp>();
    if (!rhsDefiningOp) {
      return failure();
    }

    int64_t value = rhsDefiningOp.value();

    // We are guaranteed `value` is not a power of two, because the greedy
    // rewrite engine ensures the PowerOfTwoExpand pattern is run first, since
    // it has higher benefit.

    ConstantOp newConstant = rewriter.create<ConstantOp>(
        rhsDefiningOp.getLoc(),
        rewriter.getIntegerAttr(rhs.getType(), value - 1));
    MulIOp newMul = rewriter.create<MulIOp>(op.getLoc(), lhs, newConstant);
    AddIOp newAdd = rewriter.create<AddIOp>(op.getLoc(), newMul, lhs);

    rewriter.replaceOp(op, {newAdd});
    rewriter.eraseOp(rhsDefiningOp);

    return success();
  }
};

void MulToShiftAndAddPass::runOnOperation() {
  mlir::RewritePatternSet patterns(&getContext());
  patterns.add<PowerOfTwoShiftLeft>(&getContext());
  patterns.add<PeelFromMul>(&getContext());
  (void)applyPatternsAndFoldGreedily(getOperation(), std::move(patterns));
}

}  // namespace qe
}  // namespace mlir