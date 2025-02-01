#ifndef LIB_ANALYSIS_COUNTGATELIKEOPS_COUNTGATELIKEOPS_H_
#define LIB_ANALYSIS_COUNTGATELIKEOPS_COUNTGATELIKEOPS_H_

#include "mlir/include/mlir/IR/Operation.h"
#include "mlir/Dialect/SCF/IR/SCF.h"

namespace mlir {
namespace qe {
namespace ensemble {

class CountGatelikeOps {
 public:
  CountGatelikeOps(Operation *op);
  ~CountGatelikeOps() = default;

  // Return the number of gate distributions counted in the program
  // that was analyzed
  int getGatelikeOpsCount() const {
    return numGatelikeOps;
  }

 private:
  int countOps(Operation *op);
  int getLoopRepetions(scf::ForOp forOp);
  int numGatelikeOps = 0;
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir

#endif  // LIB_ANALYSIS_COUNTGATELIKEOPS_COUNTGATELIKEOPS_H_