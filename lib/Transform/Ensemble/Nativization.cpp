#include "lib/Transform/Ensemble/Nativization.h"

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

#define GEN_PASS_DEF_NATIVIZATION
#include "lib/Transform/Ensemble/Passes.h.inc"

using arith::ConstantOp;
using mlir::affine::AffineForOp;
using mlir::affine::AffineYieldOp;
using mlir::scf::ForOp;

struct NativizeGateConstructor : public OpRewritePattern<GateConstructorOp> {
  NativizeGateConstructor(MLIRContext *context)
      : OpRewritePattern<GateConstructorOp>(context, /*benefit=*/1) {}

  LogicalResult matchAndRewrite(GateConstructorOp op,
                               PatternRewriter &rewriter) const override {
    // if the op has already been peeked, skip it
    if (op->hasAttr("nativized") || op->hasAttr("nativized-peeked")) {
      return failure();
    }

    // get the gate constructor op
    auto gateConstructor = op.getOperation();
    if (!gateConstructor) {
      return failure();
    }

    op->setAttr("nativized-peeked", rewriter.getUnitAttr());
    // if the gate constructor operates on 2 or more qubits, skip it
    assert(op.getOperation()->hasAttr("num_operands"));
    if (op.getOperation()->getAttr("num_operands").cast<IntegerAttr>().getInt() >= 2) {
      return failure();
    }

    // use the rewriter to create a new gate constructor op with the name U3 and operands 0, 0, 0 by initializing the three floating point numbers as SSA values above the gate constructor op
    rewriter.setInsertionPointAfter(gateConstructor);
    auto loc = gateConstructor->getLoc();
    auto zero = rewriter.create<arith::ConstantOp>(loc, rewriter.getF32FloatAttr(0.0));
    auto pi = rewriter.create<arith::ConstantOp>(loc, rewriter.getF32FloatAttr(3.14159265358979323846));
    auto pi_half = rewriter.create<arith::ConstantOp>(loc, rewriter.getF32FloatAttr(1.57079632679489661923));
    auto u3 = rewriter.clone(*op.getOperation());
    u3->setAttr("name", rewriter.getStringAttr("U3"));

    // depending upon the gate name of the gate constructor op, apply different parameters to the u3 op
    // depending upon the gate name of the gate constructor op, apply different parameters to the u3 op
    auto gateName = op.getOperation()->getAttr("name").cast<StringAttr>().getValue();
    if (gateName == "H") {
        // H gate has parameters u3(pi/2, 0, pi) 
        u3->setOperands({pi_half, zero, pi}); 
    } 
    else if (gateName == "X") {
        // X gate has parameters u3(pi, 0, pi)
        u3->setOperands({pi, zero, pi});
    } 
    else if (gateName == "Y") {
        // Y gate has parameters u3(pi, pi/2, pi/2)
        u3->setOperands({pi, pi_half, pi_half});
    }
    else if (gateName == "Z") {
        // Z gate has parameters u3(0, pi, 0)
        u3->setOperands({zero, pi, zero});
    }
    else if (gateName == "S") {
        // S gate has parameters u3(0, 0, pi/2)
        u3->setOperands({zero, zero, pi_half});
    }
    else {
        u3->setOperands({zero, zero, zero});
    }

    // if the original gate has a inverse attribute that has the value transpose, do this to the u3 op: U3 †(θ,ϕ,λ)=U3(−θ,−λ,−ϕ)
    if (op.getOperation()->hasAttr("inverse") && op.getOperation()->getAttr("inverse").cast<StringAttr>().getValue() == "transpose") {
        auto operands = u3->getOperands();
        // Extract the float values from the operands
        auto thetaValue = operands[0].getDefiningOp<arith::ConstantOp>().getValue().cast<FloatAttr>().getValueAsDouble();
        auto phiValue = operands[2].getDefiningOp<arith::ConstantOp>().getValue().cast<FloatAttr>().getValueAsDouble();
        auto lambdaValue = operands[1].getDefiningOp<arith::ConstantOp>().getValue().cast<FloatAttr>().getValueAsDouble();

        // Create three new constants with the negated values
        auto neg_theta = rewriter.create<arith::ConstantOp>(loc, rewriter.getF32FloatAttr(-thetaValue));
        auto neg_phi = rewriter.create<arith::ConstantOp>(loc, rewriter.getF32FloatAttr(-phiValue));
        auto neg_lambda = rewriter.create<arith::ConstantOp>(loc, rewriter.getF32FloatAttr(-lambdaValue));

        u3->setOperands({neg_theta, neg_lambda, neg_phi});
    }

    // mark the gate constructor op as nativized-peeked and the u3 op as nativized-created
    
    u3->setAttr("nativized-created", rewriter.getUnitAttr());

    // replace the gate constructor op with the u3 op
    op.getOperation()->replaceAllUsesWith(u3);

    bool deleteoriginalGate = true;

    if (deleteoriginalGate){
        // delete the gate constructor op using the rewriter
        rewriter.eraseOp(op.getOperation());
    }else  {
            // mark the gate constructor op as nativized-peeked
        rewriter.updateRootInPlace(op, [&]() {
        op->setAttr("nativized-peeked", rewriter.getUnitAttr());
        });

    }

    
    
    
    return success();
  }
};

struct Nativization
    : impl::NativizationBase<Nativization> {
  using NativizationBase::NativizationBase;

  void runOnOperation() {
    mlir::RewritePatternSet patterns(&getContext());
    patterns.add<NativizeGateConstructor>(&getContext());
    (void)applyPatternsAndFoldGreedily(getOperation(), std::move(patterns));
  }
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir
