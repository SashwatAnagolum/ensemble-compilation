module {
    func.func private @iteration_body(%qubits: tensor<4 x !ensemble.physical_qubit>, %bits: tensor<4 x !ensemble.cbit>, %circuit_index: i32) {
        %I_gate = ensemble.gate "I" 1 : () -> (!ensemble.gate)
        %X_gate = ensemble.gate "X" 1 : () -> (!ensemble.gate)
        %Y_gate = ensemble.gate "Y" 1 : () -> (!ensemble.gate)
        %Z_gate = ensemble.gate "Z" 1 : () -> (!ensemble.gate)
        %H_gate = ensemble.gate "H" 1 : () -> (!ensemble.gate)
        %CX_gate = ensemble.gate "CX" 2 : () -> (!ensemble.gate)

        %pauli_left_slices = ensemble.gate_distribution %I_gate, %I_gate, %I_gate, %X_gate, %I_gate, %Y_gate, %I_gate, %Z_gate, %X_gate, %I_gate, %X_gate, %X_gate, %X_gate, %Y_gate, %X_gate, %Z_gate, %Y_gate, %I_gate, %Y_gate, %X_gate, %Y_gate, %Y_gate, %Y_gate, %Z_gate, %Z_gate, %I_gate, %Z_gate, %X_gate, %Z_gate, %Y_gate, %Z_gate, %Z_gate : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution

        %pauli_right_slices = ensemble.gate_distribution %I_gate, %I_gate, %I_gate, %X_gate, %Z_gate, %Y_gate, %Z_gate, %Z_gate, %X_gate, %X_gate, %X_gate, %I_gate, %Y_gate, %Z_gate, %Y_gate, %Y_gate, %Y_gate, %X_gate, %Y_gate, %I_gate, %X_gate, %Z_gate, %X_gate, %Y_gate, %Z_gate, %I_gate, %Z_gate, %X_gate, %I_gate, %Y_gate, %I_gate, %Z_gate : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution

        // indexing pauli_slices[i][j] = pauli_slices[i*2 + j]

        %zero_i32 = arith.constant 0 : i32
        %sixteen_i32 = arith.constant 16 : i32
        %one_i32 = arith.constant 1 : i32
        %eighteen_i32 = arith.constant 18 : i32
        %pauli_randomization_indices = ensemble.int_uniform %zero_i32, %sixteen_i32, [%eighteen_i32] : (i32, i32, i32) -> (tensor<18xi32>)
    
        ensemble.quantum_program_iteration {
            ensemble.reset_tensor %qubits: (tensor<4 x !ensemble.physical_qubit>) -> ()

            // cycle 1
            %zero_index = arith.constant 0 : index
            %four_index = arith.constant 4 : index
            %one_index = arith.constant 1 : index
            scf.for %i = %zero_index to %four_index step %one_index {
                %qubit_i = tensor.extract %qubits[%i] : tensor<4 x !ensemble.physical_qubit>
                ensemble.apply %H_gate %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            }

            // cycle 2
            %pi_f64 = arith.constant 3.141592653589793 : f64
            %pi_over_4_f64 = arith.constant 0.7853981633974483 : f64
            %pi_over_8_f64 = arith.constant 0.39269908169872414 : f64
            %pi_over_16_f64 = arith.constant 0.19634954084936207 : f64

            %two_index = arith.constant 2 : index
            %three_index = arith.constant 3 : index
            %qubit_1 = tensor.extract %qubits[%one_index] : tensor<4 x !ensemble.physical_qubit>
            %qubit_2 = tensor.extract %qubits[%two_index] : tensor<4 x !ensemble.physical_qubit>
            %qubit_3 = tensor.extract %qubits[%three_index] : tensor<4 x !ensemble.physical_qubit>

            %RZ_gate_pi_over_4 = ensemble.gate "RZ" 1 (%pi_over_4_f64): (f64) -> (!ensemble.gate)
            %RZ_gate_pi_over_8 = ensemble.gate "RZ" 1 (%pi_over_8_f64) : (f64) -> (!ensemble.gate)
            %RZ_gate_pi_over_16 = ensemble.gate "RZ" 1 (%pi_over_16_f64) : (f64) -> (!ensemble.gate)

            ensemble.apply %RZ_gate_pi_over_4 %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %RZ_gate_pi_over_8 %qubit_2 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %RZ_gate_pi_over_16 %qubit_3 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            // cycle 3
            %qubit_0 = tensor.extract %qubits[%zero_index] : tensor<4 x !ensemble.physical_qubit>
            %pauli_randomization_index_0 = tensor.extract %pauli_randomization_indices[%zero_index] : tensor<18xi32>

            // pauli_rand_index_0 times 2 plus 0
            %two_i32 = arith.constant 2 : i32
            %left_slice_index_0 = arith.muli %pauli_randomization_index_0, %two_i32 : i32
            %left_slice_index_1 = arith.addi %left_slice_index_0, %one_i32 : i32

            ensemble.apply_distribution %pauli_left_slices[%left_slice_index_0] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%left_slice_index_1] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply %CX_gate %qubit_1, %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%left_slice_index_0] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%left_slice_index_1] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            // cycle 4
            %neg_pi_over_4_f64 = arith.constant -0.7853981633974483 : f64
            %RZ_gate_neg_pi_over_4 = ensemble.gate "RZ" 1 (%neg_pi_over_4_f64) : (f64) -> (!ensemble.gate)
            ensemble.apply %RZ_gate_neg_pi_over_4 %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            // cycle 5
            %pauli_randomization_index_1 = tensor.extract %pauli_randomization_indices[%one_index] : tensor<18xi32>
            %cycle_5_pri_10 = arith.muli %pauli_randomization_index_1, %two_i32: i32
            %cycle_5_pri_11 = arith.addi %cycle_5_pri_10, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_5_pri_10] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_5_pri_11] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply %CX_gate %qubit_1, %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_5_pri_10] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_5_pri_11] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            // cycle 6
            ensemble.apply %RZ_gate_pi_over_4 %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            // cycle 7 
            %pauli_randomization_index_2 = tensor.extract %pauli_randomization_indices[%two_index] : tensor<18xi32>
            %cycle_7_pri_20 = arith.muli %pauli_randomization_index_2, %two_i32: i32
            %cycle_7_pri_21 = arith.addi %cycle_7_pri_20, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_7_pri_20] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_7_pri_21] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply %CX_gate %qubit_2, %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_7_pri_20] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_7_pri_21] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            // cycle 8
            %neg_pi_over_8_f64 = arith.constant -0.39269908169872414 : f64
            %RZ_gate_neg_pi_over_8 = ensemble.gate "RZ" 1 (%neg_pi_over_8_f64) : (f64) -> (!ensemble.gate)
            ensemble.apply %RZ_gate_neg_pi_over_8 %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            // cycle 9
            %pauli_randomization_index_3 = tensor.extract %pauli_randomization_indices[%three_index] : tensor<18xi32>
            %cycle_9_pri_30 = arith.muli %pauli_randomization_index_3, %two_i32: i32
            %cycle_9_pri_31 = arith.addi %cycle_9_pri_30, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_9_pri_30] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_9_pri_31] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply %CX_gate %qubit_2, %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_9_pri_30] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_9_pri_31] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            // cycle 10
            ensemble.apply %RZ_gate_pi_over_8 %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %RZ_gate_pi_over_4 %qubit_2 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            // cycle 11
            %pauli_randomization_index_4 = tensor.extract %pauli_randomization_indices[%four_index] : tensor<18xi32>
            %cycle_11_pri_40 = arith.muli %pauli_randomization_index_4, %two_i32: i32
            %cycle_11_pri_41 = arith.addi %cycle_11_pri_40, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_11_pri_40] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_11_pri_41] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            %five_index = arith.constant 5 : index

            %pauli_randomization_index_5 = tensor.extract %pauli_randomization_indices[%five_index] : tensor<18xi32>
            %cycle_11_pri_50 = arith.muli %pauli_randomization_index_5, %two_i32: i32
            %cycle_11_pri_51 = arith.addi %cycle_11_pri_50, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_11_pri_50] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_11_pri_51] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            ensemble.apply %CX_gate %qubit_3, %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply %CX_gate %qubit_2, %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_11_pri_40] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_11_pri_41] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_11_pri_50] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_11_pri_51] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            // cycle 12
            %neg_pi_over_16_f64 = arith.constant -0.19634954084936207 : f64
            %RZ_gate_neg_pi_over_16 = ensemble.gate "RZ" 1 (%neg_pi_over_16_f64) : (f64) -> (!ensemble.gate)
            ensemble.apply %RZ_gate_neg_pi_over_16 %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %RZ_gate_neg_pi_over_4 %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            // cycle 13
            %six_index = arith.constant 6 : index
            %pauli_randomization_index_6 = tensor.extract %pauli_randomization_indices[%six_index] : tensor<18xi32>
            %cycle_13_pri_60 = arith.muli %pauli_randomization_index_6, %two_i32: i32
            %cycle_13_pri_61 = arith.addi %cycle_13_pri_60, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_13_pri_60] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_13_pri_61] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            %seven_index = arith.constant 7 : index
            %pauli_randomization_index_7 = tensor.extract %pauli_randomization_indices[%seven_index] : tensor<18xi32>
            %cycle_13_pri_70 = arith.muli %pauli_randomization_index_7, %two_i32: i32
            %cycle_13_pri_71 = arith.addi %cycle_13_pri_70, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_13_pri_70] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_13_pri_71] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            ensemble.apply %CX_gate %qubit_3, %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply %CX_gate %qubit_2, %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_13_pri_60] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_13_pri_61] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_13_pri_70] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_13_pri_71] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            // cycle 14
            ensemble.apply %RZ_gate_pi_over_16 %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %RZ_gate_pi_over_4 %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %RZ_gate_pi_over_8 %qubit_3 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            // cycle 15
            %eight_index = arith.constant 8 : index
            %pauli_randomization_index_8 = tensor.extract %pauli_randomization_indices[%eight_index] : tensor<18xi32>
            %cycle_15_pri_80 = arith.muli %pauli_randomization_index_8, %two_i32: i32
            %cycle_15_pri_81 = arith.addi %cycle_15_pri_80, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_15_pri_80] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_15_pri_81] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            ensemble.apply %CX_gate %qubit_3, %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_15_pri_80] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_15_pri_81] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            // cycle 16
            ensemble.apply %RZ_gate_neg_pi_over_8 %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            // cycle 17
            %nine_index = arith.constant 9 : index
            %pauli_randomization_index_9 = tensor.extract %pauli_randomization_indices[%nine_index] : tensor<18xi32>
            %cycle_17_pri_90 = arith.muli %pauli_randomization_index_9, %two_i32: i32
            %cycle_17_pri_91 = arith.addi %cycle_17_pri_90, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_17_pri_90] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_17_pri_91] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply %CX_gate %qubit_3, %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_17_pri_90] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_17_pri_91] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            // cycle 18
            ensemble.apply %RZ_gate_pi_over_8 %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %RZ_gate_pi_over_4 %qubit_3 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            // cycle 19
            %ten_index = arith.constant 10 : index
            %pauli_randomization_index_10 = tensor.extract %pauli_randomization_indices[%ten_index] : tensor<18xi32>
            %cycle_19_pri_100 = arith.muli %pauli_randomization_index_10, %two_i32: i32
            %cycle_19_pri_101 = arith.addi %cycle_19_pri_100, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_19_pri_100] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_19_pri_101] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            ensemble.apply %CX_gate %qubit_3, %qubit_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_19_pri_100] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_19_pri_101] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            // cycle 20
            ensemble.apply %RZ_gate_neg_pi_over_4 %qubit_2 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            // cycle 21
            %eleven_index = arith.constant 11 : index
            %pauli_randomization_index_11 = tensor.extract %pauli_randomization_indices[%eleven_index] : tensor<18xi32>
            %cycle_21_pri_110 = arith.muli %pauli_randomization_index_11, %two_i32: i32
            %cycle_21_pri_111 = arith.addi %cycle_21_pri_110, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_21_pri_110] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_21_pri_111] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply %CX_gate %qubit_3, %qubit_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_21_pri_110] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_21_pri_111] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            // cycle 22
            ensemble.apply %RZ_gate_pi_over_4 %qubit_2 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            // cycle 23
            %twelve_index = arith.constant 12 : index
            %pauli_randomization_index_12 = tensor.extract %pauli_randomization_indices[%twelve_index] : tensor<18xi32>
            %cycle_23_pri_120 = arith.muli %pauli_randomization_index_12, %two_i32: i32
            %cycle_23_pri_121 = arith.addi %cycle_23_pri_120, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_23_pri_120] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_23_pri_121] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            %thirteen_index = arith.constant 13 : index
            %pauli_randomization_index_13 = tensor.extract %pauli_randomization_indices[%thirteen_index] : tensor<18xi32>
            %cycle_23_pri_130 = arith.muli %pauli_randomization_index_13, %two_i32: i32
            %cycle_23_pri_131 = arith.addi %cycle_23_pri_130, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_23_pri_130] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_23_pri_131] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            ensemble.apply %CX_gate %qubit_3, %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply %CX_gate %qubit_2, %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_23_pri_120] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_23_pri_121] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_23_pri_130] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_23_pri_131] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            // cycle 24
            %fourteen_index = arith.constant 14 : index
            %pauli_randomization_index_14 = tensor.extract %pauli_randomization_indices[%fourteen_index] : tensor<18xi32>
            %cycle_24_pri_140 = arith.muli %pauli_randomization_index_14, %two_i32: i32
            %cycle_24_pri_141 = arith.addi %cycle_24_pri_140, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_24_pri_140] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_24_pri_141] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            %fifteen_index = arith.constant 15 : index
            %pauli_randomization_index_15 = tensor.extract %pauli_randomization_indices[%fifteen_index] : tensor<18xi32>
            %cycle_24_pri_150 = arith.muli %pauli_randomization_index_15, %two_i32: i32
            %cycle_24_pri_151 = arith.addi %cycle_24_pri_150, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_24_pri_150] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_24_pri_151] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            ensemble.apply %CX_gate %qubit_0, %qubit_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply %CX_gate %qubit_1, %qubit_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_24_pri_140] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_24_pri_141] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_24_pri_150] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_24_pri_151] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            // cycle 25
            %sixteen_index = arith.constant 16 : index
            %pauli_randomization_index_16 = tensor.extract %pauli_randomization_indices[%sixteen_index] : tensor<18xi32>
            %cycle_25_pri_160 = arith.muli %pauli_randomization_index_16, %two_i32: i32
            %cycle_25_pri_161 = arith.addi %cycle_25_pri_160, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_25_pri_160] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_25_pri_161] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> () 

            %seventeen_index = arith.constant 17 : index
            %pauli_randomization_index_17 = tensor.extract %pauli_randomization_indices[%seventeen_index] : tensor<18xi32>
            %cycle_25_pri_170 = arith.muli %pauli_randomization_index_17, %two_i32: i32
            %cycle_25_pri_171 = arith.addi %cycle_25_pri_170, %one_i32: i32

            ensemble.apply_distribution %pauli_left_slices[%cycle_25_pri_170] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_left_slices[%cycle_25_pri_171] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            ensemble.apply %CX_gate %qubit_3, %qubit_0 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply %CX_gate %qubit_2, %qubit_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_25_pri_160] %qubit_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_25_pri_161] %qubit_0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            ensemble.apply_distribution %pauli_right_slices[%cycle_25_pri_170] %qubit_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %pauli_right_slices[%cycle_25_pri_171] %qubit_1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

            ensemble.transmit_results %bits : (tensor<4 x !ensemble.cbit>) -> ()
        }
        return
    }

    func.func @main() {
        %qubits = ensemble.program_alloc 4 : () -> (tensor<4 x !ensemble.physical_qubit>)
        %bits = ensemble.alloc_cbits 4 : () -> (tensor<4 x !ensemble.cbit>)
        %zero_index = arith.constant 0 : index
        %one_index = arith.constant 1 : index
        %thousand_index = arith.constant 1000 : index
        scf.for %circuit_index = %zero_index to %thousand_index step %one_index {
            %circuit_index_i32 = arith.index_cast %circuit_index : index to i32
            func.call @iteration_body(%qubits, %bits, %circuit_index_i32) : (tensor<4 x !ensemble.physical_qubit>, tensor<4 x !ensemble.cbit>, i32) -> ()
        }
        return
    }
}