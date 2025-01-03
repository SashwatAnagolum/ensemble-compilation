#ifndef LIB_DIALECT_ENSEMBLE_ENSEMBLEINLINERINTERFACE_H_
#define LIB_DIALECT_ENSEMBLE_ENSEMBLEINLINERINTERFACE_H_

#include "mlir/IR/DialectInterface.h"
#include "mlir/IR/Operation.h"
#include "mlir/Transforms/InliningUtils.h"
#include "mlir/IR/Region.h"
#include "mlir/IR/Value.h"
#include "mlir/IR/Block.h"
#include "lib/Dialect/Ensemble/EnsembleOps.h"
#include "lib/Dialect/Ensemble/EnsembleTypes.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/MLIRContext.h"



namespace mlir {
namespace qe {
namespace ensemble {

struct EnsembleInlinerInterface : public DialectInlinerInterface {
  using DialectInlinerInterface::DialectInlinerInterface;

   bool isLegalToInline(Operation *call, Operation *callable, bool wouldBeCloned) const  {
    return true;
  }
 bool isLegalToInline(Operation *, Region *, bool, IRMapping &) const  {
    return true;
  }
   bool isLegalToInline(Region *dest, Region *src, bool wouldBeCloned, IRMapping &valueMapping) const  {
    return true;
  }
  //  void handleTerminator(Operation *op, MutableArrayRef<Value> valuesToRepl) const  {

  //   // Only "toy.return" needs to be handled here.
  //   auto returnOp = cast<ReturnOp>(op);

  //   // Replace the values directly with the return operands.
  //   assert(returnOp.getNumOperands() == valuesToRepl.size());
  //   for (const auto &it : llvm::enumerate(returnOp.getOperands()))
  //     valuesToRepl[it.index()].replaceAllUsesWith(it.value());
  // }

  
};

} // namespace ensemble
} // namespace qe
} // namespace mlir

#endif // LIB_DIALECT_ENSEMBLE_ENSEMBLEINLINERINTERFACE_H_

