#ifndef LIB_TRANSFORM_ENSEMBLE_PASSES_H_
#define LIB_TRANSFORM_ENSEMBLE_PASSES_H_

#include "lib/Transform/Ensemble/ZeroNoiseExtrapolation.h"

namespace mlir {
namespace qe {
namespace ensemble {

#define GEN_PASS_REGISTRATION
#include "lib/Transform/Ensemble/Passes.h.inc"

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir

#endif  // LIB_TRANSFORM_ENSEMBLE_PASSES_H_