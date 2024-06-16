#include "lib/Dialect/Ensemble/EnsembleDialect.h"
#include "lib/Dialect/Poly/PolyDialect.h"
#include "lib/Transform/Affine/Passes.h"
#include "lib/Transform/Arith/Passes.h"

//

#include "mlir/include/mlir/InitAllDialects.h"
#include "mlir/include/mlir/InitAllPasses.h"
#include "mlir/include/mlir/Pass/PassManager.h"
#include "mlir/include/mlir/Pass/PassRegistry.h"
#include "mlir/include/mlir/Tools/mlir-opt/MlirOptMain.h"

int main(int argc, char **argv) {
  mlir::DialectRegistry registry;

  registry.insert<mlir::qe::poly::PolyDialect>();
  registry.insert<mlir::qe::ensemble::EnsembleDialect>();
  mlir::registerAllDialects(registry);

  mlir::qe::registerAffinePasses();
  mlir::qe::registerArithPasses();
  mlir::registerAllPasses();

  return mlir::asMainReturnCode(mlir::MlirOptMain(
      argc, argv, "Quantum Ensemble Compilation Pass Driver", registry));
}