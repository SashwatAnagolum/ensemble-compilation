#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLETYPES_TD_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLETYPES_TD_

include "EnsembleDialect.td"
include "mlir/IR/AttrTypeBase.td"

// A base class for all types in this dialect
class Ensemble_Type<string name, string typeMnemonic> : TypeDef<Ensemble_Dialect, name> {
  let mnemonic = typeMnemonic;
}



// Define VirtualQubit and PhysicalQubit types
def VirtualQubit : Ensemble_Type<"VirtualQubit", "virtual_qubit"> {
  let summary = "A virtual qubit.";
  let description = [{
    A type representing a virtual qubit in the Ensemble dialect.
  }];
}

def PhysicalQubit : Ensemble_Type<"PhysicalQubit", "physical_qubit"> {
  let summary = "A physical qubit.";
  let description = [{
    A type representing a physical qubit in the Ensemble dialect.
  }];
}


// Define an alias for AnyTypeOf<[VirtualQubit, PhysicalQubit]>
def AnyQubit : AnyTypeOf<[VirtualQubit, PhysicalQubit]>;
// can support variable number of qubits and tensors of qubits

def AnyIntegerConstant : AnyTypeOf<[AnyInteger]>;
def AnyIndexType : AnyTypeOf<[Index, AnyInteger]>;

def Cbit : Ensemble_Type<"Cbit", "cbit"> {
  let summary = "A classical bit.";  
  let description = [{
    A type representing a classical bit.
  }];
}

// gate type used 
def Gate : Ensemble_Type<"Gate", "gate"> {
  let summary = "A gate.";
  let description = [{
    A type representing a gate.
  }];
}

def GateDistribution : Ensemble_Type<"GateDistribution", "gate_distribution"> {
  let summary = "A gate distribution.";
  let description = [{
    A type representing a gate distribution. (this is similar to a tensor of gates, but the 
    verifier will check that the number of qubits in each gate matches the number of qubits 
    in the distribution)
  }];
}



#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLETYPES_TD_