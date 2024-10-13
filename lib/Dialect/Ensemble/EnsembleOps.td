#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_

include "EnsembleDialect.td"
include "EnsembleTypes.td"


class Ensemble_GateOp<string mnemonic> : Op<Ensemble_Dialect, mnemonic>; 

class Ensemble_DistributionOp<string mnemonic> : Op<Ensemble_Dialect, mnemonic>; 

class Ensemble_DistributionBit<string mnemonic> : Op<Ensemble_Dialect, mnemonic>;

class Ensemble_UserInputOp<string mnemonic> : Op<Ensemble_Dialect, mnemonic>; 

// Gate operations
def Ensemble_GateConstructorOp : Ensemble_GateOp<"gate"> {
  let summary = "Gate constructor. Takes in a name, optional inverse annotation, and variadic floating point parameters.";
  let arguments = (ins StrAttr:$name, OptionalAttr<StrAttr>:$inverse, I32Attr:$num_operands,  Variadic<F32>:$parameters);
  let results = (outs Gate:$output);
  let assemblyFormat = "$name ($inverse^)? $num_operands (`(` $parameters^ `)`)? attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

def Ensemble_ApplyGate : Ensemble_GateOp<"apply"> {
  let summary = "Apply a deterministic gate to any number of qubits.";
  let arguments = (ins Gate:$gate, Variadic<AnyQubit>:$input);
  let results = (outs Variadic<AnyQubit>:$output);
  let assemblyFormat = "$gate attr-dict $input `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

// Qubit measurement

def Ensemble_QubitMeasurement : Ensemble_GateOp<"measure"> {
  let summary = "Single qubit measurement to classical bit.";
  let arguments = (ins AnyQubit:$input0, Cbit:$input1);
  let results = (outs AnyQubit:$output0, Cbit:$output1);
  let assemblyFormat = "$input0 `,` $input1 attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

// Qubit reset


def Ensemble_ResetQubits : Ensemble_GateOp<"reset"> {
  let summary = "variadic qubit reset.";
  let arguments = (ins Variadic<AnyQubit>:$input);
  let results = (outs Variadic<AnyQubit>:$output);
  let assemblyFormat = "attr-dict $input `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

// make one for tensor of qubits
def Ensemble_ResetQubitTensor : Ensemble_GateOp<"reset_tensor"> {
  let summary = "Reset a tensor of qubits.";
  let description = [{
    This operation resets all qubits in a given tensor to their ground state.
    It takes a tensor of qubits as input and returns a tensor of reset qubits of the same shape.
  }];
  let arguments = (ins TensorOf<[AnyQubit]>:$input);
  let results = (outs TensorOf<[AnyQubit]>:$output);
  let assemblyFormat = "attr-dict $input `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

// Gate distribution constructor that accepts a variable number of gates 

def Ensemble_GateDistributionConstructor : Ensemble_GateOp<"gate_distribution"> {
  let summary = "Gate distribution constructor that accepts a variable number of gates";
  let arguments = (ins Variadic<Gate>:$gates);
  let results = (outs GateDistribution:$output);
  let assemblyFormat = "$gates attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}


// Gate distribution operations
def Ensemble_ApplyGateDistribution : Ensemble_GateOp<"apply_distribution"> {
  let summary = "Gate distribution on a variable number of qubits and gates";
  let arguments = (ins GateDistribution:$gates, I32:$index, Variadic<AnyQubit>:$inputs);
  let results = (outs Variadic<AnyQubit>:$outputs);
  let assemblyFormat = "$gates `[` $index `]` attr-dict $inputs `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

// Qubit distribution operations

def Ensemble_QubitDistribution : Ensemble_DistributionBit<"qubit_distribution_1q"> {
  let summary = "Qubit distribution sampled from by an integer";
  let arguments = (ins Variadic<AnyQubit>:$input, I32:$index );
  let results = (outs AnyQubit:$output);
  let assemblyFormat = "$input `[` $index `]` attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

// Cbit distribution operations
def Ensemble_CbitDistribution : Ensemble_DistributionBit<"cbit_distribution_1c"> {
  let summary = "Cbit distribution sampled from by an integer";
  let arguments = (ins Variadic<Cbit>:$input, I32:$index);
  let results = (outs Cbit:$output);
  let assemblyFormat = "$input `[` $index `]` attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
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
  let hasVerifier = 1;
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
  let hasVerifier = 1;
}

// random floating point distribution operations

def Ensemble_UniformFloatDistributionOp: Ensemble_DistributionOp<"float_uniform"> {
  let summary = "Uniform float distribution over low (inclusive) to high (exclusive).";
  let description = [{
    This operation generates random floats uniformly distributed between
    two bounds (`low` and `high`). The operation produces a tensor of the 
    given shape.
  }];
  let arguments = (ins F32Attr:$low, F32Attr:$high, DenseI32ArrayAttr:$shape);
  let results = (outs TensorOf<[AnyFloat]>:$result);
  let assemblyFormat = "$low `,` $high `,` $shape attr-dict `:` functional-type(operands, results)";  
  let hasVerifier = 1;
}

#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_