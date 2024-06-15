#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_

include "EnsembleDialect.td"
include "EnsembleTypes.td"

// Base class for all Ensemble operations
class Ensemble_Op<string name> : Op<Ensemble_Dialect, name> {
}

def Ensemble_1QGateOp : Ensemble_Op<"1qgate"> {
  let summary = "Gate operation on a qubit.";
  let arguments = (ins Qubit:$qubitIn0);
  let results = (outs Qubit:$qubitOut0);
  let assemblyFormat = "$qubitIn0 attr-dict `:` `(` type($qubitIn0) `)` `->` type($qubitOut0)";
}

def Ensemble_2QGateOp : Ensemble_Op<"2qgate"> {
  let summary = "Gate operation on two qubits.";
  let arguments = (ins Qubit:$qubitIn0, Qubit:$qubitIn1);
  let results = (outs Qubit:$qubitOut0, Qubit:$qubitOut1);
  let assemblyFormat = "$qubitIn0 `,` $qubitIn1 attr-dict `:` `(` type($qubitIn0) `,` type($qubitIn1) `)` `->` `(` type($qubitOut0) `,` type($qubitOut1) `)`";
}

#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_