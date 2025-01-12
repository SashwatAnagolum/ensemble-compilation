module {
    func.func private @iteration_body(%qubits: tensor<10 x !ensemble.physical_qubit>, %cbits: tensor<10 x !ensemble.cbit>, %circuit_index : i32) {
        // pauli_indices = int_uniform(low=0, high=3, size=8)
        %zero = arith.constant 0 : i32
        %three = arith.constant 3 : i32
        %ten = arith.constant 10 : i32
        %pauli_indices = ensemble.int_uniform %zero, %three, [%ten] : (i32, i32, i32) -> tensor<10xi32>
        
        // circuit description - GHZ on 10 qubits
        %h_gate = ensemble.gate "H" 1 : () -> (!ensemble.gate)
        %cx_gate = ensemble.gate "CX" 2 : () -> (!ensemble.gate)
        %i_gate = ensemble.gate "I" 1 : () -> (!ensemble.gate)
        %h_gate_1q = ensemble.gate "H" 1 : () -> (!ensemble.gate)
        %sdag_gate = ensemble.gate "Sdag" 1 : () -> (!ensemble.gate)
        %gates_1 = ensemble.gate_distribution %i_gate, %h_gate_1q, %sdag_gate : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> (!ensemble.gate_distribution)
        %gates_2 = ensemble.gate_distribution %i_gate, %i_gate, %h_gate_1q : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> (!ensemble.gate_distribution)

        ensemble.quantum_program_iteration {
            ensemble.reset_tensor %qubits : (tensor<10 x !ensemble.physical_qubit>) -> ()

            // Apply H gate to the first qubit
            %zero_index = arith.constant 0 : index
            %qubit_0 = tensor.extract %qubits[%zero_index] : tensor<10 x !ensemble.physical_qubit>
            ensemble.apply %h_gate %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            // Apply CX gates to create GHZ state
            %nine_index = arith.constant 9 : index
            %one_index = arith.constant 1 : index
            scf.for %i = %zero_index to %nine_index step %one_index {
                %qubit_at_i = tensor.extract %qubits[%i] : tensor<10 x !ensemble.physical_qubit>
                %iplus1 = arith.addi %i, %one_index : index
                %qubit_at_i_plus_1 = tensor.extract %qubits[%iplus1] : tensor<10 x !ensemble.physical_qubit>
                ensemble.apply %cx_gate %qubit_at_i, %qubit_at_i_plus_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }

            // Apply Pauli gates and measure
            %ten_index = arith.constant 10 : index
            scf.for %i = %zero_index to %ten_index step %one_index {
                %qubit_at_i = tensor.extract %qubits[%i] : tensor<10 x !ensemble.physical_qubit>
                %pauli_index_at_i = tensor.extract %pauli_indices [%i] : tensor<10 x i32>
                ensemble.apply_distribution %gates_1 [%pauli_index_at_i] %qubit_at_i : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
                ensemble.apply_distribution %gates_2 [%pauli_index_at_i] %qubit_at_i : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
                %cbit_at_i = tensor.extract %cbits[%i] : tensor<10 x !ensemble.cbit>
                ensemble.measure %qubit_at_i, %cbit_at_i : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
            }
            ensemble.transmit_results %cbits : (tensor<10 x !ensemble.cbit>) -> ()
        }
        return
    }
    func.func @main() {
        %qubits = ensemble.program_alloc 10 : () -> (tensor<10 x !ensemble.physical_qubit>)
        %cbits = ensemble.alloc_cbits 10 : () -> (tensor<10 x !ensemble.cbit>)
        %zero_index = arith.constant 0 : index
        %thousand_index = arith.constant 1000 : index
        %one_index = arith.constant 1 : index
        scf.for %i = %zero_index to %thousand_index step %one_index {
            %i_i32 = arith.index_cast %i : index to i32
            func.call @iteration_body(%qubits, %cbits, %i_i32) : (tensor<10 x !ensemble.physical_qubit>, tensor<10 x !ensemble.cbit>, i32) -> ()
        }
        return
    }
}