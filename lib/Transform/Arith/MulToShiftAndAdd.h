#ifndef LIB_TRANSFORM_ARITH_MULTOSHIFTANDADD_H_
#define LIB_TRANSFORM_ARITH_MULTOSHIFTANDADD_H_

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/include/mlir/Pass/Pass.h"

namespace mlir {
namespace qe {

class MulToShiftAndAddPass
    : public PassWrapper<MulToAddPass, OperationPass<mlir::func::FuncOp>> {
 private:
  void runOnOperation() override;

  StringRef getArgument() const final { return "mul-to-shift-and-add"; }

  StringRef getDescription() const final {
    return "Convert multiplications to shifts and additions";
  }
};

}  // namespace qe
}  // namespace mlir

#endif  // LIB_TRANSFORM_ARITH_MULTOSHIFTANDADD_H_