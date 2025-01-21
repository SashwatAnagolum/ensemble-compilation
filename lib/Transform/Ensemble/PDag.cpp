#include "lib/Transform/Ensemble/PDag.h"
#include <cassert>
namespace mlir {
namespace qe {
namespace ensemble {

// PDag_PDagNode functions

PDag_PDagNode::PDag_PDagNode(PDag_GateOperationPtr op): its_operation(op){
    this->operands = std::vector<std::vector<PDag_PDagNodePtr>>(op->num_operands);
}

void PDag_PDagNode::addNextOp(PDag_PDagNodePtr next_operation, PDag_ConditionalPtr probabilistic_edge){
    assert(next_operation != nullptr && probabilistic_edge != nullptr);
    this->next_operations.push_back(next_operation);
    this->probabilistic_edges.push_back(probabilistic_edge);
}

void PDag_PDagNode::setOperands(std::vector<PDag_PDagNodePtr>& operands, int operand_number){
    assert( (unsigned)operand_number < this->operands.size());
    assert(this->operands[operand_number].empty());
    this->operands[operand_number] = operands;
}

// PDag functions

PDag::PDag(int numqubits){
    this->qubit_trees = std::vector<std::vector<PDag_PDagNodePtr>>(numqubits);
    this->frontier_nodes = std::vector<std::vector<PDag_PDagNodePtr>>(numqubits);
}

void PDag::addOperation(std::vector<PDag_GateOperationPtr>& ops, std::vector<PDag_ConditionalPtr>& conditions, const std::vector<int>& qubit_indices){
    // Ideas:
    // high level: we apply each operation in ops to qubits corresponding to qubit index when the corresponding condition is met. The or of all conditions should be true
    // after adding all of the operations in ops, we update the frontier nodes

    std::vector<std::vector<PDag_PDagNodePtr>> new_frontier(qubit_indices.size());

    assert(ops.size()==conditions.size());
    for (unsigned i = 0; i<ops.size(); i++){
        PDag_GateOperationPtr op = ops[i];
        PDag_ConditionalPtr condition = conditions[i];
        assert(condition != nullptr);
        assert(op != nullptr);
        // We create a PDag_PDagNode for each operation and populate its operand vectors with all of the nodes contained in frontier_nodes[i] for each qubit index i
        PDag_PDagNodePtr the_new_op = std::make_shared<PDag_PDagNode>(op); 
        int operand_number = 0;
        for (int qubit_index : qubit_indices){
            assert( (unsigned)qubit_index < this->frontier_nodes.size());
            the_new_op->setOperands(this->frontier_nodes[qubit_index], operand_number);
            operand_number++;
        }
        
        // each PDag_PDagNodes opNode we add a given operation to for qubit index i are contained in frontier_nodes[i]
        for (int qubit_index : qubit_indices){
            std::vector<PDag_PDagNodePtr>& front_layer= this->frontier_nodes[qubit_index];
            for (PDag_PDagNodePtr& op: front_layer){
                op->addNextOp(the_new_op, condition);
            }
        }

        // populate the new frontier nodes
        for (unsigned j = 0; j<qubit_indices.size(); j++){
            new_frontier[j].push_back(the_new_op);
        }
    }
    
    for (unsigned i = 0; i< new_frontier.size(); i++){
        int qubit_index = qubit_indices[i];
        if (this->qubit_trees[qubit_index].size() == 0){
            this->qubit_trees[qubit_index] = new_frontier[i];
        }
        this->frontier_nodes[qubit_index] = new_frontier[i];
    }
}

void PDag::addOperation(PDag_GateOperationPtr op, const std::vector<int>& qubit_indices){
    assert(op != nullptr);
    assert(qubit_indices.size() > 0);
    PDag_ConditionalPtr true_condition = std::make_shared<PDag_Conditional>();
    true_condition->unconditional = true;
    std::vector<PDag_GateOperationPtr> ops = {op};
    std::vector<PDag_ConditionalPtr> conds = {true_condition};
    this->addOperation(ops, conds, qubit_indices);

}


  
} // namespace ensemble
} // namespace qe
} // namespace mlir

