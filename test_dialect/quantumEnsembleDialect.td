include "mlir/IR/DialectBase.td"
include "mlir/IR/OpBase.td"

// Define the dialect using a TableGen class
def QuantumEnsemble_Dialect: Dialect {
  let summary = "Dialect for ensembles of quantum circuits.";

  let description = [{
    The QuantumEnsemble Dialect is an MLIR dialect that allows
    the declaration of randomized and error-mitigated quantum programs
    in a concise and convenient way.
  }];

  /// This is the namespace of the dialect. It is used to encapsulate the sub-components
  /// of the dialect, such as operations ("my_dialect.foo").
  let name = "qe";

  /// The C++ namespace that the dialect, and its sub-components, get placed in.
  let cppNamespace = "::qe";
}

// ===----------------------------------------------------------------------===//
// Quantum Ensemble Types
// ===----------------------------------------------------------------------===//

// ===Type Base Class=== //
// Base class for all types in our dialect
// mnemonic: the string name for the operation
// description: the description of the type
class QE_Type<string mnemonic, list<Trait> traits = []>:
  TypeDef<QuantumEnsemble_Dialect,mnemonic, traits>;

// ===Qubit Type=== //
def QubitType: QE_Type<"QubitType"> {
}

// ===----------------------------------------------------------------------===//
// Quantum Ensemble Operations
// ===----------------------------------------------------------------------===//

// ===Op Base Class=== //
// Base class for all operations in our dialect
// mnemonic: the string name for the operation
// traits: a list of traits that describe the operation
class QE_Op<string mnemonic, list<Trait> traits = []>:
  Op<QuantumEnsemble_Dialect, mnemonic, traits>;

// ===Generic Gate Op=== //
class QuantumGate_Op<string mnemonic, list<OpTrait> traits = []>:
  QE_Op<mnemonic, traits>;

// ===X Gate Op=== //
def XGateOp: QuantumGate_Op<"X"> {
}
