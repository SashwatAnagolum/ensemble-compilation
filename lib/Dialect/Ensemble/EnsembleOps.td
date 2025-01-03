#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_

include "EnsembleDialect.td"
include "EnsembleTypes.td"


class Ensemble_GateOp<string mnemonic> : Op<Ensemble_Dialect, mnemonic>; 

class Ensemble_DistributionOp<string mnemonic> : Op<Ensemble_Dialect, mnemonic>; 

class Ensemble_DistributionBit<string mnemonic> : Op<Ensemble_Dialect, mnemonic>;

class Ensemble_UserInputOp<string mnemonic> : Op<Ensemble_Dialect, mnemonic>; 

// Qubit allocation

def Ensemble_ProgramAllocOp : Ensemble_UserInputOp<"program_alloc"> {
  let summary = "Allocate a tensor of qubits for a given circuit size.";
  let arguments = (ins I32Attr:$circuit_size);
  let results = (outs TensorOf<[PhysicalQubit]>:$output);
  let assemblyFormat = "$circuit_size attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 0;
}

def Ensemble_AllocCbitsOp : Ensemble_UserInputOp<"alloc_cbits"> {
  let summary = "Allocate a tensor of classical bits for a given circuit size.";
  let arguments = (ins I32Attr:$circuit_size);
  let results = (outs TensorOf<[Cbit]>:$output);
  let assemblyFormat = "$circuit_size attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 0;
}

// Gate operations
def Ensemble_GateConstructorOp : Ensemble_GateOp<"gate"> {
  let summary = "Gate constructor. Takes in a name, optional inverse annotation, and variadic floating point parameters.";
  let arguments = (ins StrAttr:$name, OptionalAttr<StrAttr>:$inverse, I32Attr:$num_operands,  Variadic<AnyFloat>:$parameters);
  let results = (outs Gate:$output);
  let assemblyFormat = "$name ($inverse^)? $num_operands (`(` $parameters^ `)`)? attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

def Ensemble_ApplyGate : Ensemble_GateOp<"apply"> {
  let summary = "Apply a deterministic gate to any number of qubits.";
  let arguments = (ins Gate:$gate, Variadic<AnyQubit>:$input);
  let results = (outs);
  let assemblyFormat = "$gate attr-dict $input `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

// Qubit measurement

def Ensemble_QubitMeasurement : Ensemble_GateOp<"measure"> {
  let summary = "Single qubit measurement to classical bit.";
  let arguments = (ins AnyQubit:$input0, Cbit:$input1);
  let results = (outs);
  let assemblyFormat = "$input0 `,` $input1 attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

// Qubit reset


def Ensemble_ResetQubits : Ensemble_GateOp<"reset"> {
  let summary = "variadic qubit reset.";
  let arguments = (ins Variadic<AnyQubit>:$input);
  let results = (outs);
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
  let results = (outs);
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
  let arguments = (ins GateDistribution:$gates, AnyIndexType:$index, Variadic<AnyQubit>:$inputs);
  let results = (outs);
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
    given shape if provided, otherwise a single integer.
  }];
  let arguments = (ins AnyInteger:$low, AnyInteger:$high,  Variadic<I32>:$shape);
  let results = (outs TensorOf<[AnyInteger]>:$result);
  let assemblyFormat = "$low `,` $high ( `,` `[` $shape^ `]`)? attr-dict `:` functional-type(operands, results)";  
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
  let arguments = (ins AnyInteger:$low, TensorOf<[AnyFloat]>:$probs, Variadic<I32>:$shape);
  let results = (outs TensorOf<[AnyInteger]>:$result);
  let assemblyFormat = "$low `,` $probs `,` `[` $shape `]` attr-dict `:` functional-type(operands, results)";  
  let hasVerifier = 0;
}

// random floating point distribution operations

def Ensemble_UniformFloatDistributionOp: Ensemble_DistributionOp<"float_uniform"> {
  let summary = "Uniform float distribution over low (inclusive) to high (exclusive).";
  let description = [{
    This operation generates random floats uniformly distributed between
    two bounds (`low` and `high`). The operation produces a tensor of the 
    given shape.
  }];
  let arguments = (ins AnyFloat:$low, AnyFloat:$high, Variadic<I32>:$shape);
  let results = (outs TensorOf<[AnyFloat]>:$result);
  let assemblyFormat = "$low `,` $high `,` `[` $shape `]` attr-dict `:` functional-type(operands, results)";  
  let hasVerifier = 1;
}


def Ensemble_CNOTPairDistributionOp: Ensemble_DistributionOp<"cnot_pair_distribution"> {
  let summary = "Distribution of non-overlapping CNOT pairs sampled from a connectivity graph.";
  let description = [{
    This operation generates random non-overlapping CNOT pairs sampled from a connectivity graph.
    The operation produces a tensor of the given shape, where each element is a pair of qubits.
  }];
  let arguments = (ins ConnectivityGraph:$connectivity, Variadic<I32>:$num_samples);
  let results = (outs TensorOf<[AnyQubit]>:$result);
  let assemblyFormat = "$connectivity `,` `[` $num_samples `]` attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

def Ensemble_PermutationOp: Ensemble_DistributionOp<"permutation"> {
  let summary = "Generates a random permutation of numbers from 0 to N-1.";
  let description = [{
    This operation generates a random permutation of numbers from 0 to N-1.
    The operation produces a tensor of the given shape.
  }];
  let arguments = (ins AnyInteger:$N);
  let results = (outs TensorOf<[AnyInteger]>:$result);
  let assemblyFormat = "$N attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

def Quantum_Program_Execution : Ensemble_UserInputOp<"quantum_program_iteration"> {
  let summary = "An operation that wraps multiple operations and contains all of the code for one iteration of a quantum program.";
  let description = [{
    This operation wraps a single region. The region can have multiple blocks, and
    the operation itself persists across transformations unless explicitly targeted.
  }];

  let regions = (region AnyRegion:$body); // Allow a single region
  let assemblyFormat = "$body attr-dict ";
  let hasVerifier = 0;
}

def TransmitResults : Ensemble_UserInputOp<"transmit_results"> {
  let summary = "Transmit results from a quantum program iteration.";
  let description = [{
    This operation transmits results from a quantum program iteration.
  }];
  let arguments = (ins TensorOf<[Cbit]>:$results);
  let results = (outs);
  let assemblyFormat = "$results attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 0;
  let traits = [Terminator];
}
def DeviceConnectivityOp : Ensemble_UserInputOp<"device_connectivity"> {
  let summary = "Create a connectivity graph for a device.";
  let description = [{
    This operation creates a connectivity graph for a device from a tensor of qubits and a dense array 
    of indices specifying the connectivity between qubits.
  }];
  let arguments = (ins TensorOf<[AnyQubit]>:$qubits, I32ElementsAttr:$indices);
  let results = (outs ConnectivityGraph:$connectivity);
  let assemblyFormat = "$qubits `,` `{` $indices `}` attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 0;
}


#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_TD_