/*===- TableGen'erated file -------------------------------------*- C++ -*-===*\
|*                                                                            *|
|* Dialect Definitions                                                        *|
|*                                                                            *|
|* Automatically generated file, do not edit!                                 *|
|* From: QuantumEnsembleDialect.td                                            *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

MLIR_DEFINE_EXPLICIT_TYPE_ID(::qe::QuantumEnsembleDialect)
namespace qe {

QuantumEnsembleDialect::QuantumEnsembleDialect(::mlir::MLIRContext *context)
    : ::mlir::Dialect(getDialectNamespace(), context, ::mlir::TypeID::get<QuantumEnsembleDialect>())
    
     {
  
  initialize();
}

QuantumEnsembleDialect::~QuantumEnsembleDialect() = default;

} // namespace qe
