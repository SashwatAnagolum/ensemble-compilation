#include "lib/Transform/Ensemble/PrintEachOperation.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/MLIRContext.h"

#include "lib/Dialect/Ensemble/EnsembleOps.h"
#include "lib/Dialect/Ensemble/EnsembleTypes.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Transforms/DialectConversion.h"
#include "llvm/Support/raw_ostream.h"

namespace mlir {
namespace qe {
namespace ensemble {

#define GEN_PASS_DEF_PRINTEACHOPERATION
#include "lib/Transform/Ensemble/Passes.h.inc"

struct PrintEachOperation
    : impl::PrintEachOperationBase<PrintEachOperation> {
  using PrintEachOperationBase::PrintEachOperationBase;

  void runOnOperation() {
    Operation *op = getOperation();
    
    

    // Then print operations
    op->walk([](Operation *op) {
      // Print operation name and location
      llvm::outs() << "Operation: " << op->getName() << "\n";
      llvm::outs() << "Location: " << op->getLoc() << "\n";
      
      // Print operands
      llvm::outs() << "Operands:\n";
      for (Value operand : op->getOperands()) {
        llvm::outs() << "  " << operand << "\n";
      }
      
      // Print results
      llvm::outs() << "Results:\n"; 
      for (Value result : op->getResults()) {
        llvm::outs() << "  " << result << "\n";
      }
      
      llvm::outs() << "\n";
    });
  }
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir
