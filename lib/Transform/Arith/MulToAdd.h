#ifndef LIB_TRANSFORM_ARITH_MULTOADD_H_
#define LIB_TRANSFORM_ARITH_MULTOADD_H_

#include "mlir/Pass/Pass.h"

namespace mlir {
namespace qe {

#define GEN_PASS_DECL_MULTOADD
#include "lib/Transform/Arith/Passes.h.inc"

}  // namespace qe
}  // namespace mlir

#endif  // LIB_TRANSFORM_ARITH_MULTOADD_H_