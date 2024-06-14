#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_

include "EnsembleDialect.td"
include "EnsembleTypes.td"

def Ensemble_Gate1QOp : Op<Ensemble_Dialect, "gate1q"> {
  let summary = "Single qubit gate on a qubit.";
  let arguments = (ins Qubit:$input);
  let results = (outs Qubit:$output);
  let assemblyFormat = "$input attr-dict `:` `(` type($input) `)` `->` type($output)";
}

#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_