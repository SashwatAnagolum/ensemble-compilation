#include "lib/Dialect/Ensemble/EnsembleDialect.h"

#include "lib/Dialect/Ensemble/EnsembleTypes.h"
#include "llvm/include/llvm/ADT/TypeSwitch.h"
#include "mlir/include/mlir/IR/Builders.h"

//

#include "lib/Dialect/Ensemble/EnsembleDialect.cpp.inc"
#define GET_TYPEDEF_CLASSES
#include "lib/Dialect/Ensemble/EnsembleTypes.cpp.inc"

namespace mlir {
namespace qe {
namespace ensemble {

void EnsembleDialect::initialize() {
  // This is where we will register types and operations with the dialect
  addTypes<
#define GET_TYPEDEF_LIST
#include "lib/Dialect/Ensemble/EnsembleTypes.cpp.inc"
      >();
}

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir