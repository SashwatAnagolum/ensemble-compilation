#include "lib/Transform/Ensemble/Inlinex.h"
#include "lib/Dialect/Ensemble/EnsembleOps.h"
#include "lib/Dialect/Ensemble/EnsembleTypes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Transforms/Passes.h"
#include "mlir/include/mlir/Pass/Pass.h"
#include "mlir/include/mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"

#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/PatternMatch.h"


namespace mlir {
namespace qe {
namespace ensemble {

#define GEN_PASS_DEF_INLINEX
#include "lib/Transform/Ensemble/Passes.h.inc"

using mlir::func::FuncOp;

// Inline pass that walks IR and inlines function calls
struct Inlinex : impl::InlinexBase<Inlinex> {
  using InlinexBase::InlinexBase;



  void runOnOperation() {
    // Get the module operation
    // ModuleOpInterface module = getOperation();

    // // Create inliner interface
    // InlinerInterface interface(&getContext());

    // // Walk through all functions in the module
    // module.walk([&](FuncOp func) {
    //   // Try to inline all calls within this function
    //   if (failed(inlineCallsInFunction(func, interface))) {
    //     func.emitError("inlining failed");
    //     signalPassFailure();
    //   }
    // });
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

//   LogicalResult inlineCallsInFunction(FuncOp func, InlinerInterface &interface) {
//     bool changed = true;
//     while (changed) {
//       changed = false;
      
//       func.walk([&](CallOp call) {
//         // Get the called function
//         FuncOp callee = dyn_cast<FuncOp>(call.getCallee());
//         if (!callee)
//           return;

//         // Try to inline this call
//         if (succeeded(inlineCall(interface, call, callee, &call.getRegion()))) {
//           changed = true;
//         }
//       });
//     }
//     return success();
//   }
};



}  // namespace ensemble
}  // namespace qe
}  // namespace mlir








