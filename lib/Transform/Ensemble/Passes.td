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

def CliffordDataRegression : Pass<"clifford-data-regression"> {
  let summary = "Transform a circuit to apply clifford data regression";
  let description = [{
    Transform a circuit to apply clifford data regression
  }];
  let dependentDialects = [
    "mlir::arith::ArithDialect",
    "mlir::qe::ensemble::EnsembleDialect"
  ];
}

def PDagParse : Pass<"pdag-parse"> {
  let summary = "Parse the PDAG";
  let description = [{
    Parse the PDAG
  }];
  let dependentDialects = [
    "mlir::affine::AffineDialect",
    "mlir::arith::ArithDialect",
    "mlir::qe::ensemble::EnsembleDialect",
    
  ];
}

def Inlinex : Pass<"inlinex"> {
  let summary = "Inline function calls in the circuit";
  let description = [{
    Inline function calls in the circuit
  }];
  let dependentDialects = [
    "mlir::affine::AffineDialect",
    "mlir::arith::ArithDialect",
    "mlir::func::FuncDialect",
    "mlir::qe::ensemble::EnsembleDialect",
  ];
}

def Nativization : Pass<"nativization"> {
  let summary = "Apply nativization to the circuit";
  let description = [{
    Apply nativization to the circuit
  }];
  let dependentDialects = [
    "mlir::affine::AffineDialect",
    "mlir::arith::ArithDialect",
    "mlir::qe::ensemble::EnsembleDialect",
  ];
}

def SCFToAffine : Pass<"scf-to-affine"> {
  let summary = "Convert SCF loops to Affine loops";
  let description = [{
    Convert SCF loops to Affine loops
  }];
  let dependentDialects = [
    "mlir::affine::AffineDialect",
    "mlir::arith::ArithDialect",
    "mlir::scf::SCFDialect",
  ];
}

def GateMerging : Pass<"gate-merging"> {
  let summary = "Merge gates in the circuit";
  let description = [{
    Merge gates in the circuit
  }];
  let dependentDialects = [
    "mlir::affine::AffineDialect",
    "mlir::arith::ArithDialect",
    "mlir::qe::ensemble::EnsembleDialect",
  ];
}
#endif  // LIB_TRANSFORM_ENSEMBLE_PASSES_TD_
