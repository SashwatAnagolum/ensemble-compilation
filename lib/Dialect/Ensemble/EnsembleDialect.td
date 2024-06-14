#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLEDIALECT_TD_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLEDIALECT_TD_

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
  let useDefaultTypePrinterParser = 1;
}

#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLEDIALECT_TD_