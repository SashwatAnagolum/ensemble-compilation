#ifndef LIB_TRANSFORM_AFFINE_AFFINEFULLUNROLL_H_
#define LIB_TRANSFORM_AFFINE_AFFINEFULLUNROLL_H_

#include "mlir/Pass/Pass.h"

namespace mlir {
namespace qe {

#define GEN_PASS_DECL_AFFINEFULLUNROLL
#include "lib/Transform/Affine/Passes.h.inc"

}  // namespace qe
}  // namespace mlir

#endif  // LIB_TRANSFORM_AFFINE_AFFINEFULLUNROLL_H_