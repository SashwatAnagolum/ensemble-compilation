module {
    func.func private @iteration_body(%circuit_index: i32,  %qubits: tensor<4x!ensemble.physical_qubit>, %bits: tensor<4x!ensemble.cbit>) {
        %I_gate = ensemble.gate "I" 1 : () -> !ensemble.gate
        %H_gate = ensemble.gate "H" 1 : () -> !ensemble.gate
        %X_gate = ensemble.gate "X" 1 : () -> !ensemble.gate
        %S_gate = ensemble.gate "S" 1 : () -> !ensemble.gate

        %I_gate_inverse = ensemble.gate "I" "inverse" 1 : () -> !ensemble.gate
        %H_gate_inverse = ensemble.gate "H" "inverse" 1 : () -> !ensemble.gate
        %X_gate_inverse = ensemble.gate "X" "inverse" 1 : () -> !ensemble.gate
        %S_gate_inverse = ensemble.gate "S" "inverse" 1 : () -> !ensemble.gate
        %cxgate = ensemble.gate "CX" 2 : () -> !ensemble.gate

        

        %pauli_measurement_shifts = ensemble.gate_distribution %I_gate, %H_gate, %S_gate, %I_gate, %I_gate, %H_gate, %X_gate, %X_gate, %X_gate : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        // indexing into pms[i][j] is pms[i * 3 + j]

        %pauli_measurement_shifts_inverses = ensemble.gate_distribution %I_gate_inverse, %H_gate_inverse, %S_gate_inverse, %I_gate_inverse, %I_gate_inverse, %H_gate_inverse, %X_gate_inverse, %X_gate_inverse, %X_gate_inverse : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %zero_i32 = arith.constant 0 : i32
        %zero_index = arith.constant 0 : index
        %one_index = arith.constant 1 : index
        %six_i32 = arith.constant 6 : i32
        %two_i32 = arith.constant 2 : i32
        %four_i32 = arith.constant 4 : i32
        %one_i32 = arith.constant 1 : i32
        %three_i32 = arith.constant 3 : i32
        %four_index = arith.constant 4 : index
        %three_index = arith.constant 3 : index
        %measurement_basis_indices = ensemble.int_uniform %zero_i32, %six_i32, [%two_i32, %four_i32] : (i32, i32, i32, i32) -> tensor<2x4xi32>

        ensemble.quantum_program_iteration {

            ensemble.reset_tensor %qubits : (tensor<4x!ensemble.physical_qubit>) -> ()
            scf.for %i = %zero_index to %four_index step %one_index {
                %mbi_0i = tensor.extract %measurement_basis_indices[%zero_index, %i] : tensor<2x4xi32>
                %three_mbi_0i = arith.muli %three_i32, %mbi_0i : i32
                %three_mbi_plus2 = arith.addi %three_mbi_0i, %two_i32 : i32
                %three_mbi_plus1 = arith.addi %three_mbi_plus2, %one_i32 : i32
                %three_mbi_plus1_index = arith.index_cast %three_mbi_plus1 : i32 to index
                %three_mbi_plus2_index = arith.index_cast %three_mbi_plus2 : i32 to index
                %three_mbi_index = arith.index_cast %three_mbi_0i : i32 to index

                %qubit_i = tensor.extract %qubits[%i] : tensor<4x!ensemble.physical_qubit>
                ensemble.apply_distribution %pauli_measurement_shifts_inverses[%three_mbi_plus2_index] %qubit_i : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
                ensemble.apply_distribution %pauli_measurement_shifts_inverses[%three_mbi_plus1_index] %qubit_i : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
                ensemble.apply_distribution %pauli_measurement_shifts_inverses[%three_mbi_index] %qubit_i : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
            }

            %qubit_0 = tensor.extract %qubits[%zero_index] : tensor<4x!ensemble.physical_qubit>
            ensemble.apply %H_gate %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            

            scf.for %i = %zero_index to %three_index step %one_index {
                %qubit_i = tensor.extract %qubits[%i] : tensor<4x!ensemble.physical_qubit>
                %i_plus1 = arith.addi %i, %one_index : index
                %qubit_i_plus1 = tensor.extract %qubits[%i_plus1] : tensor<4x!ensemble.physical_qubit>
                ensemble.apply %cxgate %qubit_i, %qubit_i_plus1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }

            scf.for %i = %zero_index to %four_index step %one_index {
                %qubit_i = tensor.extract %qubits[%i] : tensor<4x!ensemble.physical_qubit>
                %mbi_1i = tensor.extract %measurement_basis_indices[%one_index, %i] : tensor<2x4xi32>
                %three_mbi_1i = arith.muli %three_i32, %mbi_1i : i32
                %three_mbi_1i_index = arith.index_cast %three_mbi_1i : i32 to index
                %three_mbi_1i_plus1 = arith.addi %three_mbi_1i, %one_i32 : i32
                %three_mbi_1i_plus1_index = arith.index_cast %three_mbi_1i_plus1 : i32 to index
                
                ensemble.apply_distribution %pauli_measurement_shifts[%three_mbi_1i_index] %qubit_i : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
                ensemble.apply_distribution %pauli_measurement_shifts[%three_mbi_1i_plus1_index] %qubit_i : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
            }

            scf.for %i = %zero_index to %four_index step %one_index {
                %qubit_i = tensor.extract %qubits[%i] : tensor<4x!ensemble.physical_qubit>
                %cbit_i = tensor.extract %bits[%i] : tensor<4x!ensemble.cbit>
                ensemble.measure %qubit_i, %cbit_i : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
            }

            ensemble.transmit_results %bits : (tensor<4x!ensemble.cbit>) -> ()
        }

        return

    }

    func.func @main() {
        %num_circuits = arith.constant 1024 : i32
        %num_measurement_bases = arith.constant 1024 : i32
        %num_qubits = arith.constant 4 : i32

        %qubits = ensemble.program_alloc 4 : () -> tensor<4x!ensemble.physical_qubit>
        %bits = ensemble.alloc_cbits 4 : () -> tensor<4x!ensemble.cbit>

        %num_circuits_i32 = arith.index_cast %num_circuits : i32 to index
        %zero_index = arith.constant 0 : index
        %one_index = arith.constant 1 : index

        scf.for %circuit_index = %zero_index to %num_circuits_i32 step %one_index {
            %circuit_index_i32 = arith.index_cast %circuit_index : index to i32
            func.call @iteration_body(%circuit_index_i32, %qubits, %bits) : (i32, tensor<4x!ensemble.physical_qubit>, tensor<4x!ensemble.cbit>) -> ()
        }

       
        return
    }
}
