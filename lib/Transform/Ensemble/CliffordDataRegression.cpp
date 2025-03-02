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
#include "mlir/Dialect/MemRef/IR/MemRef.h"

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
    
        // add a memref to keep track of the number of gates
        // we have changed to clifford distributions so far.
        auto counter = rewriter.create<memref::AllocOp>(
            loc,
            MemRefType::get({}, rewriter.getI32Type())
        );

        counter->setAttr("is-cdr-counter", rewriter.getUnitAttr());

        Value zero = rewriter.create<arith::ConstantOp>(
            loc, 
            rewriter.getI32IntegerAttr(0)
        );

        rewriter.create<memref::StoreOp>(loc, zero, counter);

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
    mlir::Value gateApplicationCounter;

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
            } else if (dyn_cast<memref::AllocOp>(op) != nullptr) {
                if (op->getAttr("is-cdr-counter")) {
                    memref::AllocOp counter = dyn_cast<memref::AllocOp>(op);
                    this->gateApplicationCounter = counter->getResult(0);
                }
            }
        });
    }

    LogicalResult matchAndRewrite(ApplyGate op, PatternRewriter &rewriter) const override {
        // save insertion point from before
        auto insertionPoint = rewriter.saveInsertionPoint();
        auto loc = op.getLoc();

        // insert new ops right before the current operation
        rewriter.setInsertionPoint(op);
  
        // use the clifford distribution for 1Q gates
        // for 2Q gates, always use CNOT
        if (op.getNumOperands() == 2) {
            auto counterValue = rewriter.create<memref::LoadOp>(loc, this->gateApplicationCounter);
            Value counterValueIndex = rewriter.create<arith::IndexCastOp>(loc, rewriter.getIndexType(), counterValue);

            auto tensorExtractOp = rewriter.create<tensor::ExtractOp>(
                loc,
                this->integerIndices,
                counterValueIndex
            );

            rewriter.create<ensemble::ApplyGateDistribution>(
                loc,
                this->cliffordDistribution,
                tensorExtractOp.getResult(),
                op.getOperand(1)
            );
            
            // increment the counter and store the updated value in memory
            Value one = rewriter.create<arith::ConstantOp>(
                loc,
                rewriter.getI32IntegerAttr(1)
            );

            Value newCount = rewriter.create<arith::AddIOp>(loc, counterValue, one);
            rewriter.create<memref::StoreOp>(loc, newCount, this->gateApplicationCounter);
        } else {
            // always use CNOT for 2Q gates
        }

        op.erase();

        // restore insertion point
        rewriter.restoreInsertionPoint(insertionPoint);

        return success();
    }
};

// need to create a struct that does the ChangeGatesToCliffordDistributions
// but for Apply Distribtion operations -> just subsititute the distribution
// being used for the clifford distribution, and change the index used

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
