#ifndef LIB_TRANSFORM_ENSEMBLE_PASSES_TD_
#define LIB_TRANSFORM_ENSEMBLE_PASSES_TD_

include "mlir/Pass/PassBase.td"

def ZeroNoiseExtrapolation : Pass<"zero-noise-extrapolation"> {
  let summary = "Transform a circuit to apply zero noise extrapolation";
  let description = [{
    Transform a circuit to apply zero noise extrapolation
  }];
  let dependentDialects = [
    "mlir::affine::AffineDialect",
    "mlir::arith::ArithDialect",
    "mlir::qe::ensemble::EnsembleDialect"
  ];
}

#endif  // LIB_TRANSFORM_ENSEMBLE_PASSES_TD_