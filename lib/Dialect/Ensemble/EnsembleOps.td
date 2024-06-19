#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_

include "EnsembleDialect.td"
include "EnsembleTypes.td"

class Ensemble_GateOp<string mnemonic> : Op<Ensemble_Dialect, mnemonic>; 

def Ensemble_Gate1QOp : Ensemble_GateOp<"gate1q"> {
  let summary = "Single qubit gate on a qubit.";
  let arguments = (ins Qubit:$input, StrAttr:$gateName);
  let results = (outs Qubit:$output);
  let assemblyFormat = "$gateName $input attr-dict `:` `(` type($input) `)` `->`  `(` type($output) `)`";
}

def Ensemble_Gate2QOp : Ensemble_GateOp<"gate2q"> {
  let summary = "Single qubit gate on a qubit.";
  let arguments = (ins Qubit:$input0, Qubit:$input1, StrAttr:$gateName);
  let results = (outs Qubit:$output0, Qubit:$output1);
  let assemblyFormat = "$gateName $input0 `,` $input1 attr-dict `:` `(` type($input0) `,` type($input1) `)` `->` `(` type($output0) `,` type($output1) `)`";
}

#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_