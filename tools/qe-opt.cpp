#include "lib/Transform/Affine/Passes.h"
#include "lib/Transform/Arith/Passes.h"
#include "mlir/include/mlir/InitAllDialects.h"
#include "mlir/include/mlir/Pass/PassManager.h"
#include "mlir/include/mlir/Pass/PassRegistry.h"
#include "mlir/include/mlir/Tools/mlir-opt/MlirOptMain.h"

int main(int argc, char **argv) {
  mlir::DialectRegistry registry;
  mlir::registerAllDialects(registry);

  mlir::qe::registerAffinePasses();
  mlir::qe::registerArithPasses();

  return mlir::asMainReturnCode(mlir::MlirOptMain(
      argc, argv, "Quantum Ensemble Compilation Pass Driver", registry));
}