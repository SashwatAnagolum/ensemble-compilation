#ifndef PDAG_H
#define PDAG_H

#include <vector>
#include <utility>
#include <memory>
#include <string>

namespace mlir {
namespace qe {
namespace ensemble {

using PDagNodePtr = std::shared_ptr<class PDagNode>;
using ParameterPtr = std::shared_ptr<class Parameter>;
using RandomValueCollectionPtr = std::shared_ptr<class RandomValueCollection>;
using GateOperationPtr = std::shared_ptr<class GateOperation>;
using RandomValuePtr = std::shared_ptr<class RandomValue>;
using ValuePtr = std::shared_ptr<class Value>;
using PermutationIntDistributionPtr = std::shared_ptr<class PermutationIntDistribution>;
using ConditionalPtr = std::shared_ptr<class Conditional>;


class RandomValueCollection {
public:
    std::vector<int> shape;
    virtual ~RandomValueCollection() = default;
};

class UniformIntDistribution : public RandomValueCollection {
public:
    int low;
    int high;

    UniformIntDistribution(int low, int high, std::vector<int> shape)
        : low(low), high(high) {
        this->shape = shape;
    }
};

class UniformFloatDistribution : public RandomValueCollection {
public:
    float low;
    float high;

    UniformFloatDistribution(float low, float high, std::vector<int> shape)
        : low(low), high(high) {
        this->shape = shape;
    }
};

class CategoricalIntDistribution : public RandomValueCollection {
public:
    int low;
    std::vector<float> probabilities;

    CategoricalIntDistribution(int low, std::vector<float> probabilities, std::vector<int> shape)
        : low(low), probabilities(probabilities) {
        this->shape = shape;
    }
};

class PermutationIntDistribution : public RandomValueCollection {
public:
    int N;
    PermutationIntDistribution(int N): N(N) {}
};

class RandomValue {
    // consists of a pointer to a parameter collection and an index
public:
    RandomValueCollectionPtr collection;
    int index;
};

enum ValueType {
    INTEGER, FLOAT
};

class Value {
public:
    ValueType vt;
    bool isDeterministic;
    int int_value; // if applicable and deterministic
    double float_value; // if applicable and deterministic
    RandomValuePtr random_value; // if nondeterministic and applicable
    
};

struct Restriction {
    bool GT; // greater than
    bool LT; // less than
    bool EQ; // equal
    // could be any combinations of these. For example != is GT and LT, and <= is LT and EQ
};

class Conditional {
public:
    ValuePtr lhs; 
    Restriction restriction_type;
    ValuePtr rhs; 
    bool unconditional = false;
};

class GateOperation{
public:
    std::string name;
    std::vector<Value> parameters;
    int num_operands;
    bool inverse;
};

class PDagNode{
    GateOperationPtr op;

    // there is a one to one mapping between next_operations and probabilistic_edges
    // We take edge next_operations[i] when probabilistic_edges[i] is satisfied
    std::vector<PDagNodePtr> next_operations;
    std::vector<ConditionalPtr> probabilistic_edges;

    std::vector<std::vector<PDagNodePtr>> operands; // inputs. This is used by operations like CNOT to maintain ordering of which operands are control and target
    // its a vector of vectors because a qubit can have multiple operations before and all of them come in to the this node. For example, if the last applied operation was a Gate Distribution of X, Y, Z, I on qubit 0, and just a hadamard on qubit 1, then the operands would be nodes corresponding to [[X, Y, Z, I], [H]]
    GateOperationPtr its_operation;

public:
    PDagNode(GateOperationPtr op);
    // adds the next operation 
    void addNextOp(PDagNodePtr next_operation, ConditionalPtr probabilistic_edge);
    void setOperands(std::vector<PDagNodePtr>& operands, int operand_number);


};

class PDag {
    std::vector<std::vector<PDagNodePtr>> qubit_trees;
    std::vector<std::vector<PDagNodePtr>> frontier_nodes; // these are basically the most recent operations added to a given qubit, sometimes probabilistically
    
    public:
    PDag(int numqubits);
    void addOperation(GateOperationPtr op, const std::vector<int>& qubit_indices);
    void addOperation(std::vector<GateOperationPtr>& ops, std::vector<ConditionalPtr>& conditions, const std::vector<int>& qubit_indices);
    

};

} // namespace ensemble
} // namespace qe 
} // namespace mlir

#endif