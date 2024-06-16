#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_

include "EnsembleDialect.td"
include "EnsembleTypes.td"

def Ensemble_AddOp : Op<Ensemble_Dialect, "add"> {
  let summary = "Addition operation between polynomials.";
  let arguments = (ins Qubit:$lhs, Qubit:$rhs);
  let results = (outs Qubit:$output);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` `(` type($lhs) `,` type($rhs) `)` `->` type($output)";
}

#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_