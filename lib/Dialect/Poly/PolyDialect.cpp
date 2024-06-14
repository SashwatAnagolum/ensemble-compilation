#include "lib/Dialect/Poly/PolyDialect.h"

#include "lib/Dialect/Poly/PolyTypes.h"
#include "llvm/include/llvm/ADT/TypeSwitch.h"
#include "mlir/include/mlir/IR/Builders.h"

//

#include "lib/Dialect/Poly/PolyDialect.cpp.inc"
#define GET_TYPEDEF_CLASSES
#include "lib/Dialect/Poly/PolyTypes.cpp.inc"

namespace mlir {
namespace qe {
namespace poly {

void PolyDialect::initialize() {
  // This is where we will register types and operations with the dialect
  addTypes<
#define GET_TYPEDEF_LIST
#include "lib/Dialect/Poly/PolyTypes.cpp.inc"
      >();
}

}  // namespace poly
}  // namespace qe
}  // namespace mlir