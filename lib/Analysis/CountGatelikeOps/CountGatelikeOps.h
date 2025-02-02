#ifndef LIB_ANALYSIS_COUNTGATELIKEOPS_COUNTGATELIKEOPS_H_
#define LIB_ANALYSIS_COUNTGATELIKEOPS_COUNTGATELIKEOPS_H_

#include <utility>
#include <unordered_map>

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
  std::pair<int, int> getGatelikeOpsCount() const {
    return std::pair<int, int>{num1QOps, num2QOps};
  }

  // std::unordered_map<Operation, int> getOpMappingToIndex() {
  //   return opToIndexMap;
  // }

 private:
  std::pair<int, int> countOps(Operation *op);
  // std::unordered_map<Operation, int> opToIndexMap;
  int getLoopRepetions(scf::ForOp forOp);
  int num1QOps = 0, num2QOps = 0;
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir

#endif  // LIB_ANALYSIS_COUNTGATELIKEOPS_COUNTGATELIKEOPS_H_