// In lib/Dialect/Ensemble/EnsembleOps.cpp

// include EnsembleOps.h
#include "lib/Dialect/Ensemble/EnsembleOps.h"
#include "mlir/IR/OpImplementation.h"
#include "mlir/IR/Types.h"
#include "mlir/IR/Diagnostics.h"  // For LogicalResult and emitOpError

namespace mlir {
namespace qe {
namespace ensemble {

LogicalResult GateConstructorOp::verify() {
  // No additional verification needed as the types are enforced by the op definition
  return success();
}

LogicalResult ApplyGate::verify() {


  // Get the gate operation
  auto gateOp = getGate().getDefiningOp<GateConstructorOp>();
  if (!gateOp) {
    return emitOpError("Gate must be defined by a GateConstructorOp");
  }

  // Check if the number of operands matches the number of qubits
  if (gateOp.getNumOperands() != getInput().size()) {
    return emitOpError("Number of gate operands (")
           << gateOp.getNumOperands()
           << ") must match number of input qubits ("
           << getInput().size() << ")";
  }
  
  return success();
}

LogicalResult QubitMeasurement::verify() {
  // No additional verification needed as the types are enforced by the op definition
  return success();
}

LogicalResult ResetQubits::verify() {
  
  return success();
}

LogicalResult ResetQubitTensor::verify() {
  
  return success();
}

LogicalResult GateDistributionConstructor::verify() {
    if (getGates().empty()) {
        return emitOpError("Gate distribution must contain at least one gate");
    }

    // Get the number of qubit operands from the first gate
    auto firstGateOp = getGates().front().getDefiningOp<GateConstructorOp>();
    if (!firstGateOp) {
        return emitOpError("All gates in the distribution must be defined by GateConstructorOp");
    }
    unsigned numOperands = firstGateOp.getNumOperands();

    // Check that all gates have the same number of qubit operands
    for (auto gate : getGates()) {
        auto gateOp = gate.getDefiningOp<GateConstructorOp>();
        if (!gateOp) {
            return emitOpError("All gates in the distribution must be defined by GateConstructorOp");
        }
        if (gateOp.getNumOperands() != numOperands) {
            return emitOpError("All gates in the distribution must have the same number of qubit operands");
        }
    }

    return success();
}

LogicalResult ApplyGateDistribution::verify() {
   

    // Check that the number of input qubits matches the number of operands in the first gate of the distribution
    auto gateDistOp = getGates().getDefiningOp<GateDistributionConstructor>();
    if (!gateDistOp) {
        return emitOpError("Gate distribution must be defined by a GateDistributionConstructor");
    }

    if (gateDistOp.getGates().empty()) {
        return emitOpError("Gate distribution must contain at least one gate");
    }

    auto firstGateOp = gateDistOp.getGates().front().getDefiningOp<GateConstructorOp>();
    if (!firstGateOp) {
        return emitOpError("First gate in the distribution must be defined by GateConstructorOp");
    }

    unsigned numOperandsInGate = firstGateOp.getNumOperands();
    if (getInputs().size() != numOperandsInGate) {
        return emitOpError("Number of input qubits must match the number of operands in the first gate of the distribution");
    }
    
    return success();
}

LogicalResult QubitDistribution::verify() {
  // No additional verification needed as the types are enforced by the op definition
  return success();
}

LogicalResult CbitDistribution::verify() {
  // No additional verification needed as the types are enforced by the op definition
  return success();
}

LogicalResult UniformIntegerDistributionOp::verify() {
  if (getLow() >= getHigh()) {
    return emitOpError("Low bound must be less than high bound");
  }
  return success();
}

LogicalResult CategoricalIntegerDistributionOp::verify() {
  if (getProbs().empty()) {
    return emitOpError("Probability array must not be empty");
  }
  return success();
}

LogicalResult UniformFloatDistributionOp::verify() {
  if (getLow() >= getHigh()) {
    return emitOpError("Low bound must be less than high bound");
  }
  return success();
}

LogicalResult CNOTPairDistributionOp::verify() {
  auto connectivityType = getConnectivity().getType().dyn_cast<RankedTensorType>();
  if (!connectivityType || connectivityType.getRank() != 2 || connectivityType.getShape()[1] != 2) {
    return emitOpError("Input connectivity must be a tensor of shape n x 2");
  }
  return success();
}


} // end namespace ensemble
} // end namespace qe
} // end namespace mlir
