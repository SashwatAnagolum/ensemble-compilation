include "mlir/IR/DialectBase.td"

// ===----------------------------------------------------------------------===//
// Quantum Ensemble Dialect
// ===----------------------------------------------------------------------===//
def QuantumEnsemble_Dialect: Dialect {
  let summary = "Dialect for ensembles of quantum circuits.";

  let description = [{
    The QuantumEnsemble Dialect is an MLIR dialect that allows
    the declaration of randomized and error-mitigated quantum programs
    in a concise and convenient way.
  }];

  // This is the namespace of the dialect. It is used to encapsulate the sub-components
  // of the dialect, such as operations ("my_dialect.foo").
  let name = "qe";

  // The C++ namespace that the dialect, and its sub-components, get placed in.
  let cppNamespace = "::qe";
}
