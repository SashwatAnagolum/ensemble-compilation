#ifndef LIB_TRANSFORM_ENSEMBLE_SCFTOAFFINE_H_
#define LIB_TRANSFORM_ENSEMBLE_SCFTOAFFINE_H_

#include "mlir/Pass/Pass.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/SCF/IR/SCF.h"

namespace mlir {
namespace qe {
namespace ensemble {

#define GEN_PASS_DECL_SCFTOAFFINE
#include "lib/Transform/Ensemble/Passes.h.inc"




}  // namespace ensemble
}  // namespace qe
}  // namespace mlir

#endif  // LIB_TRANSFORM_ENSEMBLE_SCFTOAFFINE_H_
