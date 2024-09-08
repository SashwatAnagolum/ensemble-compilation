#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLETYPES_TD_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLETYPES_TD_

include "EnsembleDialect.td"
include "mlir/IR/AttrTypeBase.td"

// A base class for all types in this dialect
class Ensemble_Type<string name, string typeMnemonic> : TypeDef<Ensemble_Dialect, name> {
  let mnemonic = typeMnemonic;
}

def Qubit : Ensemble_Type<"Qubit", "qubit"> {
  let summary = "A qubit.";

  let description = [{
    A type representing a qubit.
  }];
}

def Cbit : Ensemble_Type<"Cbit", "cbit"> {

  let summary = "A classical bit."  

  let description = [{
    A type representing a classical bit.
  }]
}



#endif  // LIB_DIALECT_ENSEMBLE_ENSEMBLETYPES_TD_