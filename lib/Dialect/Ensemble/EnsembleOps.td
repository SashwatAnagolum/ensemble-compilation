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

def Ensemble_2QGateOp : Op<Ensemble_Dialect, "2qgate"> {
  let summary = "Two qubit gate.";
  let arguments = (ins Qubit:$qubitIn0, Qubit:$qubitIn1);
  let results = (outs Qubit:$qubitOut0, Qubit:qubitOut1);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` `(` type($qubitIn0) `,` type($qubitIn1) `)` `->` `(` type($qubitOut0) `,` type($qubitOut1) `)`";
}

#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_