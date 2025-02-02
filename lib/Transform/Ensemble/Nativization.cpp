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

struct Nativization
    : impl::NativizationBase<Nativization> {
  using NativizationBase::NativizationBase;

  void runOnOperation() {
    mlir::RewritePatternSet patterns(&getContext());
    (void)applyPatternsAndFoldGreedily(getOperation(), std::move(patterns));
  }
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir
