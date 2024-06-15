#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_H_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_H_

#include "lib/Dialect/Ensemble/EnsembleDialect.h"
#include "lib/Dialect/Ensemble/EnsembleTypes.h"

//

#include "mlir/include/mlir/IR/BuiltinOps.h"    // from @llvm-project
#include "mlir/include/mlir/IR/BuiltinTypes.h"  // from @llvm-project
#include "mlir/include/mlir/IR/Dialect.h"       // from @llvm-project

#define GET_OP_CLASSES
#include "lib/Dialect/Ensemble/EnsembleOps.h.inc"

#endif  // #ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLEOPS_H_