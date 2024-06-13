#include "lib/Transform/Affine/Passes.h"
#include "lib/Transform/Arith/MulToAdd.h"
#include "lib/Transform/Arith/MulToShiftAndAdd.h"
#include "mlir/include/mlir/InitAllDialects.h"
#include "mlir/include/mlir/Pass/PassManager.h"
#include "mlir/include/mlir/Pass/PassRegistry.h"
#include "mlir/include/mlir/Tools/mlir-opt/MlirOptMain.h"

int main(int argc, char **argv) {
  mlir::DialectRegistry registry;
  mlir::registerAllDialects(registry);

  mlir::qe::registerAffinePasses();
  mlir::PassRegistration<mlir::qe::MulToAddPass>();
  mlir::PassRegistration<mlir::qe::MulToShiftAndAddPass>();

  return mlir::asMainReturnCode(mlir::MlirOptMain(
      argc, argv, "Quantum Ensemble Compilation Pass Driver", registry));
}