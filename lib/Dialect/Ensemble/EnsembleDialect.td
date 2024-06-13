include "mlir/IR/DialectBase.td"

def Ensemble_Dialect: Dialect {
  let name = "ensemble";
  let summary = "A dialect for quantum circuit ensembles";
  let description = [{
    The ensemble dialect defines types and operations for ensembles of
    quantum circuits used for benchmarking of quantum devices,
    error mitigiated quantum programs, and randomized quantum applications.
  }];

  let cppNamespace = "::mlir::qe::ensemble";
}
