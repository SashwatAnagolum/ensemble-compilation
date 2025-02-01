#include "lib/Transform/Ensemble/CliffordDataRegression.h"

#include <iostream>

#include "lib/Dialect/Ensemble/EnsembleOps.h"
#include "lib/Dialect/Ensemble/EnsembleTypes.h"
#include "lib/Analysis/CountGatelikeOps/CountGatelikeOps.h"

//

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/include/mlir/Pass/Pass.h"

namespace mlir {
namespace qe {
namespace ensemble {

#define GEN_PASS_DEF_CLIFFORDDATAREGRESSION
#include "lib/Transform/Ensemble/Passes.h.inc"

using arith::ConstantOp;

struct AddRandomGateIndexSamples : public OpRewritePattern<QuantumProgramIteration> {
    int numGates = 0;

    AddRandomGateIndexSamples(mlir::MLIRContext *context, int numGates) 
        : OpRewritePattern<QuantumProgramIteration>(context, 1) {
        this->numGates = numGates;
    }

    LogicalResult matchAndRewrite(QuantumProgramIteration op, PatternRewriter &rewriter) const override {
        if (op->getAttr("random-samples-added")) {
            return failure();
        }

        // get first region of op, set in sertion point to begining of region
        for (Operation &childOp : op.getRegion().getOps()) {
            llvm::outs() << childOp.getName() << "\n";
        }
        // add a new UniformIntegerDistribution op with shape equal to
        // the output of the gate count analysis pass
    
        // prevent infinite application of the pass
        rewriter.updateRootInPlace(op, [&]() { 
            op->setAttr("random-samples-added", rewriter.getUnitAttr()); 
        });

        return success();
    }
};

struct CliffordDataRegression
    : impl::CliffordDataRegressionBase<CliffordDataRegression> {
  using CliffordDataRegressionBase::CliffordDataRegressionBase;

  void runOnOperation() {
    Operation *op = getOperation();
    CountGatelikeOps gateOpsCounter(op);

    mlir::RewritePatternSet patterns(&getContext());
    patterns.add<AddRandomGateIndexSamples>(
        &getContext(), gateOpsCounter.getGatelikeOpsCount()
    );

    (void)applyPatternsAndFoldGreedily(op, std::move(patterns));
  }
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir
