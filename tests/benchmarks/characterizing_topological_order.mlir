module {
    func.func private @iteration_body(%qubits: tensor<31x!ensemble.physical_qubit>, %bits: tensor<31x!ensemble.cbit>, %circuit_index: index, %qubits_to_measure: tensor<9xi32>) -> () {
        %H = ensemble.gate "H" 1 : () -> !ensemble.gate
        %CX = ensemble.gate "CX" 2 : () -> !ensemble.gate
        %I = ensemble.gate "I" 1 : () -> !ensemble.gate
        %Sdag = ensemble.gate "Sdag" 1 : () -> !ensemble.gate

        %zero_i32 = arith.constant 0 : i32
        %three_i32 = arith.constant 3 : i32
        %four_i32 = arith.constant 4 : i32
        %five_i32 = arith.constant 5 : i32
        %eight_i32 = arith.constant 8 : i32
        %seven_i32 = arith.constant 7 : i32
        %nine_i32 = arith.constant 9 : i32
        %ten_i32 = arith.constant 10 : i32
        %eleven_i32 = arith.constant 11 : i32
        %twelve_i32 = arith.constant 12 : i32
        %pauli_indices = ensemble.int_uniform %zero_i32, %three_i32, [%nine_i32] : (i32, i32, i32) -> tensor<9xi32>

        %zero_index = arith.constant 0 : index
        %one_index = arith.constant 1 : index
        %three_index = arith.constant 3 : index
        %four_index = arith.constant 4 : index
        %nine_index = arith.constant 9 : index

        ensemble.reset_tensor %qubits : (tensor<31x!ensemble.physical_qubit>) -> ()
        ensemble.quantum_program_iteration {
            scf.for %i = %zero_index to %three_index step %one_index {
                scf.for %j = %zero_index to %four_index step %one_index {
                    //
                    %i_i32 = arith.index_cast %i : index to i32
                    %j_i32 = arith.index_cast %j : index to i32
                    %nine_i_mul = arith.muli %nine_i32, %i_i32 : i32
                    %nine_i_plus_j = arith.addi %nine_i_mul, %j_i32 : i32
                    %qubit_index = arith.index_cast %nine_i_plus_j : i32 to index
                    // gate1q "H" qubits[9 * i + j];
                    %qubit = tensor.extract %qubits[%qubit_index] : tensor<31x!ensemble.physical_qubit>
                    ensemble.apply %H %qubit : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                }
            }

            scf.for %i = %zero_index to %three_index step %one_index {
                scf.for %j = %one_index to %three_index step %one_index {
                    // gate2q "CX" qubits[9 * i + j], qubits[9 * i + j + 4];
                    %i_i32 = arith.index_cast %i : index to i32
                    %j_i32 = arith.index_cast %j : index to i32
                    %nine_i_mul = arith.muli %nine_i32, %i_i32 : i32
                    %nine_i_plus_j = arith.addi %nine_i_mul, %j_i32 : i32
                    %qubit_index_1 = arith.index_cast %nine_i_plus_j : i32 to index
                    %qubit_index_i32 = arith.addi %nine_i_plus_j, %four_i32 : i32
                    %qubit_index_2 = arith.index_cast %qubit_index_i32 : i32 to index
                    %qubit_1 = tensor.extract %qubits[%qubit_index_1] : tensor<31x!ensemble.physical_qubit>
                    %qubit_2 = tensor.extract %qubits[%qubit_index_2] : tensor<31x!ensemble.physical_qubit>
                    ensemble.apply %CX %qubit_1, %qubit_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                }
            }

            scf.for %i = %zero_index to %three_index step %one_index {
                scf.for %j = %one_index to %three_index step %one_index {
                    // gate2q "CX" qubits[9 * i + j], qubits[9 * i + j + 5];
                    %i_i32 = arith.index_cast %i : index to i32
                    %j_i32 = arith.index_cast %j : index to i32
                    %nine_i_mul = arith.muli %nine_i32, %i_i32 : i32
                    %nine_i_plus_j = arith.addi %nine_i_mul, %j_i32 : i32
                    %qubit_index_1 = arith.index_cast %nine_i_plus_j : i32 to index
                    %qubit_index_i32 = arith.addi %nine_i_plus_j, %five_i32 : i32
                    %qubit_index_2 = arith.index_cast %qubit_index_i32 : i32 to index
                    %qubit_1 = tensor.extract %qubits[%qubit_index_1] : tensor<31x!ensemble.physical_qubit>
                    %qubit_2 = tensor.extract %qubits[%qubit_index_2] : tensor<31x!ensemble.physical_qubit>
                    ensemble.apply %CX %qubit_1, %qubit_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                }
            }

            scf.for %i = %zero_index to %three_index step %one_index {
                // gate2q "CX" qubits[9 * i], qubits[9 * i + 4];
                // gate2q "CX" qubits[9 * i + 3], qubits[9 * i + 8];
                // gate2q "CX" qubits[9 * i + 5], qubits[9 * i + 10];
                // gate2q "CX" qubits[9 * i + 7], qubits[9 * i + 11];
                %i_i32 = arith.index_cast %i : index to i32
                %nine_i_mul = arith.muli %nine_i32, %i_i32 : i32
                %nine_i_plus_four = arith.addi %nine_i_mul, %four_i32 : i32
                %nine_i_plus_three = arith.addi %nine_i_mul, %three_i32 : i32
                %nine_i_plus_eight = arith.addi %nine_i_mul, %eight_i32 : i32
                %nine_i_plus_five = arith.addi %nine_i_mul, %five_i32 : i32
                %nine_i_plus_ten = arith.addi %nine_i_mul, %ten_i32 : i32
                %nine_i_plus_seven = arith.addi %nine_i_mul, %seven_i32 : i32
                %nine_i_plus_eleven = arith.addi %nine_i_mul, %eleven_i32 : i32
                %qubit_index_0 = arith.index_cast %nine_i_mul : i32 to index
                %qubit_index_1 = arith.index_cast %nine_i_plus_four : i32 to index
                %qubit_index_2 = arith.index_cast %nine_i_plus_three : i32 to index
                %qubit_index_3 = arith.index_cast %nine_i_plus_eight : i32 to index
                %qubit_index_4 = arith.index_cast %nine_i_plus_five : i32 to index
                %qubit_index_5 = arith.index_cast %nine_i_plus_ten : i32 to index
                %qubit_index_6 = arith.index_cast %nine_i_plus_seven : i32 to index
                %qubit_index_7 = arith.index_cast %nine_i_plus_eleven : i32 to index
                %qubit_0 = tensor.extract %qubits[%qubit_index_0] : tensor<31x!ensemble.physical_qubit>
                %qubit_1 = tensor.extract %qubits[%qubit_index_1] : tensor<31x!ensemble.physical_qubit>
                %qubit_2 = tensor.extract %qubits[%qubit_index_2] : tensor<31x!ensemble.physical_qubit>
                %qubit_3 = tensor.extract %qubits[%qubit_index_3] : tensor<31x!ensemble.physical_qubit>
                %qubit_4 = tensor.extract %qubits[%qubit_index_4] : tensor<31x!ensemble.physical_qubit>
                %qubit_5 = tensor.extract %qubits[%qubit_index_5] : tensor<31x!ensemble.physical_qubit>
                %qubit_6 = tensor.extract %qubits[%qubit_index_6] : tensor<31x!ensemble.physical_qubit>
                %qubit_7 = tensor.extract %qubits[%qubit_index_7] : tensor<31x!ensemble.physical_qubit>
                ensemble.apply %CX %qubit_0, %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                ensemble.apply %CX %qubit_2, %qubit_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                ensemble.apply %CX %qubit_4, %qubit_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                ensemble.apply %CX %qubit_6, %qubit_7 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }

            scf.for %i = %zero_index to %three_index step %one_index {
                // gate2q "CX" qubits[9 * i], qubits[9 * i + 5];
                // gate2q "CX" qubits[9 * i + 3], qubits[9 * i + 7];
                %i_i32 = arith.index_cast %i : index to i32
                %nine_i_mul = arith.muli %nine_i32, %i_i32 : i32
                %nine_i_plus_five = arith.addi %nine_i_mul, %five_i32 : i32
                %nine_i_plus_three = arith.addi %nine_i_mul, %three_i32 : i32
                %nine_i_plus_seven = arith.addi %nine_i_mul, %seven_i32 : i32
                %qubit_index_0 = arith.index_cast %nine_i_mul : i32 to index
                %qubit_index_1 = arith.index_cast %nine_i_plus_five : i32 to index
                %qubit_index_2 = arith.index_cast %nine_i_plus_three : i32 to index
                %qubit_index_3 = arith.index_cast %nine_i_plus_seven : i32 to index
                %qubit_0 = tensor.extract %qubits[%qubit_index_0] : tensor<31x!ensemble.physical_qubit>
                %qubit_1 = tensor.extract %qubits[%qubit_index_1] : tensor<31x!ensemble.physical_qubit>
                %qubit_2 = tensor.extract %qubits[%qubit_index_2] : tensor<31x!ensemble.physical_qubit>
                %qubit_3 = tensor.extract %qubits[%qubit_index_3] : tensor<31x!ensemble.physical_qubit>
                ensemble.apply %CX %qubit_0, %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                ensemble.apply %CX %qubit_2, %qubit_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }

            scf.for %i = %zero_index to %three_index step %one_index {
                // gate2q "CX" qubits[9 * i + 4], qubits[9 * i + 9];
                // gate2q "CX" qubits[9 * i + 8], qubits[9 * i + 12];
                %i_i32 = arith.index_cast %i : index to i32
                %nine_i_mul = arith.muli %nine_i32, %i_i32 : i32
                %nine_i_plus_four = arith.addi %nine_i_mul, %four_i32 : i32
                %nine_i_plus_nine = arith.addi %nine_i_mul, %nine_i32 : i32
                %nine_i_plus_eight = arith.addi %nine_i_mul, %eight_i32 : i32
                %nine_i_plus_twelve = arith.addi %nine_i_mul, %twelve_i32 : i32
                %qubit_index_0 = arith.index_cast %nine_i_plus_four : i32 to index
                %qubit_index_1 = arith.index_cast %nine_i_plus_nine : i32 to index
                %qubit_index_2 = arith.index_cast %nine_i_plus_eight : i32 to index
                %qubit_index_3 = arith.index_cast %nine_i_plus_twelve : i32 to index
                %qubit_0 = tensor.extract %qubits[%qubit_index_0] : tensor<31x!ensemble.physical_qubit>
                %qubit_1 = tensor.extract %qubits[%qubit_index_1] : tensor<31x!ensemble.physical_qubit>
                %qubit_2 = tensor.extract %qubits[%qubit_index_2] : tensor<31x!ensemble.physical_qubit>
                %qubit_3 = tensor.extract %qubits[%qubit_index_3] : tensor<31x!ensemble.physical_qubit>
                ensemble.apply %CX %qubit_0, %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                ensemble.apply %CX %qubit_2, %qubit_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }
            scf.for %i = %zero_index to %nine_index step %one_index {
                // gate1q ["I", "H", "Sdag"][pauli_indices[i]] qubits[qubits_to_measure[i]];
                // gate1q ["I", "I", "H"][pauli_indices[i]] qubits[qubits_to_measure[i]];

                // measure qubits[qubits_to_measure[i]], bits[i];
                %i_index = arith.index_cast %i : index to i32
                %qubit_i32_to_measure = tensor.extract %qubits_to_measure[%i] : tensor<9xi32>
                %qubit_index_to_measure = arith.index_cast %qubit_i32_to_measure : i32 to index
                %qubit = tensor.extract %qubits[%qubit_index_to_measure] : tensor<31x!ensemble.physical_qubit>
                %bit = tensor.extract %bits[%i] : tensor<31x!ensemble.cbit>
                %gate_dist_1 = ensemble.gate_distribution %I, %H, %Sdag : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
                %gate_dist_2 = ensemble.gate_distribution %I, %I, %H : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
                %pauli_i32_i = tensor.extract %pauli_indices[%i] : tensor<9xi32>
                %pauli_index_i = arith.index_cast %pauli_i32_i : i32 to index
                ensemble.apply_distribution %gate_dist_1 [%pauli_index_i] %qubit : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
                ensemble.apply_distribution %gate_dist_2 [%pauli_index_i] %qubit : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
                ensemble.measure %qubit, %bit : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
            }
            ensemble.transmit_results %bits : (tensor<31x!ensemble.cbit>) -> ()
        }
        
        return
       
    }
    func.func @main() -> () {
        %num_circuits = arith.constant 1024 : i32
        %qubits = ensemble.program_alloc 31 : () -> tensor<31x!ensemble.physical_qubit>
        %bits = ensemble.alloc_cbits 31 : () -> tensor<31x!ensemble.cbit>
        %qubits_to_measure = arith.constant dense<[14, 10, 6, 19, 15, 11, 24, 20, 16]> : tensor<9xi32>

        %zero_index = arith.constant 0 : index
        %one_index = arith.constant 1 : index
        %num_circuits_i32 = arith.index_cast %num_circuits : i32 to index
        scf.for %i = %zero_index to %num_circuits_i32 step %one_index {
            func.call @iteration_body(%qubits, %bits, %i, %qubits_to_measure) : (tensor<31x!ensemble.physical_qubit>, tensor<31x!ensemble.cbit>, index, tensor<9xi32>) -> ()
        }
        return
    }

}
