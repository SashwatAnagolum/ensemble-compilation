#include "lib/Transform/Ensemble/CliffordDataRegression.h"

#include <iostream>
#include <utility>

#include "lib/Dialect/Ensemble/EnsembleOps.h"
#include "lib/Dialect/Ensemble/EnsembleTypes.h"
#include "lib/Analysis/CountGatelikeOps/CountGatelikeOps.h"

//

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/include/mlir/Pass/Pass.h"
#include "mlir/include/mlir/IR/Value.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"

namespace mlir {
namespace qe {
namespace ensemble {

#define GEN_PASS_DEF_CLIFFORDDATAREGRESSION
#include "lib/Transform/Ensemble/Passes.h.inc"

using arith::ConstantOp;

struct AddRandomGateIndexSamples : public OpRewritePattern<QuantumProgramIteration> {
    int num1QGates = 0, num2QGates = 0;

    AddRandomGateIndexSamples(mlir::MLIRContext *context, int num1QGates, int num2QGates) 
        : OpRewritePattern<QuantumProgramIteration>(context, 100) {
        this->num1QGates = num1QGates;
        this->num2QGates = num2QGates;
    }

    LogicalResult matchAndRewrite(QuantumProgramIteration op, PatternRewriter &rewriter) const override {
        if (op->getAttr("random-samples-added")) {
            return failure();
        }

        // save insertion point from before
        auto insertionPoint = rewriter.saveInsertionPoint();
        auto loc = op.getLoc();

        // set insertion point to right before the start of quantumprogram iteration
        // this assumes that the quantumprogramiteration always exists,
        // and is nested inside some other operation
        // ex. a for loop that iterates over the shots for a circuit,
        // or a simple main function
        rewriter.setInsertionPoint(op);

        // add a new UniformIntegerDistribution op with shape equal to
        // the output of the gate count analysis pass
        // no sampling required for 2Q gates, since we always replace 2Q
        // gates with CNOTs
        Value low = rewriter.create<arith::ConstantOp>(
            loc, 
            rewriter.getI32IntegerAttr(0)
        );

        Value high = rewriter.create<arith::ConstantOp>(
            loc, 
            rewriter.getI32IntegerAttr(4)
        );

        Value dim1 = rewriter.create<arith::ConstantOp>(
            loc,
            rewriter.getI32IntegerAttr(this->num1QGates)
        );

        SmallVector<Value> shapeValues{dim1};
        SmallVector<int64_t> staticShape{this->num1QGates};

        TensorType resultType = RankedTensorType::get(
            staticShape,
            rewriter.getI32Type()
        );

        auto cliffordIndices = rewriter.create<ensemble::UniformIntegerDistributionOp>(
            op.getLoc(), resultType, low, high, shapeValues
        );

        cliffordIndices->setAttr("is-clifford-indices", rewriter.getUnitAttr());
    
        // prevent infinite application of the pass
        rewriter.updateRootInPlace(op, [&]() { 
            op->setAttr("random-samples-added", rewriter.getUnitAttr()); 
        });

        // restore insertion point
        rewriter.restoreInsertionPoint(insertionPoint);

        return success();
    }
};

struct AddCliffordGateDistribution : public OpRewritePattern<QuantumProgramIteration> {
    AddCliffordGateDistribution(mlir::MLIRContext *context) 
        : OpRewritePattern<QuantumProgramIteration>(context, 90) {}

    LogicalResult matchAndRewrite(QuantumProgramIteration op, PatternRewriter &rewriter) const override {
        if (op->getAttr("clifford-distribution-added")) {
            return failure();
        }

        // save insertion point from before
        auto insertionPoint = rewriter.saveInsertionPoint();
        auto loc = op.getLoc();

        // set insertion point to right before the start of quantumprogram iteration
        // this assumes that the quantumprogramiteration always exists,
        // and is nested inside some other operation
        // ex. a for loop that iterates over the shots for a circuit,
        // or a simple main function
        rewriter.setInsertionPoint(op);

        // create a distribution over clifford gates 
        // [H, X, S, Z]
        Type gateType = ensemble::GateType::get(getContext());
        Type gateDistributionType = ensemble::GateDistributionType::get(getContext());
        SmallVector<Value> parameters;
        IntegerAttr numOperandsAttr = rewriter.getI32IntegerAttr(1);

        auto hGate = rewriter.create<ensemble::GateConstructorOp>(
            loc,
            gateType,
            rewriter.getStringAttr("H"), 
            nullptr,
            numOperandsAttr,
            parameters
        ).getResult();

        auto sGate = rewriter.create<ensemble::GateConstructorOp>(
            loc,
            gateType,
            rewriter.getStringAttr("S"), 
            nullptr,
            numOperandsAttr,
            parameters
        ).getResult();

        auto xGate = rewriter.create<ensemble::GateConstructorOp>(
            loc,
            gateType,
            rewriter.getStringAttr("X"), 
            nullptr,
            numOperandsAttr,
            parameters
        ).getResult();

        auto zGate = rewriter.create<ensemble::GateConstructorOp>(
            loc,
            gateType,
            rewriter.getStringAttr("Z"), 
            nullptr,
            numOperandsAttr,
            parameters
        ).getResult();

        SmallVector<Value> gates{hGate, xGate, sGate, zGate};

        auto cliffordDistribution = rewriter.create<ensemble::GateDistributionConstructor>(
            loc, gateDistributionType, gates
        );

        cliffordDistribution->setAttr("is-clifford-distribution", rewriter.getUnitAttr());       
    
        // add a tensor with a single element to keep track of 
        // how many gates we have processed (for later)
        SmallVector<int32_t, 9> values = {0, 1, 2, 3, 4, 5, 6, 7, 8};
        auto tensorType = RankedTensorType::get({9}, rewriter.getI32Type());
        auto dencseAttr = DenseIntElementsAttr::get(tensorType, values);
        
        // Create the constant operation with the dense tensor attribute
        auto addedTensor = rewriter.create<arith::ConstantOp>(loc, tensorType, denseAttr);
        addedTensor->setAttr("is-count-tensor", rewriter.getUnitAttr());

        // prevent infinite application of the pass
        rewriter.updateRootInPlace(op, [&]() { 
            op->setAttr("clifford-distribution-added", rewriter.getUnitAttr()); 
        });

        // restore insertion point
        rewriter.restoreInsertionPoint(insertionPoint);

        return success();
    }
};

struct ChangeGatesToCliffordDistributions : public OpRewritePattern<ApplyGate> {
    mlir::Value cliffordDistribution;
    mlir::Value integerIndices;
    int num1QGatesReplaced = 0;
    mlir::Value gateApplicationCount;

    ChangeGatesToCliffordDistributions(mlir::MLIRContext *context, mlir::Operation *op) 
        : OpRewritePattern<ApplyGate>(context, 70) {
        op->walk([this](Operation *op) {
            // get the clifford gate distribution operation
            // and fetch its result
            if (dyn_cast<ensemble::GateDistributionConstructor>(op) != nullptr) {
                if (op->getAttr("is-clifford-distribution")) {
                    GateDistributionConstructor distConstructor = dyn_cast<ensemble::GateDistributionConstructor>(op);
                    this->cliffordDistribution = distConstructor->getResult(0);
                }
            } else if (dyn_cast<ensemble::UniformIntegerDistributionOp>(op) != nullptr) { 
                if (op->getAttr("is-clifford-indices")) {
                    UniformIntegerDistributionOp cliffordInds = dyn_cast<ensemble::UniformIntegerDistributionOp>(op);
                    this->integerIndices = cliffordInds->getResult(0);
                }
            } else if (dyn_cast<arith::ConstantOp>(op) != nullptr) {
                if (op->getAttr("is-count-tensor")) {
                    arith::ConstantOp countTensor = dyn_cast<arith::ConstantOp>(op);
                    this->gateApplicationCount = countTensor->getResult(0);
                }
            }
        });

        llvm::outs() << this->gateApplicationCount << "\n";
    }

    LogicalResult matchAndRewrite(ApplyGate op, PatternRewriter &rewriter) const override {
        if (op->getAttr("gate-replaced-with-clifford-distribution")) {
            return failure();
        }

        // save insertion point from before
        auto insertionPoint = rewriter.saveInsertionPoint();
        auto loc = op.getLoc();

        // insert new ops right before the current operation
        rewriter.setInsertionPoint(op);
  
        // use the clifford distribution for 1Q gates
        // for 2Q gates, always use CNOT
        if (op.getNumOperands() == 2) {
            Value index = rewriter.create<arith::ConstantOp>(
                loc,
                rewriter.getIndexAttr(0)
            );

            auto tensorExtractOp = rewriter.create<tensor::ExtractOp>(
                loc,
                this->integerIndices,
                index
            );

            rewriter.create<ensemble::ApplyGateDistribution>(
                loc,
                this->cliffordDistribution,
                tensorExtractOp.getResult(),
                op.getOperand(1)
            );
        }
    
        // prevent infinite application of the pass
        rewriter.updateRootInPlace(op, [&]() { 
            op->setAttr("gate-replaced-with-clifford-distribution", rewriter.getUnitAttr()); 
        });

        // restore insertion point
        rewriter.restoreInsertionPoint(insertionPoint);

        return success();
    }
};

struct CliffordDataRegression
    : impl::CliffordDataRegressionBase<CliffordDataRegression> {
  using CliffordDataRegressionBase::CliffordDataRegressionBase;

  void runOnOperation() {
    Operation *op = getOperation();

    // count how many gates there are in the circuit
    CountGatelikeOps gateOpsCounter(op);
    std::pair<int, int> gateCounts = gateOpsCounter.getGatelikeOpsCount();

    mlir::RewritePatternSet patterns(&getContext());

    // add random sampling instruction to get gate
    // indices for all the gate distribution applications we insert
    patterns.add<AddRandomGateIndexSamples>(
        &getContext(), gateCounts.first, gateCounts.second
    );

    // insert the clifford gate distribution
    patterns.add<AddCliffordGateDistribution>(&getContext());

    (void)applyPatternsAndFoldGreedily(op, std::move(patterns));

    patterns.clear();
    patterns.add<ChangeGatesToCliffordDistributions>(&getContext(), op);

    (void)applyPatternsAndFoldGreedily(op, std::move(patterns));
  }
};

}  // namespace ensemble
}  // namespace qe
}  // namespace mlir
