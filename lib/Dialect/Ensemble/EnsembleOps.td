#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_

include "EnsembleDialect.td"
include "EnsembleTypes.td"


class Ensemble_GateOp<string mnemonic> : Op<Ensemble_Dialect, mnemonic>; 

class Ensemble_DistributionOp<string mnemonic> : Op<Ensemble_Dialect, mnemonic>; 

class Ensemble_DistributionBit<string mnemonic> : Op<Ensemble_Dialect, mnemonic>;

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

// Qubit measurement

def Ensemble_QubitMeasurement : Ensemble_GateOp<"measure"> {
  let summary = "Single qubit measurement to classical bit.";
  let arguments = (ins Qubit:$input0, Cbit:$input1);
  let results = (outs Qubit:$output0, Cbit:$output1);
  let assemblyFormat = "$input0 `,` $input1 attr-dict `:` functional-type(operands, results)";
}

// Qubit reset

def Ensemble_Reset1Q : Ensemble_GateOp<"1q_reset"> {
  let summary = "Single qubit reset.";
  let arguments = (ins Qubit:$input);
  let results = (outs Qubit:$output);
  let assemblyFormat = "attr-dict $input `:` `(` type($input) `)` `->` `(` type($output) `)`";
}

//
def Ensemble_ResetNQ : Ensemble_GateOp<"Nq_reset"> {
  let summary = "Qubit tensor reset.";
  let arguments = (ins TensorOf<[Qubit]>:$input);
  let results = (outs TensorOf<[Qubit]>:$output);
  let assemblyFormat = "attr-dict $input `:` `(` type($input) `)` `->` `(` type($output) `)`";
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

// Qubit distribution operations

def Ensemble_QubitDistribution : Ensemble_DistributionBit<"qubit_distribution_1q"> {
  let summary = "Qubit distribution sampled from by an integer";
  let arguments = (ins I32:$index, Variadic<Qubit>:$input);
  let results = (outs Qubit:$output);
  let assemblyFormat = "$input `[` $index `]` attr-dict `:` `(` type($input) `)` `->` `(` type($output) `)`";
}

// Cbit distribution operations

def Ensemble_CbitDistribution : Ensemble_DistributionBit<"cbit_distribution_1c"> {
  let summary = "Cbit distribution sampled from by an integer";
  let arguments = (ins I32:$index, Variadic<Cbit>:$input);
  let results = (outs Cbit:$output);
  let assemblyFormat = "$input `[` $index `]` attr-dict `:` `(` type($input) `)` `->` `(` type($output) `)`";
}


// Integer and floating-point distribution operations

def Ensemble_UniformIntegerDistributionOp: Ensemble_DistributionOp<"int_uniform"> {
  let summary = "Uniform integer distribution over low (inclusive) to high (exclusive).";
  let description = [{
    This operation generates random integers uniformly distributed between
    two bounds (`low` and `high`). The operation produces a tensor of the 
    given shape.
  }];
  let arguments = (ins I32Attr:$low, I32Attr:$high, DenseI32ArrayAttr:$shape);
  let results = (outs TensorOf<[AnyInteger]>:$result);
  let assemblyFormat = "$low `,` $high `,`  $shape attr-dict `:` functional-type(operands, results)";  
}

def Ensemble_CategoricalIntegerDistributionOp: Ensemble_DistributionOp<"int_categorical"> {
  let summary = "Categorical integer distribution over low (inclusive) to low + len(probs) (exclusive).";
  let description = [{
    This operation generates random integers non-uniformly distributed between
    two bounds (`low` and `low + len(probs)`)., with each integer being produced with probability
    equal to the magnitude of the corresponding probability argument. The operation produces a tensor of the 
    given shape.
  }];
  let arguments = (ins I32Attr:$low, DenseF32ArrayAttr:$probs,  DenseI32ArrayAttr:$shape);
  let results = (outs TensorOf<[AnyInteger]>:$result);
  let assemblyFormat = "$low `,` $probs `,` $shape attr-dict `:` functional-type(operands, results)";  
}

#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_