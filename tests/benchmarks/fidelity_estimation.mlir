module {
    func.func @main(%qubits: tensor<8 x !ensemble.physical_qubit>, %cbits: tensor<8 x !ensemble.cbit>, %circuit_index : i32) {
        // pauli_indices = int_uniform(low=0, high=3, size=8)
        %zero = arith.constant 0 : i32
        %three = arith.constant 3 : i32
        %eight = arith.constant 8 : i32
        %pauli_indices = ensemble.int_uniform %zero, %three, [%eight] : (i32, i32, i32) -> tensor<8xi32>
        
        // circuit description - GHZ on 8 qubits
        ensemble.reset_tensor %qubits : (tensor<8 x !ensemble.physical_qubit>) -> ()
        
        %h_gate = ensemble.gate "H" 1 : () -> (!ensemble.gate)
        %cx_gate = ensemble.gate "CX" 2 : () -> (!ensemble.gate)
        %i_gate = ensemble.gate "I" 1 : () -> (!ensemble.gate)
        %h_gate_1q = ensemble.gate "H" 1 : () -> (!ensemble.gate)
        %sdag_gate = ensemble.gate "Sdag" 1 : () -> (!ensemble.gate)
        %gates_1 = ensemble.gate_distribution %i_gate, %h_gate_1q, %sdag_gate : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> (!ensemble.gate_distribution)
        %gates_2 = ensemble.gate_distribution %i_gate, %i_gate, %h_gate_1q : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> (!ensemble.gate_distribution)

        // Apply H gate to the first qubit
        %zero_index = arith.constant 0 : index
        %qubit_0 = tensor.extract %qubits[%zero_index] : tensor<8 x !ensemble.physical_qubit>
        ensemble.apply %h_gate %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

        // Apply CX gates to create GHZ state
        affine.for %i = 0 to 7 step 1 {
            %qubit_at_i = tensor.extract %qubits[%i] : tensor<8 x !ensemble.physical_qubit>
            %one = arith.constant 1 : index  
            %iplus1 = arith.addi %i, %one : index
            %qubit_at_i_plus_1 = tensor.extract %qubits[%iplus1] : tensor<8 x !ensemble.physical_qubit>
            ensemble.apply %cx_gate %qubit_at_i, %qubit_at_i_plus_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        }

        // Apply Pauli gates and measure
        affine.for %i = 0 to 8 step 1 {
            %qubit_at_i = tensor.extract %qubits[%i] : tensor<8 x !ensemble.physical_qubit>
            %pauli_index_at_i = tensor.extract %pauli_indices [%i] : tensor<8 x i32>
            ensemble.apply_distribution %gates_1 [%pauli_index_at_i] %qubit_at_i : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %gates_2 [%pauli_index_at_i] %qubit_at_i : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            %cbit_at_i = tensor.extract %cbits[%i] : tensor<8 x !ensemble.cbit>
            ensemble.measure %qubit_at_i, %cbit_at_i : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        return
    }
}