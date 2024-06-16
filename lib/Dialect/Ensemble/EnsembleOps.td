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

def Ensemble_Gate2QOp : Op<Ensemble_Dialect, "gate2q"> {
  let summary = "Single qubit gate on a qubit.";
  let arguments = (ins Qubit:$input0, Qubit:$input1);
  let results = (outs Qubit:$output0, Qubit:$output1);
  let assemblyFormat = "$input0 `,` $input1 attr-dict `:` `(` type($input0) `,` type($input1) `)` `->` `(` type($output0) `,` type($output1) `)`";
}

#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_