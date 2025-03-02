#include "lib/Analysis/CountGatelikeOps/CountGatelikeOps.h"

#include <string>
#include <utility>

#include "lib/Dialect/Ensemble/EnsembleOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/include/mlir/IR/Operation.h"
#include "mlir/include/mlir/IR/Value.h"
#include "mlir/IR/Region.h"

namespace mlir {
namespace qe {
namespace ensemble {

// for now assumes that all loop parameters
// are arith::ConstantOps - this will not always
// be the case, ex. for ZNE.
// but I;m not sure if we ever will come across cases
// where the loops are non-deterministic, and we need
// to do gate sampling.
int CountGatelikeOps::getLoopRepetions(scf::ForOp forOp) {
    auto lowerBoundOp = dyn_cast<arith::ConstantOp>(forOp.getLowerBound().getDefiningOp());
    auto upperBoundOp = dyn_cast<arith::ConstantOp>(forOp.getUpperBound().getDefiningOp());
    auto stepSizeOp = dyn_cast<arith::ConstantOp>(forOp.getStep().getDefiningOp());

    int64_t lowerBound = lowerBoundOp.getValue().dyn_cast<IntegerAttr>().getInt();
    int64_t upperBound = upperBoundOp.getValue().dyn_cast<IntegerAttr>().getInt();
    int64_t stepSize = stepSizeOp.getValue().dyn_cast<IntegerAttr>().getInt();

    return (upperBound - lowerBound) / stepSize;
}

std::pair<int, int> CountGatelikeOps::countOps(Operation *op) {
    int num1QGateOpsUnderOp = 0;
    int num2QGateOpsUnderOp = 0;

    for (Region &region : op->getRegions()) {
        for (Operation &childOp : region.getOps()) {
            if (
                (childOp.getName().getStringRef().str() == "ensemble.apply") ||
                (childOp.getName().getStringRef().str() == "ensemble.apply_distribution")
             ) {
                if (childOp.getNumOperands() == 2) {
                    num1QGateOpsUnderOp += 1;
                } else {
                    num2QGateOpsUnderOp += 1;
                }
            } else if (childOp.getName().getStringRef().str() == "scf.for") {
                scf::ForOp forOp = dyn_cast<scf::ForOp>(childOp);
                auto numNestedOps = this->countOps(&childOp);

                num1QGateOpsUnderOp += getLoopRepetions(forOp) * numNestedOps.first;
                num2QGateOpsUnderOp += getLoopRepetions(forOp) * numNestedOps.second;
            } else {
                auto numNestedOps = this->countOps(&childOp);

                num1QGateOpsUnderOp += numNestedOps.first;
                num2QGateOpsUnderOp += numNestedOps.second;
            }
        }
    }  

    return std::pair<int, int>{num1QGateOpsUnderOp, num2QGateOpsUnderOp};  
}

CountGatelikeOps::CountGatelikeOps(Operation *op) {
    op->walk([this](Operation *op) {
        // get the quantum_program_iteration block,
        // and count the number of gates in it.
        if (dyn_cast<ensemble::QuantumProgramIteration>(op) != nullptr) {
            auto numOps = this->countOps(op);
            this->num1QOps = numOps.first;
            this->num2QOps = numOps.second;
            return WalkResult::interrupt();
        } else {
            return WalkResult::advance();
        }
    });
}

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir