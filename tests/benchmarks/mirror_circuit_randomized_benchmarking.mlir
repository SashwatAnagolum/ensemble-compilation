module {
    func.func private @iteration_body(%qubits: tensor<16x!ensemble.physical_qubit>, %bits: tensor<16x!ensemble.cbit>, %circuit_index: index, %num_circuits_per_depth: i32, %depths: tensor<20xi32>, %connectivity: tensor<15x2x!ensemble.physical_qubit>) -> () {
        %X = ensemble.gate "X" 1 : () -> !ensemble.gate
        %Y = ensemble.gate "Y" 1 : () -> !ensemble.gate
        %Z = ensemble.gate "Z" 1 : () -> !ensemble.gate
        %H = ensemble.gate "H" 1 : () -> !ensemble.gate
        %CX = ensemble.gate "CX" 2 : () -> !ensemble.gate
        %XYZH = ensemble.gate_distribution %X, %Y, %Z, %H : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %XYZ = ensemble.gate_distribution %X, %Y, %Z : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution

        %num_circuits_per_depth_index = arith.index_cast %num_circuits_per_depth : i32 to index
        %circuit_depth_temp = arith.divsi %circuit_index, %num_circuits_per_depth_index : index
        %circuit_depth = tensor.extract %depths[%circuit_depth_temp] : tensor<20xi32>
        %circuit_depth_index = arith.index_cast %circuit_depth : i32 to index
        %num_qubits = arith.constant 16 : i32
        %two = arith.constant 2 : i32
        %half_num_qubits = arith.divsi %num_qubits, %two : i32
        %one_i32 = arith.constant 1 : i32
        %one_index = arith.index_cast %one_i32 : i32 to index
        %one_plus_num_qubits_div_two = arith.addi %half_num_qubits, %one_i32 : i32
        %zero_i32 = arith.constant 0 : i32
        %zero_index = arith.index_cast %zero_i32 : i32 to index
        %four = arith.constant 4 : i32

        %num_cnots_in_layer = ensemble.int_uniform %zero_i32, %one_plus_num_qubits_div_two, [%circuit_depth] : (i32, i32, i32) -> tensor<?xi32>
        %cnot_pairs = ensemble.cnot_pair_distribution %connectivity, [%circuit_depth, %half_num_qubits] : (tensor<15x2x!ensemble.physical_qubit>, i32, i32) -> tensor<?x8x2x!ensemble.physical_qubit>
        %circuit_depth_plus_one = arith.addi %circuit_depth, %one_i32 : i32
        %pauli_indices = ensemble.int_uniform %zero_i32, %four, [%circuit_depth_plus_one, %num_qubits] : (i32, i32, i32, i32) -> tensor<?x16xi32>
        %clifford_indices = ensemble.int_uniform %zero_i32, %four, [%circuit_depth, %num_qubits] : (i32, i32, i32, i32) -> tensor<?x16xi32>
        %initial_clifford_indices = ensemble.int_uniform %zero_i32, %four, [%num_qubits] : (i32, i32, i32) -> tensor<16xi32>

        ensemble.quantum_program_iteration {
            ensemble.reset_tensor %qubits : (tensor<16x!ensemble.physical_qubit>) -> ()
            %num_qubits_index = arith.index_cast %num_qubits : i32 to index
            
            scf.for %qubit_index = %zero_index to %num_qubits_index step %one_index {
                               %initial_clifford_index = tensor.extract %initial_clifford_indices[%qubit_index] : tensor<16xi32>
                %qubit_i = tensor.extract %qubits[%qubit_index] : tensor<16x!ensemble.physical_qubit>
                ensemble.apply_distribution %XYZH [%initial_clifford_index] %qubit_i : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            }

            scf.for %qubit_index = %zero_index to %num_qubits_index step %one_index {
                %pauli_index = tensor.extract %pauli_indices[%zero_index, %qubit_index] : tensor<?x16xi32>
                %qubit_i = tensor.extract %qubits[%qubit_index] : tensor<16x!ensemble.physical_qubit>
                ensemble.apply_distribution %XYZ [%pauli_index] %qubit_i : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            }

            scf.for %i = %zero_index to %circuit_depth_index step %one_index {
                %num_cnots_in_layer_i = tensor.extract %num_cnots_in_layer[%i] : tensor<?xi32>
                %num_cnots_in_layer_i_index = arith.index_cast %num_cnots_in_layer_i : i32 to index
        
                scf.for %cnot_index = %zero_index to %num_cnots_in_layer_i_index step %one_index {
                    %src_qubit = tensor.extract %cnot_pairs[%i, %cnot_index, %zero_index] : tensor<?x8x2x!ensemble.physical_qubit>
                    %dst_qubit = tensor.extract %cnot_pairs[%i, %cnot_index, %one_index] : tensor<?x8x2x!ensemble.physical_qubit>
                    ensemble.apply %CX %src_qubit, %dst_qubit : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                }

                %two_times_num_cnots_in_layer_i = arith.muli %num_cnots_in_layer_i, %two : i32
                %two_times_num_cnots_in_layer_i_index = arith.index_cast %two_times_num_cnots_in_layer_i : i32 to index
                scf.for %qubit_index = %two_times_num_cnots_in_layer_i_index to %num_qubits_index step %one_index {
                    %clifford_index = tensor.extract %clifford_indices[%i, %qubit_index] : tensor<?x16xi32>
                    %qubit_i = tensor.extract %qubits[%qubit_index] : tensor<16x!ensemble.physical_qubit>
                    ensemble.apply_distribution %XYZH [%clifford_index] %qubit_i : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
                }

                %i_plus_one = arith.addi %i, %one_index : index

                scf.for %qubit_index = %zero_index to %num_qubits_index step %one_index {
                    %pauli_index = tensor.extract %pauli_indices[%i_plus_one, %qubit_index] : tensor<?x16xi32>
                    %qubit_i = tensor.extract %qubits[%qubit_index] : tensor<16x!ensemble.physical_qubit>
                    ensemble.apply_distribution %XYZ [%pauli_index] %qubit_i : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
                }
            }

            scf.for %qubit_index = %zero_index to %num_qubits_index step %one_index {
                %initial_clifford_index = tensor.extract %initial_clifford_indices[%qubit_index] : tensor<16xi32>
                %qubit_i = tensor.extract %qubits[%qubit_index] : tensor<16x!ensemble.physical_qubit>
                ensemble.apply_distribution %XYZH [%initial_clifford_index] %qubit_i : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            }

            scf.for %i = %zero_index to %num_qubits_index step %one_index {
                %qubit_i = tensor.extract %qubits[%i] : tensor<16x!ensemble.physical_qubit>
                %bit_i = tensor.extract %bits[%i] : tensor<16x!ensemble.cbit>
                ensemble.measure %qubit_i, %bit_i : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
            }

            ensemble.transmit_results %bits : (tensor<16x!ensemble.cbit>) -> ()
        }

        return
    }

    func.func @main() {
        %num_circuits = arith.constant 640 : i32
        %num_circuits_per_depth = arith.constant 32 : i32
        %depths = arith.constant dense<[2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40]> : tensor<20xi32>
        %qubits = ensemble.program_alloc 16 : () -> tensor<16x!ensemble.physical_qubit>
        %bits = ensemble.alloc_cbits 16 : () -> tensor<16x!ensemble.cbit>
        %connectivity = tensor.empty() : tensor<15x2x!ensemble.physical_qubit>
        %zero_index = arith.constant 0 : index
        %one_index = arith.constant 1 : index
        %fifteen_index = arith.constant 15 : index
        scf.for %i = %zero_index to %fifteen_index step %one_index {
            %dst = arith.addi %i, %one_index : index
            %src_qubit = tensor.extract %qubits[%i] : tensor<16x!ensemble.physical_qubit>
            %dst_qubit = tensor.extract %qubits[%dst] : tensor<16x!ensemble.physical_qubit>
            tensor.insert %src_qubit into %connectivity[%i, %zero_index] : tensor<15x2x!ensemble.physical_qubit>
            tensor.insert %dst_qubit into %connectivity[%i, %one_index] : tensor<15x2x!ensemble.physical_qubit>
        }
        %num_circuits_index = arith.index_cast %num_circuits : i32 to index
        scf.for %i = %zero_index to %num_circuits_index step %one_index {
            func.call @iteration_body(%qubits, %bits, %i, %num_circuits_per_depth, %depths, %connectivity) : (tensor<16x!ensemble.physical_qubit>, tensor<16x!ensemble.cbit>, index, i32, tensor<20xi32>, tensor<15x2x!ensemble.physical_qubit>) -> ()
        }
        return
    }
}