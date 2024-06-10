/*===- TableGen'erated file -------------------------------------*- C++ -*-===*\
|*                                                                            *|
|* Dialect Declarations                                                       *|
|*                                                                            *|
|* Automatically generated file, do not edit!                                 *|
|* From: QuantumEnsembleDialect.td                                            *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

namespace qe {

class QuantumEnsembleDialect : public ::mlir::Dialect {
  explicit QuantumEnsembleDialect(::mlir::MLIRContext *context);

  void initialize();
  friend class ::mlir::MLIRContext;
public:
  ~QuantumEnsembleDialect() override;
  static constexpr ::llvm::StringLiteral getDialectNamespace() {
    return ::llvm::StringLiteral("qe");
  }
};
} // namespace qe
MLIR_DECLARE_EXPLICIT_TYPE_ID(::qe::QuantumEnsembleDialect)
