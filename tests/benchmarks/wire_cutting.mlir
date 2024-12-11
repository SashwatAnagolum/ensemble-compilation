

module {
    func.func @wire_cutting_iteration(%circuit_index: index, %qubits: tensor<9x!ensemble.physical_qubit>, %bits: tensor<9x!ensemble.cbit>, %beta_value: f64, %gamma_value: f64) {
        %two_f64 = arith.constant 2.0 : f64
        %I_gate = ensemble.gate "I" 1 : () -> !ensemble.gate
        %H_gate = ensemble.gate "H" 1 : () -> !ensemble.gate
        %X_gate = ensemble.gate "X" 1 : () -> !ensemble.gate
        %SX_gate = ensemble.gate "SX" 1 : () -> !ensemble.gate
        %SXdag_gate = ensemble.gate "SXdag" 1 : () -> !ensemble.gate
        %twice_beta = arith.mulf %beta_value, %two_f64 : f64
        %RZZ_gate = ensemble.gate "RZZ" 2 (%twice_beta) :(f64) -> !ensemble.gate
        %twice_gamma = arith.mulf %gamma_value, %two_f64 : f64
        %RX_gate = ensemble.gate "RX" 1 (%twice_gamma) :(f64) -> !ensemble.gate

        %measurement_bases_shifts = ensemble.gate_distribution %I_gate, %I_gate, %H_gate, %H_gate, %SX_gate, %SX_gate, %I_gate, %I_gate : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution

        %state_prep_sequences_0 = ensemble.gate_distribution %I_gate, %X_gate, %H_gate, %X_gate, %SXdag_gate, %X_gate, %I_gate, %X_gate : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %state_prep_sequences_1 = ensemble.gate_distribution %I_gate, %I_gate, %I_gate, %H_gate, %I_gate, %SXdag_gate, %I_gate, %I_gate : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %two_i32 = arith.constant 2 : i32
        %two_index = arith.index_cast %two_i32 : i32 to index
        %logical_circuit_index = arith.divsi %circuit_index, %two_index : index
        %circuit_part_index = arith.remsi %circuit_index, %two_index : index

        // move_sequence_positions  is a tensor of 5 elements
        %move_sequence_positions = tensor.empty() : tensor<5xindex>
        %one_index = arith.constant 1 : index
        %eight_index = arith.constant 8 : index
        %sixty_four_index = arith.constant 64 : index
        %five_hundred_twelve_index = arith.constant 512 : index
        %four_thousand_ninety_six_index = arith.constant 4096 : index
        %divisors = tensor.from_elements %one_index, %eight_index, %sixty_four_index, %five_hundred_twelve_index, %four_thousand_ninety_six_index : tensor<5xindex>

        affine.for %i = 0 to 5 {
            %divisor = tensor.extract %divisors[%i] : tensor<5xindex>
            %log_index_divided = arith.divsi %logical_circuit_index, %divisor : index
            %divided_mod_eight = arith.remsi %log_index_divided, %eight_index : index

            tensor.insert %divided_mod_eight into %move_sequence_positions[%i] : tensor<5xindex>
        }

        ensemble.reset_tensor %qubits : (tensor<9x!ensemble.physical_qubit>) -> ()

        %circuit_part_index_i32 = arith.index_cast %circuit_part_index : index to i32
        %zero_i32 = arith.constant 0 : i32
        %one_i32 = arith.constant 1 : i32
        %equals_zero = arith.cmpi eq, %circuit_part_index_i32, %zero_i32: i32
        %equals_one = arith.cmpi eq, %circuit_part_index_i32, %one_i32: i32
        scf.if %equals_zero {
            affine.for %i = 0 to 9 {
                %qubit_i = tensor.extract %qubits[%i] : tensor<9x!ensemble.physical_qubit>
                ensemble.apply %H_gate %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            }
            affine.for %i = 0 to 3 {
                %qubit_i = tensor.extract %qubits[%i] : tensor<9x!ensemble.physical_qubit>
                %i_plus_one = arith.addi %i, %one_index : index
                %qubit_i_plus_one = tensor.extract %qubits[%i_plus_one] : tensor<9x!ensemble.physical_qubit>
                ensemble.apply %RZZ_gate %qubit_i, %qubit_i_plus_one : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }
            affine.for %qubit_1_index = 0 to 4 {
                affine.for %qubit_2_index = 4 to 9 {
                    %qubit_1 = tensor.extract %qubits[%qubit_1_index] : tensor<9x!ensemble.physical_qubit>
                    %qubit_2 = tensor.extract %qubits[%qubit_2_index] : tensor<9x!ensemble.physical_qubit>
                    ensemble.apply %RZZ_gate %qubit_1, %qubit_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                }
            }

            affine.for %qubit_index = 0 to 4 {
                %qubit = tensor.extract %qubits[%qubit_index] : tensor<9x!ensemble.physical_qubit>
                ensemble.apply %RX_gate %qubit : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            }

            affine.for %move_index = 0 to 5 {
                %four_index = arith.constant 4 : index
                %move_plus_four = arith.addi %move_index, %four_index : index
                %qubit = tensor.extract %qubits[%move_plus_four] : tensor<9x!ensemble.physical_qubit>
                %measurement_bases_shifts_index = tensor.extract %move_sequence_positions[%move_index] : tensor<5xindex>
                ensemble.apply_distribution %measurement_bases_shifts [%measurement_bases_shifts_index] %qubit : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
            }

        }
        scf.if %equals_one {
            affine.for %move_index = 0 to 5 {
                %qubit = tensor.extract %qubits[%move_index] : tensor<9x!ensemble.physical_qubit>
                %move_sequence_position = tensor.extract %move_sequence_positions[%move_index] : tensor<5xindex>
                ensemble.apply_distribution %state_prep_sequences_0 [%move_sequence_position] %qubit : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
                ensemble.apply_distribution %state_prep_sequences_1 [%move_sequence_position] %qubit : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
            }
            affine.for %i = 5 to 9 {
                %qubit = tensor.extract %qubits[%i] : tensor<9x!ensemble.physical_qubit>
                ensemble.apply %H_gate %qubit : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            }

            affine.for %qubit_1_index = 0 to 5 {
                affine.for %qubit_2_index = 5 to 9 {
                    %qubit_1 = tensor.extract %qubits[%qubit_1_index] : tensor<9x!ensemble.physical_qubit>
                    %qubit_2 = tensor.extract %qubits[%qubit_2_index] : tensor<9x!ensemble.physical_qubit>
                    ensemble.apply %RZZ_gate %qubit_1, %qubit_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                }
            }

            affine.for %i = 5 to 8 {
                %qubit_1 = tensor.extract %qubits[%i] : tensor<9x!ensemble.physical_qubit>
                %i_plus_one = arith.addi %i, %one_index : index
                %qubit_2 = tensor.extract %qubits[%i_plus_one] : tensor<9x!ensemble.physical_qubit>
                ensemble.apply %RZZ_gate %qubit_1, %qubit_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }

            affine.for %qubit_index = 0 to 9 {
                %qubit = tensor.extract %qubits[%qubit_index] : tensor<9x!ensemble.physical_qubit>
                ensemble.apply %RX_gate %qubit : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            }
        }

        affine.for %qubit_index = 0 to 9 {
            %qubit = tensor.extract %qubits[%qubit_index] : tensor<9x!ensemble.physical_qubit>
            %cbit = tensor.extract %bits[%qubit_index] : tensor<9x!ensemble.cbit>
            ensemble.measure %qubit, %cbit : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }


        return
    }

    func.func @main() {
        %beta_value = arith.constant 0.21 : f64
        %gamma_value = arith.constant 0.1 : f64
        %num_circuits = arith.constant 12288 : index
        

        %qubits = ensemble.program_alloc 9 : () -> tensor<9x!ensemble.physical_qubit>
        %bits = ensemble.alloc_cbits 9 : () -> tensor<9x!ensemble.cbit>
        affine.for %circuit_index = 0 to %num_circuits {
            func.call @wire_cutting_iteration(%circuit_index, %qubits, %bits, %beta_value, %gamma_value) : (index, tensor<9x!ensemble.physical_qubit>, tensor<9x!ensemble.cbit>, f64, f64) -> ()
        }
        return
    }
}