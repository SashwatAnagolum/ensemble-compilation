#ifndef LIB_TRANSFORM_ENSEMBLE_ZERONOISEEXTRAPOLATION_H_
#define LIB_TRANSFORM_ENSEMBLE_ZERONOISEEXTRAPOLATION_H_

#include "mlir/Pass/Pass.h"

namespace mlir {
namespace qe {

#define GEN_PASS_DECL_ZERONOISEEXTRAPOLATION
#include "lib/Transform/Ensemble/Passes.h.inc"

}  // namespace qe
}  // namespace mlir

#endif  // LIB_TRANSFORM_ENSEMBLE_ZERONOISEEXTRAPOLATION_H_