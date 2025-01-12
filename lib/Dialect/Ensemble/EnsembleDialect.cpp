#include "lib/Dialect/Ensemble/EnsembleDialect.h"

#include "lib/Dialect/Ensemble/EnsembleOps.h"
#include "lib/Dialect/Ensemble/EnsembleTypes.h"

//

#include "llvm/include/llvm/ADT/TypeSwitch.h"
#include "mlir/include/mlir/IR/Builders.h"

//

#include "lib/Dialect/Ensemble/EnsembleDialect.cpp.inc"
#define GET_TYPEDEF_CLASSES
#include "lib/Dialect/Ensemble/EnsembleTypes.cpp.inc"
#define GET_OP_CLASSES
#include "lib/Dialect/Ensemble/EnsembleOps.cpp.inc"

#include "lib/Dialect/Ensemble/EnsembleInlinerInterface.h"
#include "mlir/IR/Region.h"
#include "mlir/IR/Value.h"
#include "mlir/IR/Block.h"

namespace mlir {
namespace qe {
namespace ensemble {

void EnsembleDialect::initialize() {
  // Add all of the types for the Ensemble dialect
  addTypes<
#define GET_TYPEDEF_LIST
#include "lib/Dialect/Ensemble/EnsembleTypes.cpp.inc"
      >();

  // Add all of the operations for the Ensemble dialect
  addOperations<
#define GET_OP_LIST
#include "lib/Dialect/Ensemble/EnsembleOps.cpp.inc"
      >();

  addInterfaces<EnsembleInlinerInterface>();
}

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir