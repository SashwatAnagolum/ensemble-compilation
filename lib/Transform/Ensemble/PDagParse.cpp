#include "lib/Transform/Ensemble/PDagParse.h"
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

#include "lib/Transform/Ensemble/PDag.h"

#include <unordered_set>

namespace mlir {
namespace qe {
namespace ensemble {

#define GEN_PASS_DEF_PDAGPARSE
#include "lib/Transform/Ensemble/Passes.h.inc"
struct PDagParse
    : impl::PDagParseBase<PDagParse> {
  using PDagParseBase::PDagParseBase;

  PDag_Ptr dag;

  std::unordered_set<Operation *> visited;
  std::unordered_map<Operation *, PDag_ValuePtr> values;
  std::unordered_map<Operation *, PDag_RandomValueCollectionPtr> distributions;
  std::unordered_map<Operation *, PDag_GateOperationPtr> gates;



  void printOp(Operation *op) {
    

    llvm::outs() << "Operation: " << op->getName() << "\n";
    llvm::outs() << "Location: " << op->getLoc() << "\n";
    
    // Print operands
    llvm::outs() << "Operands:\n";
    for (Value operand : op->getOperands()) {
      if (visited.find(operand.getDefiningOp()) != visited.end()) {
      // if (false) {
        llvm::outs() << "  " << operand << "(visited)\n";
      } else {
        llvm::outs() << "  " << operand << "unvisited\n";
      }
      
    }
    
    // Print results
    llvm::outs() << "Results:\n"; 
    for (Value result : op->getResults()) {
      llvm::outs() << "  " << result << "\n";
    }

    // Print attributes
    llvm::outs() << "Attributes:\n";
    for (NamedAttribute attr : op->getAttrs()) {
      llvm::outs() << "  " << attr.getName() << ": " << attr.getValue() << "\n";
    }

    llvm::outs() << "ParentOps:\n";
    if (op->getParentOp()) {  
      llvm::outs() << "  " << op->getParentOp()->getName() << "\n";
    }

    llvm::outs() << "GrandparentOps:\n";
    if ( op->getParentOp() && op->getParentOp()->getParentOp()) {
      llvm::outs() << "  " << op->getParentOp()->getParentOp()->getName() << "\n";
    }

    llvm::outs() << "\n";
  }

  void logOp(Operation *op) {
    if (visited.find(op) != visited.end()) {
        return;
    }
    visited.insert(op);

    std::string opName = op->getName().getStringRef().str();

    if (opName == "arith.constant") {
        auto const_value = op->getAttr("value");
        PDag_ValuePtr value = std::make_shared<PDag_Value>();
        value->isDeterministic = true;
        if (const_value.isa<FloatAttr>()) {
            float float_value = const_value.cast<FloatAttr>().getValueAsDouble();
            llvm::outs() << "Constant float: " << float_value << "\n";
            value->vt = PDag_FLOAT;
            value->float_value = float_value;
        } 
        else if (const_value.isa<IntegerAttr>()) {
            int int_value = const_value.cast<IntegerAttr>().getInt();
            llvm::outs() << "Constant int: " << int_value << "\n";
            value->vt = PDag_INTEGER;
            value->int_value = int_value;
        }
        
        values[op] = value;
    } else if (opName == "ensemble.reset") {
        // Handle ensemble.reset
    } else if (opName == "ensemble.program_alloc") {
      int num_qubits = op->getAttr("circuit_size").cast<IntegerAttr>().getInt();
      dag = std::make_shared<PDag>(num_qubits);
      PDag_QubitDistributionPtr distribution = std::make_shared<PDag_QubitDistribution>(num_qubits);
      distributions[op] = distribution;

        // Handle ensemble.program_alloc
    } else if (opName == "ensemble.alloc_cbits") {
        // Handle ensemble.alloc_cbits
    } else if (opName == "ensemble.int_uniform") {
      PDag_ValuePtr low, high;
      std::vector<PDag_ValuePtr> shape;
      for (unsigned int i = 0; i < op->getNumOperands(); i++) {
        Operation *operand_op = op->getOperand(i).getDefiningOp();
        assert(values.find(operand_op) != values.end());
        PDag_ValuePtr value = values[operand_op];
        if (i == 0) {
          low = value;
        } else if (i == 1) {
          high = value;
        } else  {
          shape.push_back(value);
        }
      }
      PDag_UniformIntDistributionPtr distribution = std::make_shared<PDag_UniformIntDistribution>(low, high, shape);
      distributions[op] = distribution;
        // Handle ensemble.int_uniform
    } else if (opName == "ensemble.float_uniform") {
      // Handle ensemble.float_uniform
      PDag_ValuePtr low, high;
      std::vector<PDag_ValuePtr> shape;
      for (unsigned int i = 0; i < op->getNumOperands(); i++) {
        Operation *operand_op = op->getOperand(i).getDefiningOp();
        assert(values.find(operand_op) != values.end());
        PDag_ValuePtr value = values[operand_op];
        if (i == 0) {
          low = value;
        } else if (i == 1) {
          high = value;
        } else  {
          shape.push_back(value);
        }
      }
      PDag_UniformFloatDistributionPtr distribution = std::make_shared<PDag_UniformFloatDistribution>(low, high, shape);
      distributions[op] = distribution;
    } else if (opName == "ensemble.gate") {
        // Handle ensemble.gate
        PDag_GateOperationPtr gate = std::make_shared<PDag_GateOperation>();
        gate->name = op->getAttr("name").cast<StringAttr>().getValue().str();
        // handle inverse
        if (op->getAttr("inverse")) {
          gate->inverse = op->getAttr("inverse").cast<StringAttr>().getValue().str() == "inverse";
        }
        else {
          gate->inverse = false;
        }
        gate->num_operands = op->getAttr("num_operands").cast<IntegerAttr>().getInt();
        // handle parameters
        for (unsigned int i = 0; i < op->getNumOperands(); i++) {
          Operation *operand_op = op->getOperand(i).getDefiningOp();

          if (values.find(operand_op) == values.end()) {
            llvm::outs() << "Value not found: " << operand_op->getName() << "\n";
            llvm::outs().flush();
          }
          assert( values.find(operand_op) != values.end());
          PDag_ValuePtr value = values[operand_op];
          gate->parameters.push_back(value);
          
        }
    
        gates[op] = gate;
        // dag->addGate(gate);
    } else if (opName == "ensemble.gate_distribution") {
        // Handle ensemble.gate_distribution
    } else if (opName == "ensemble.apply") {
        // Handle ensemble.apply
    } else if (opName == "ensemble.apply_distribution") {
        // Handle ensemble.apply_distribution
    } else if (opName == "tensor.extract") {
        // Handle tensor.extract
        
        for (unsigned int i = 0; i < op->getNumOperands(); i++) {
          Operation *operand_op = op->getOperand(i).getDefiningOp();
          if (distributions.find(operand_op) == distributions.end()) { 
            llvm::outs() << "Distribution not found: " << operand_op->getName() << "\n";
            llvm::outs().flush();
          }

          if (i == 0) {
            // first one will be the distribution
            assert(distributions.find(operand_op) != distributions.end());
            PDag_RandomValueCollectionPtr collection = distributions[operand_op];

            PDag_RandomValuePtr random_value = std::make_shared<PDag_RandomValue>();
            random_value->collection = collection;
            PDag_ValuePtr value = std::make_shared<PDag_Value>();
            value->isDeterministic = false;
            value->random_value = random_value;
            value->vt = collection->dist_type;
            values[op] = value;
          } else  {
            // all the rest will be indices
            assert(values.find(operand_op) != values.end());
            PDag_ValuePtr value = values[operand_op]; // this is the index's valueptr

            PDag_ValuePtr thisOpsValue = values[op];
            PDag_RandomValuePtr random_value = thisOpsValue->random_value;
            random_value->indices.push_back(value);
          }
          llvm::outs() << "indices: " << values[op]->random_value->indices.size() << "\n";
          llvm::outs().flush();
        }
        
    }
  }

  void runOnOperation() {
    Operation *op = getOperation();
    // Then print operations
    op->walk([this](Operation *op) {
      // Print operation name and location
      logOp(op);
      printOp(op);
    });
  }
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir
