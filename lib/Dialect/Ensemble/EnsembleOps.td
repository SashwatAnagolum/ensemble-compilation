#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_

include "EnsembleDialect.td"
include "EnsembleTypes.td"

class Ensemble_GateOp<string mnemonic> : Op<Ensemble_Dialect, mnemonic>; 

class Ensemble_DistributionOp<string mnemonic> : Op<Ensemble_Dialect, mnemonic>; 

class Ensemble_UserInputOp<string mnemonic> : Op<Ensemble_Dialect, mnemonic>; 

// Gate operations
 
def Ensemble_Gate1QOp : Ensemble_GateOp<"gate1q"> {
  let summary = "Single qubit gate on a qubit.";
  let arguments = (ins Qubit:$input, StrAttr:$gateName);
  let results = (outs Qubit:$output);
  let assemblyFormat = "$gateName attr-dict $input `:` `(` type($input) `)` `->`  `(` type($output) `)`";
}

def Ensemble_Gate2QOp : Ensemble_GateOp<"gate2q"> {
  let summary = "Two qubit gate on two qubits.";
  let arguments = (ins Qubit:$input0, Qubit:$input1, StrAttr:$gateName);
  let results = (outs Qubit:$output0, Qubit:$output1);
  let assemblyFormat = "$gateName attr-dict $input0 `,` $input1 `:` `(` type($input0) `,` type($input1) `)` `->` `(` type($output0) `,` type($output1) `)`";
}

// Gate distribution operations

def Ensemble_GateDistribution1QOp : Ensemble_GateOp<"gate_distribution_1q"> {
  let summary = "Gate distribution on a qubit.";
  let arguments = (ins Qubit:$input, I32:$index, StrArrayAttr:$gateNames);
  let results = (outs Qubit:$output);
  let assemblyFormat = "$gateNames `[` $index `]` attr-dict $input `:` functional-type(operands, results)";
}

def Ensemble_GateDistribution2QOp : Ensemble_GateOp<"gate_distribution_2q"> {
  let summary = "Gate distribution on two qubits.";
  let arguments = (ins Qubit:$input0, Qubit:$input1, I32:$index, StrArrayAttr:$gateNames);
  let results = (outs Qubit:$output0, Qubit:$output1);
  let assemblyFormat = "$gateNames `[` $index `]` attr-dict $input0 `,` $input1 `:` `(` type($input0) `,` type($input1) `,` type($index) `)` `->` `(` type($output0) `,` type($output1) `)`";
}

// Integer and floating-point distribution operations

def Ensemble_UniformIntegerDistributionOp: Ensemble_DistributionOp<"int_uniform"> {
  let summary = "Uniform integer distribution over low (inclusive) to high (exclusive).";
  let arguments = (ins I32Attr:$low, I32Attr:$high);
  let results = (outs I32:$output);
  let assemblyFormat = "$low `,` $high attr-dict `:` functional-type(operands, results)";  
}

def Ensemble_CategoricalIntegerDistributionOp: Ensemble_DistributionOp<"int_categorical"> {
  let summary = "Categorical integer distribution over low (inclusive) to low + len(probs) (exclusive).";
  let arguments = (ins I32Attr:$low, DenseF32ArrayAttr:$probs);
  let results = (outs I32:$output);
  let assemblyFormat = "$low `,` $probs attr-dict `:` functional-type(operands, results)";  
}

#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_