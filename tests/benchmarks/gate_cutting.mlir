
module {    
    func.func @gate_cutting_iteration(%circuit_index: index, %qubits: tensor<4x!ensemble.physical_qubit>, %bits: tensor<6x!ensemble.cbit>, %params: tensor<5x2x4xf64>, %should_perform_qpd_meas_on_control: tensor<6xi1>, %should_perform_qpd_meas_on_target: tensor<6xi1>) {

        %H_gate = ensemble.gate "H" 1 : () -> (!ensemble.gate)
        %Sdag_gate = ensemble.gate "Sdag" 1 : () -> (!ensemble.gate)
        %S_gate = ensemble.gate "S" 1 : () -> (!ensemble.gate)
        %I_gate = ensemble.gate "I" 1 : () -> (!ensemble.gate)
        %Z_gate = ensemble.gate "Z" 1 : () -> (!ensemble.gate)

        %control_gate_sequences = ensemble.gate_distribution %Sdag_gate, %S_gate, %Sdag_gate, %Sdag_gate, %I_gate, %Z_gate : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution

        %target_gate_sequences = ensemble.gate_distribution %H_gate, %Sdag_gate, %H_gate, %H_gate, %S_gate, %H_gate, %I_gate, %I_gate, %I_gate, %H_gate, %Z_gate, %H_gate, %H_gate, %Sdag_gate, %H_gate, %H_gate, %Sdag_gate, %H_gate : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        // target sequence[i][j] is target_gate_sequences[i*3+j]
        %one_i32 = arith.constant 1 : i32
        %two_i32 = arith.constant 2 : i32
        %circuit_index_i32 = arith.index_cast %circuit_index : index to i32
        %use_x_basis_measurements_i32 = arith.remsi %circuit_index_i32, %two_i32 : i32
        %use_x_basis_measurements =  arith.cmpi eq, %use_x_basis_measurements_i32, %one_i32: i32

        %two_hundred_sixteen_i32 = arith.constant 216 : i32
        %thirty_six_i32 = arith.constant 36 : i32
        %six_i32 = arith.constant 6 : i32


        %logical_circuit_index = arith.divsi %circuit_index_i32, %two_i32 : i32
        %logical_divided_216 = arith.divsi %logical_circuit_index, %two_hundred_sixteen_i32 : i32
        %logical_divided_36 = arith.divsi %logical_circuit_index, %thirty_six_i32 : i32
        %logical_divided_6 = arith.divsi %logical_circuit_index, %six_i32 : i32

        %zeroth = arith.remsi %logical_divided_216, %six_i32 : i32
        %first = arith.remsi %logical_divided_36, %six_i32 : i32
        %second = arith.remsi %logical_divided_6, %six_i32 : i32
        %third = arith.remsi %logical_circuit_index, %six_i32 : i32

        %cut_sequence_indices = tensor.from_elements %zeroth, %first, %second, %third : tensor<4xi32>

        ensemble.reset_tensor %qubits : (tensor<4x!ensemble.physical_qubit>) -> ()

        %CX_gate = ensemble.gate "CX" 2 : () -> (!ensemble.gate)
        %zero_index = arith.constant 0 : index
        %one_index = arith.constant 1 : index
        %three_index = arith.constant 3 : index
        %four_index = arith.constant 4 : index

        affine.for %layer_index = 0 to 4 {
            affine.for %i = 0 to 4 {
               
                %first_param = tensor.extract %params[%layer_index, %zero_index, %i] : tensor<5x2x4xf64>
                %RY_gate = ensemble.gate "RY" 1 (%first_param) : (f64) -> (!ensemble.gate)
                %second_param = tensor.extract %params[%layer_index, %one_index, %i] : tensor<5x2x4xf64>
                %RZ_gate = ensemble.gate "RZ" 1 (%second_param) : (f64) -> (!ensemble.gate)

                %qubit_i = tensor.extract %qubits[%i] : tensor<4x!ensemble.physical_qubit>
                ensemble.apply %RY_gate %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                ensemble.apply %RZ_gate %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            }

            affine.for %control = 0 to 3 {
                %qubit_control = tensor.extract %qubits[%control] : tensor<4x!ensemble.physical_qubit>
                %control_plus_one = arith.addi %control, %one_index : index
                %qubit_control_plus_one = tensor.extract %qubits[%control_plus_one] : tensor<4x!ensemble.physical_qubit>
                ensemble.apply %CX_gate %qubit_control, %qubit_control_plus_one : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }

            // use 1q gates instead of a CNOT on qubits[3], qubits[0]
            %cut_sequence_index_i32 = tensor.extract %cut_sequence_indices[%layer_index] : tensor<4xi32>
            %cut_sequence_index = arith.index_cast %cut_sequence_index_i32 : i32 to index
            
            %qubit_3 = tensor.extract %qubits[%three_index] : tensor<4x!ensemble.physical_qubit>
            ensemble.apply_distribution %control_gate_sequences[%cut_sequence_index] %qubit_3 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()

            %iteration_should_perform_qpd_meas_on_control = tensor.extract %should_perform_qpd_meas_on_control[%cut_sequence_index] : tensor<6xi1>
            scf.if %iteration_should_perform_qpd_meas_on_control {
                
                %cbit_4 = tensor.extract %bits[%four_index] : tensor<6x!ensemble.cbit>
                ensemble.measure %qubit_3, %cbit_4 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
            }
            %two_index = arith.constant 2 : index
            %five_index = arith.constant 5 : index

            // %target_gate_sequence_index_0_i32 = tensor.extract %cut_sequence_indices[%layer_index, %zero_index] : tensor<4xi32>
            // %target_gate_sequence_index_1_i32 = tensor.extract %cut_sequence_indices[%layer_index, %one_index] : tensor<4xi32>
            // %target_gate_sequence_index_2_i32 = tensor.extract %cut_sequence_indices[%layer_index, %two_index] : tensor<4xi32>

            // %target_gate_sequence_index_0 = arith.index_cast %target_gate_sequence_index_0_i32 : i32 to index
            // %target_gate_sequence_index_1 = arith.index_cast %target_gate_sequence_index_1_i32 : i32 to index
            // %target_gate_sequence_index_2 = arith.index_cast %target_gate_sequence_index_2_i32 : i32 to index

            // %qubit_0 = tensor.extract %qubits[%zero_index] : tensor<4x!ensemble.physical_qubit>

            // ensemble.apply_distribution %target_gate_sequences[%target_gate_sequence_index_0] %qubit_0 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
            // ensemble.apply_distribution %target_gate_sequences[%target_gate_sequence_index_1] %qubit_0 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()

            // %iteration_should_perform_qpd_meas_on_target = tensor.extract %should_perform_qpd_meas_on_target[%cut_sequence_index] : tensor<6xi1>
            // scf.if %iteration_should_perform_qpd_meas_on_target {
            //     %cbit_5 = tensor.extract %bits[%five_index] : tensor<6x!ensemble.cbit>
            //     ensemble.measure %qubit_0, %cbit_5 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
            // }

            // ensemble.apply_distribution %target_gate_sequences[%target_gate_sequence_index_2] %qubit_0 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
            // continue from here, line 194 is still wrong
        }

        affine.for %i = 0 to 4 {
            %rotation_param = tensor.extract %params[%four_index, %zero_index, %i] : tensor<5x2x4xf64>
            %qubit_i = tensor.extract %qubits[%i] : tensor<4x!ensemble.physical_qubit>
            %RY_gate_end = ensemble.gate "RY" 1 (%rotation_param) : (f64) -> (!ensemble.gate)
            %RZ_gate_end = ensemble.gate "RZ" 1 (%rotation_param) : (f64) -> (!ensemble.gate)
            ensemble.apply %RY_gate_end %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %RZ_gate_end %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        }

        scf.if %use_x_basis_measurements {
            affine.for %qubit_index = 0 to 4 {
                %qubit_i = tensor.extract %qubits[%qubit_index] : tensor<4x!ensemble.physical_qubit>
                ensemble.apply %H_gate %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            }
        }

        affine.for %i = 0 to 4 {
            %qubit_i = tensor.extract %qubits[%i] : tensor<4x!ensemble.physical_qubit>
            %cbit_i = tensor.extract %bits[%i] : tensor<6x!ensemble.cbit>
            ensemble.measure %qubit_i, %cbit_i : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }

        

        return

    }
    func.func @main() {
        %zero_point_one = arith.constant 0.1 : f64
        // create a tensor<5x2x4xf64> of shape 5x2x4 of type f64 by doing from_elements
        %params = tensor.from_elements %zero_point_one, %zero_point_one, %zero_point_one, %zero_point_one, %zero_point_one, %zero_point_one, %zero_point_one, %zero_point_one,%zero_point_one, %zero_point_one, %zero_point_one, %zero_point_one,%zero_point_one, %zero_point_one, %zero_point_one, %zero_point_one,%zero_point_one, %zero_point_one, %zero_point_one, %zero_point_one,%zero_point_one, %zero_point_one, %zero_point_one, %zero_point_one,%zero_point_one, %zero_point_one, %zero_point_one, %zero_point_one,%zero_point_one, %zero_point_one, %zero_point_one, %zero_point_one,%zero_point_one, %zero_point_one, %zero_point_one, %zero_point_one,%zero_point_one, %zero_point_one, %zero_point_one, %zero_point_one : tensor<5x2x4xf64>

        %true = arith.constant 1 : i1
        %false = arith.constant 0 : i1

        %should_perform_qpd_meas_on_control = tensor.from_elements %false, %false, %true, %true, %false, %false : tensor<6xi1>
        %should_perform_qpd_meas_on_target = tensor.from_elements %false, %false, %false, %false, %true, %true : tensor<6xi1>

        %num_qubits = arith.constant 4 : index
        %qubits = ensemble.program_alloc 4 : () -> tensor<4x!ensemble.physical_qubit>
        %num_bits = arith.constant 6 : index
        %bits = ensemble.alloc_cbits 6 : () -> tensor<6x!ensemble.cbit>
        %num_circuits = arith.constant 2592 : index
        affine.for %circuit_index = 0 to %num_circuits {
            func.call @gate_cutting_iteration(%circuit_index, %qubits, %bits, %params, %should_perform_qpd_meas_on_control, %should_perform_qpd_meas_on_target) : (index, tensor<4x!ensemble.physical_qubit>, tensor<6x!ensemble.cbit>, tensor<5x2x4xf64>, tensor<6xi1>, tensor<6xi1>) -> ()
        }
        return
    }
}