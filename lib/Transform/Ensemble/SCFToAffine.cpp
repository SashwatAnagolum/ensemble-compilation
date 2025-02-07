#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/include/mlir/Pass/Pass.h"
#include <iostream>
namespace mlir {
namespace qe {
namespace ensemble {

#define GEN_PASS_DEF_SCFTOAFFINE
#include "lib/Transform/Ensemble/Passes.h.inc"

using mlir::affine::AffineForOp;
using mlir::scf::ForOp;
using mlir::affine::AffineYieldOp;

struct SCFToAffinePass : public impl::SCFToAffineBase<SCFToAffinePass> {
    // void printWholeProgram() {
    //     // Start from the top of the program and print all the operations
    //     getOperation()->walk([&](Operation *op) {
    //         op->print(llvm::outs());
    //         llvm::outs().flush();
    //     });
    // }

  void runOnOperation() override {
    // Convert loops from innermost to outermost
    getOperation()->walk([&](ForOp op) {
      // Skip if this is a nested loop - we'll handle those in separate pattern applications
      

      // flush the output
      llvm::outs().flush();

      // Check if the bounds are defined by constants
      auto lowerBound = op.getLowerBound().getDefiningOp<arith::ConstantIndexOp>();
      auto upperBound = op.getUpperBound().getDefiningOp<arith::ConstantIndexOp>();
      auto step = op.getStep().getDefiningOp<arith::ConstantIndexOp>();

      if (!lowerBound || !upperBound || !step) {
        
        return;
      }

      // Get the constant values
      int64_t lb = lowerBound.value();
      int64_t ub = upperBound.value();
      int64_t st = step.value();

      // Save insertion point
      OpBuilder builder(op);
      auto insertPt = builder.saveInsertionPoint();
      builder.setInsertionPoint(op);

      // Create an affine for loop with the same bounds
      auto affineFor = builder.create<AffineForOp>(op.getLoc(), lb, ub, st);

      // Get the SCF loop body and terminator
      Block &scfBody = op.getRegion().front();
      auto scfYield = cast<scf::YieldOp>(scfBody.getTerminator());

      // Get the affine loop's body block
      Block &affineBody = affineFor.getRegion().front();

      // Map the induction variable
      IRMapping mapper;
      mapper.map(op.getInductionVar(), affineFor.getInductionVar());

      // Clone all operations except the terminator
      builder.setInsertionPointToStart(&affineBody);
      for (auto &operation : scfBody.without_terminator()) {
        Operation *clonedOp = builder.clone(operation, mapper);
        for (auto pair : llvm::zip(operation.getResults(), clonedOp->getResults())) {
          mapper.map(std::get<0>(pair), std::get<1>(pair));
        }
      }

      // Map and clone yield operands
      SmallVector<Value, 4> mappedOperands;
      for (auto operand : scfYield.getOperands()) {
        mappedOperands.push_back(mapper.lookupOrDefault(operand));
      }

      // Create affine.yield with mapped operands
      builder.setInsertionPointToEnd(&affineBody);
    //   builder.create<AffineYieldOp>(scfYield.getLoc(), mappedOperands);

      // Restore insertion point
      builder.restoreInsertionPoint(insertPt);

      // Replace all uses of the original loop's results with the new loop's results
      for (auto pair : llvm::zip(op.getResults(), affineFor.getResults())) {
        std::get<0>(pair).replaceAllUsesWith(std::get<1>(pair));
      }

      // Erase the original scf.for loop
      op.erase();
    });
  }
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir
