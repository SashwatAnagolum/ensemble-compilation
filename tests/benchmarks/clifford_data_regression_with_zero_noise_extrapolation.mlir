module {    
    func.func private @iteration_body(%qubits: tensor<16x!ensemble.physical_qubit>, %cbits: tensor<16x!ensemble.cbit>, %num_loop_repetitions: index, %circuit_index: i32) {
        %zero = arith.constant 0 : i32
        %four = arith.constant 4 : i32
        %sixteen = arith.constant 16 : i32
        %eight = arith.constant 8 : i32
        %four_index = arith.constant 4 : index
        %two_index = arith.constant 2 : index
       
        %phase_gate_powers = ensemble.int_uniform %zero, %four, [%eight, %eight] : (i32, i32, i32, i32) -> tensor<4x8xi32>

        %h_gate = ensemble.gate "H" 1 : () -> (!ensemble.gate)
        %cx_gate = ensemble.gate "CX" 2 : () -> (!ensemble.gate)
        %h_gate_inverse = ensemble.gate "H" "inverse" 1 : () -> (!ensemble.gate)
        %cx_gate_inverse = ensemble.gate "CX" "inverse" 2 : () -> (!ensemble.gate)
        %s_gate = ensemble.gate "S" 1 : () -> (!ensemble.gate)
        %s_gate_inverse = ensemble.gate "S" "inverse" 1 : () -> (!ensemble.gate)
        %p_gate = ensemble.gate "P" 1 : () -> (!ensemble.gate)
        %p_gate_inverse = ensemble.gate "P" "inverse" 1 : () -> (!ensemble.gate)
        ensemble.quantum_program_iteration {

            %eight_index = arith.constant 8 : index
            %zero_index = arith.constant 0 : index
            %one_index = arith.constant 1 : index

            ensemble.reset_tensor %qubits : (tensor<16x!ensemble.physical_qubit>) -> ()

            scf.for %qubit_index = %zero_index to %eight_index step %one_index {
                %qubit_i = tensor.extract %qubits[%qubit_index] : tensor<16x!ensemble.physical_qubit>
                ensemble.apply %h_gate {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()

                scf.for %loop_repetition_index = %zero_index to %num_loop_repetitions step %one_index {
                    ensemble.apply %h_gate {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                    ensemble.apply %h_gate_inverse {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                }
            }

            %seven_index = arith.constant 7 : index

            scf.for %layer_index = %zero_index to %four_index step %one_index {
                %twice_layer_index = arith.muli %layer_index, %two_index : index
                scf.for %qubit_index = %zero_index to %seven_index step %one_index {
                    // CX gate stuff
                    %qubit_i = tensor.extract %qubits[%qubit_index] : tensor<16x!ensemble.physical_qubit>
                    %index_i_plus_one = arith.addi %qubit_index, %one_index : index
                    %qubit_i_plus_one = tensor.extract %qubits[%index_i_plus_one] : tensor<16x!ensemble.physical_qubit>
                    ensemble.apply %cx_gate {"cannot-merge"} %qubit_i, %qubit_i_plus_one : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

                    scf.for %loop_repetition_index = %zero_index to %num_loop_repetitions step %one_index {
                        ensemble.apply %cx_gate {"cannot-merge"} %qubit_i, %qubit_i_plus_one : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                        ensemble.apply %cx_gate_inverse {"cannot-merge"} %qubit_i, %qubit_i_plus_one : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                    }

                    // S gate stuff

                    %relevant_phase_gate_power = tensor.extract %phase_gate_powers[%twice_layer_index,%qubit_index] : tensor<4x8xi32>

                    %relevant_phase_gate_power_index = arith.index_cast %relevant_phase_gate_power : i32 to index

                    scf.for %loop_repetition_index = %zero_index to %relevant_phase_gate_power_index step %one_index {
                        ensemble.apply %s_gate {"cannot-merge"} %qubit_i_plus_one : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                        ensemble.apply %s_gate_inverse {"cannot-merge"} %qubit_i_plus_one : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                    }
                }

                // checkpoint 1

                scf.for %qubit_index = %zero_index to %eight_index step %one_index {
                    %qubit_i = tensor.extract %qubits[%qubit_index] : tensor<16x!ensemble.physical_qubit>
                    ensemble.apply %s_gate {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()

                    scf.for %loop_repetition_index = %zero_index to %num_loop_repetitions step %one_index {
                        ensemble.apply %s_gate {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                        ensemble.apply %s_gate_inverse {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                    }

                    ensemble.apply %p_gate {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()

                    scf.for %loop_repetition_index = %zero_index to %num_loop_repetitions step %one_index {
                        ensemble.apply %p_gate {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                        ensemble.apply %p_gate_inverse {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                    }

                    %twice_layer_index_plus_one = arith.addi %twice_layer_index, %one_index : index

                    %relevant_phase_gate_power = tensor.extract %phase_gate_powers[%twice_layer_index_plus_one, %qubit_index] : tensor<4x8xi32>

                    %relevant_phase_gate_power_index = arith.index_cast %relevant_phase_gate_power : i32 to index

                    scf.for %loop_repetition_index = %zero_index to %relevant_phase_gate_power_index step %one_index {
                        ensemble.apply %s_gate {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                        scf.for %loop_repetition_index_2 = %zero_index to %num_loop_repetitions step %one_index {
                            ensemble.apply %s_gate {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                            ensemble.apply %s_gate_inverse {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                        }
                    }

                    ensemble.apply %p_gate {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()

                    scf.for %loop_repetition_index = %zero_index to %num_loop_repetitions step %one_index {
                        ensemble.apply %p_gate {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                        ensemble.apply %p_gate_inverse {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                    }

                    ensemble.apply %s_gate {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()

                    scf.for %loop_repetition_index = %zero_index to %num_loop_repetitions step %one_index {
                        ensemble.apply %s_gate {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                        ensemble.apply %s_gate_inverse {"cannot-merge"} %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                    }
                }
            }

            scf.for %qubit_index = %zero_index to %eight_index step %one_index {
                %qubit_i = tensor.extract %qubits[%qubit_index] : tensor<16x!ensemble.physical_qubit>
                %cbit_i = tensor.extract %cbits[%qubit_index] : tensor<16x!ensemble.cbit>
                ensemble.measure %qubit_i, %cbit_i : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
            }

           


            
            ensemble.transmit_results %cbits : (tensor<16x!ensemble.cbit>) -> ()
        }

        return
        
    }

    func.func @main() {
        %qubits = ensemble.program_alloc 16 : () -> tensor<16x!ensemble.physical_qubit>
        %cbits = ensemble.alloc_cbits 16 : () -> tensor<16x!ensemble.cbit>
        %num_circuits = arith.constant 500 : i32
        %num_circuits_per_loop_repetition = arith.constant 100 : index

        %zero_index = arith.constant 0 : index
        %one_index = arith.constant 1 : index
        %two_index = arith.constant 2 : index
        %three_index = arith.constant 3 : index
        %four_index = arith.constant 4 : index

        %num_loop_repetitions = arith.constant 5 : index

        scf.for %num_loop_repetition_index = %zero_index to %num_loop_repetitions step %one_index {
            scf.for %num_circuits_per_loop_repetition_index = %zero_index to %num_circuits_per_loop_repetition step %one_index {
                %circuit_index = arith.index_cast %num_circuits_per_loop_repetition_index : index to i32
                func.call @iteration_body(%qubits, %cbits, %num_loop_repetition_index, %circuit_index) : (tensor<16x!ensemble.physical_qubit>, tensor<16x!ensemble.cbit>, index, i32) -> ()
            }
        }

        return
        
        
    }
}
