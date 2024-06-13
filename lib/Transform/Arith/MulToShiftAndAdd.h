#ifndef LIB_TRANSFORM_ARITH_MULTOSHIFTANDADD_H_
#define LIB_TRANSFORM_ARITH_MULTOSHIFTANDADD_H_

#include "mlir/Pass/Pass.h"

namespace mlir {
namespace qe {

#define GEN_PASS_DECL_MULTOSHIFTANDADD
#include "lib/Transform/Arith/Passes.h.inc"

}  // namespace qe
}  // namespace mlir

#endif  // LIB_TRANSFORM_ARITH_MULTOSHIFTANDADD_H_