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

struct CliffordDataRegression
    : impl::CliffordDataRegressionBase<CliffordDataRegression> {
  using CliffordDataRegressionBase::CliffordDataRegressionBase;

  void runOnOperation() {
    Operation *op = getOperation();

    CountGatelikeOps gateOpsCounter(op);
  }
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir
