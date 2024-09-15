module {
    func.func @main(%qubits: tensor<8 x !ensemble.qubit>, %cbits: tensor<8 x !ensemble.cbit>, %circuit_index : i32) {
        // pauli_indices = int_unform(low=0, high=3, size=8)
        %pauli_indices = ensemble.int_uniform 0, 3, [8]: () -> tensor<8 x i32>
        
        // circuit description - GHZ on 8 qubits
        // reset qubits;
        %0 = ensemble.Nq_reset %qubits : (tensor<8 x !ensemble.qubit>) -> (tensor<8 x !ensemble.qubit>)
        
        affine.for %i = 0 to 8 step 1 {
            // qubits[i];
            %1 = tensor.extract %0[%i] : tensor<8 x !ensemble.qubit>
            // gate1q "H" qubits[i];
            %2 = ensemble.gate1q "H" %1 : (!ensemble.qubit) -> (!ensemble.qubit)
        }

        affine.for %i = 0 to 7 step 1 {
            // qubits[i]
            %qubit_at_i = tensor.extract %0[%i] : tensor<8 x !ensemble.qubit>
            %one = arith.constant 1 : index  
            %iplus1 = arith.addi %i, %one : index  // i + 1
            // %qubits[i+1]
            %qubit_at_i_plus_1 = tensor.extract %0[%iplus1] : tensor<8 x !ensemble.qubit> // qubit[i+1]
            // gate2q "CX" qubits[i], qubits[i + 1];
            %2, %3 = ensemble.gate2q "CX" %qubit_at_i, %qubit_at_i_plus_1 : (!ensemble.qubit, !ensemble.qubit) -> (!ensemble.qubit, !ensemble.qubit)
        }

        affine.for %i = 0 to 8 step 1 {
            // qubits[i]
            %qubit_at_i = tensor.extract %0[%i] : tensor<8 x !ensemble.qubit>
            // pauli_indices[i]
            %pauli_index_at_i = tensor.extract %pauli_indices [%i] : tensor<8 x i32>
            // gate1q ["X", "Y", "Z"][pauli_indices[i]] qubits[i];
            %1 = ensemble.gate_distribution_1q ["X", "Y", "Z"] [%pauli_index_at_i] %qubit_at_i : (!ensemble.qubit , i32) -> (!ensemble.qubit)
            // cbit[i]
            %cbit_at_i = tensor.extract %cbits[%i] : tensor<8 x !ensemble.cbit>
            %2, %3 = ensemble.measure %1, %cbit_at_i : (!ensemble.qubit, !ensemble.cbit) -> (!ensemble.qubit, !ensemble.cbit) 
        }
        return
    }
}