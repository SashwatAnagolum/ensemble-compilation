#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_

include "EnsembleDialect.td"
include "EnsembleTypes.td"

def Ensemble_1QGateOp : Op<Ensemble_Dialect, "1qgate"> {
  let summary = "Single qubit gate.";
  let arguments = (ins Qubit:$qubitIn0);
  let results = (outs Qubit:$qubitOut0);
  let assemblyFormat = "$qubitIn0 attr-dict `:` `(` type($qubitIn0) `)` `->` type($qubitOut0)";
}

#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_