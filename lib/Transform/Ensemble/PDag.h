#ifndef PDAG_H
#define PDAG_H

#include <vector>
#include <utility>
#include <memory>
#include <string>

namespace mlir {
namespace qe {
namespace ensemble {

using PDag_PDagNodePtr = std::shared_ptr<class PDag_PDagNode>;
using PDag_ParameterPtr = std::shared_ptr<class PDag_Parameter>;
using PDag_RandomValueCollectionPtr = std::shared_ptr<class PDag_RandomValueCollection>;
using PDag_GateOperationPtr = std::shared_ptr<class PDag_GateOperation>;
using PDag_RandomValuePtr = std::shared_ptr<class PDag_RandomValue>;
using PDag_ValuePtr = std::shared_ptr<class PDag_Value>;
using PDag_PermutationIntDistributionPtr = std::shared_ptr<class PDag_PermutationIntDistribution>;
using PDag_ConditionalPtr = std::shared_ptr<class PDag_Conditional>;
using PDag_Ptr = std::shared_ptr<class PDag>;
using PDag_UniformIntDistributionPtr = std::shared_ptr<class PDag_UniformIntDistribution>;
using PDag_UniformFloatDistributionPtr = std::shared_ptr<class PDag_UniformFloatDistribution>;
using PDag_CategoricalIntDistributionPtr = std::shared_ptr<class PDag_CategoricalIntDistribution>;
using PDag_RandomValueCollectionPtr = std::shared_ptr<class PDag_RandomValueCollection>;
using PDag_QubitDistributionPtr = std::shared_ptr<class PDag_QubitDistribution>;

enum PDag_ValueType {
    PDag_INTEGER, PDag_FLOAT
};

class PDag_RandomValueCollection {
public:
    std::vector<PDag_ValuePtr> shape;
    PDag_ValueType dist_type;
    virtual ~PDag_RandomValueCollection() = default;
};

class PDag_UniformIntDistribution : public PDag_RandomValueCollection {
public:
    PDag_ValuePtr low;
    PDag_ValuePtr high;

    PDag_UniformIntDistribution(PDag_ValuePtr low, PDag_ValuePtr high, std::vector<PDag_ValuePtr> shape)
        : low(low), high(high) {
        this->shape = shape;
        this->dist_type = PDag_INTEGER;
    }
};

class PDag_UniformFloatDistribution : public PDag_RandomValueCollection {
public:
    PDag_ValuePtr low;
    PDag_ValuePtr high;

    PDag_UniformFloatDistribution(PDag_ValuePtr low, PDag_ValuePtr high, std::vector<PDag_ValuePtr> shape)
        : low(low), high(high) {
        this->shape = shape;
        this->dist_type = PDag_FLOAT;
    }
};

class PDag_CategoricalIntDistribution : public PDag_RandomValueCollection {
public:
    PDag_ValuePtr low;
    std::vector<float> probabilities;

    PDag_CategoricalIntDistribution(PDag_ValuePtr low, std::vector<float> probabilities, std::vector<PDag_ValuePtr> shape)
        : low(low), probabilities(probabilities) {
        this->shape = shape;
        this->dist_type = PDag_INTEGER;
    }
};

class PDag_PermutationIntDistribution : public PDag_RandomValueCollection {
public:
    int N;
    PDag_PermutationIntDistribution(int N): N(N) {
        this->dist_type = PDag_INTEGER;
    }
};

class PDag_QubitDistribution: public PDag_RandomValueCollection {
public:
    int num_qubits;
    PDag_QubitDistribution(int num_qubits): num_qubits(num_qubits) {
        this->dist_type = PDag_INTEGER;
    }
};

class PDag_RandomValue {
public:
    PDag_RandomValueCollectionPtr collection;
    std::vector<PDag_ValuePtr> indices;
};



class PDag_Value {
public:
    PDag_ValueType vt;
    bool isDeterministic;
    int int_value;
    double float_value;
    PDag_RandomValuePtr random_value;
};

enum PDag_Restriction {
    PDAG_RESTRICTION_GT,
    PDAG_RESTRICTION_LT,
    PDAG_RESTRICTION_EQ
};

class PDag_Conditional {
public:
    PDag_ValuePtr lhs;
    PDag_Restriction restriction_type;
    PDag_ValuePtr rhs;
    bool unconditional = false;
};

class PDag_GateOperation {
public:
    std::string name;
    std::vector<PDag_ValuePtr> parameters;
    int num_operands;
    bool inverse;
};

class PDag_PDagNode {
    PDag_GateOperationPtr op;
    std::vector<PDag_PDagNodePtr> next_operations;
    std::vector<PDag_ConditionalPtr> probabilistic_edges;
    std::vector<std::vector<PDag_PDagNodePtr>> operands;
    PDag_GateOperationPtr its_operation;

public:
    PDag_PDagNode(PDag_GateOperationPtr op);
    void addNextOp(PDag_PDagNodePtr next_operation, PDag_ConditionalPtr probabilistic_edge);
    void setOperands(std::vector<PDag_PDagNodePtr>& operands, int operand_number);
};

class PDag {
    std::vector<std::vector<PDag_PDagNodePtr>> qubit_trees;
    std::vector<std::vector<PDag_PDagNodePtr>> frontier_nodes;

public:
    PDag() {}
    PDag(int numqubits);
    void addOperation(PDag_GateOperationPtr op, const std::vector<int>& qubit_indices);
    void addOperation(std::vector<PDag_GateOperationPtr>& ops, std::vector<PDag_ConditionalPtr>& conditions, const std::vector<int>& qubit_indices);
};

} // namespace ensemble
} // namespace qe 
} // namespace mlir

#endif