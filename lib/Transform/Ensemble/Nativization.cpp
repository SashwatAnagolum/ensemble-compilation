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
    auto zero = rewriter.create<arith::ConstantOp>(loc, rewriter.getF64FloatAttr(0.0));
    auto pi = rewriter.create<arith::ConstantOp>(loc, rewriter.getF64FloatAttr(3.14159265358979323846));
    auto pi_half = rewriter.create<arith::ConstantOp>(loc, rewriter.getF64FloatAttr(1.57079632679489661923));
    auto neg_pi_half = rewriter.create<arith::ConstantOp>(loc, rewriter.getF64FloatAttr(-1.57079632679489661923));
    auto neg_one = rewriter.create<arith::ConstantOp>(loc, rewriter.getF64FloatAttr(-1.0));

    // Create the U3 operation after defining all constants
    auto u3 = rewriter.clone(*op.getOperation());
    u3->setAttr("name", rewriter.getStringAttr("U3"));

    // set insertion point before the u3 op by setting it after the previous op
    rewriter.setInsertionPointAfter(u3->getPrevNode());
    


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
    else if (gateName == "SDag") {
        // SDag gate has parameters u3(0, 0, -pi/2)
        u3->setOperands({zero, zero, neg_pi_half});
    }
    else if (gateName == "RX") {
        // RX gate has parameters RX(θ)=U3(θ,−π/2,π/2)
        auto theta = op.getOperation()->getOperand(0);
        u3->setOperands({theta, neg_pi_half, pi_half});
    }
    else if (gateName == "RY") {
        // RY gate has parameters RY(θ)=U3(θ,0,0)
        auto theta = op.getOperation()->getOperand(0);
        u3->setOperands({theta, zero, zero});
    }
    else if (gateName == "RZ") {
        // RZ gate has parameters RZ(θ)=U3(0,−θ/2,θ/2)
        auto theta = op.getOperation()->getOperand(0);
        
        auto half = rewriter.create<arith::ConstantOp>(loc, rewriter.getF64FloatAttr(0.5));
        auto theta_times_half = rewriter.create<arith::MulFOp>(loc, theta, half);
        auto neg_theta_half = rewriter.create<arith::MulFOp>(loc, theta_times_half, neg_one);
        u3->setOperands({zero, neg_theta_half, theta_times_half});
    }
    else if (gateName == "SX") {
        // SX gate has parameters SX=U3(π/2,−π/2,π/2)
        u3->setOperands({pi_half, neg_pi_half, pi_half});
    }

    else if (gateName == "SXdag") {
        // SXdag gate has parameters SXdag=U3(π/2,π/2,−π/2)
        u3->setOperands({pi_half, pi_half, neg_pi_half});
    }

    else if (gateName == "U3") {
        // U3 gate has parameters U3(θ,ϕ,λ)
        auto theta = op.getOperation()->getOperand(0);
        auto phi = op.getOperation()->getOperand(1);
        auto lambda = op.getOperation()->getOperand(2);
        u3->setOperands({theta, phi, lambda});
    }
    
    else {
        u3->setOperands({zero, zero, zero});
    }

    // if the original gate has a inverse attribute that has the value transpose, do this to the u3 op: U3 †(θ,ϕ,λ)=U3(−θ,−λ,−ϕ)
    // do this by using the arith dialect to multiply the original values by -1.0 using arith.mulf
    if (op.getOperation()->hasAttr("inverse") && op.getOperation()->getAttr("inverse").cast<StringAttr>().getValue() == "transpose") {
        auto operands = u3->getOperands();
        auto theta = operands[0];
        auto lambda = operands[1];
        auto phi = operands[2];

        auto neg_theta = rewriter.create<arith::MulFOp>(loc, theta, neg_one);
        auto neg_lambda = rewriter.create<arith::MulFOp>(loc, lambda, neg_one);
        auto neg_phi = rewriter.create<arith::MulFOp>(loc, phi, neg_one);

        u3->setOperands({neg_theta, neg_lambda, neg_phi});
    }

    // Ensure the U3 operation is inserted after all operands are defined
    rewriter.setInsertionPointAfter(u3);

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
