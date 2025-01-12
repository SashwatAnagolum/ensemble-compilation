// RUN: tutorial-opt %s

module {
    // circuit description - 1D Ising QAOA on 16 qubits
    // problem hamiltonian - adjacent ZZ terms
    // mixer hamiltonian - single-qubit Pauli X rotations

    func.func private @iteration_body(%qubits: tensor<16x!ensemble.physical_qubit>, %cbits: tensor<16x!ensemble.cbit>, %circuit_index: i32) {
        // %phase_gate_powers = ensemble.int_uniform 0, 4, [4,16] : () -> tensor<4 x 16 xi32>
        %zero = arith.constant 0 : i32  
        %four = arith.constant 4 : i32
        %sixteen = arith.constant 16 : i32
        %zero_index = arith.constant 0 : index

        %phase_gate_powers = ensemble.int_uniform %zero, %four, [%four, %sixteen] : (i32, i32, i32, i32) -> tensor<4x16xi32> 
        %h_gate = ensemble.gate "H" 1 : () -> (!ensemble.gate)
        %cx_gate = ensemble.gate "CX" 2 : () -> (!ensemble.gate)

        // reset qubits;
        // %0 = ensemble.Nq_reset %qubits : (tensor<16 x !ensemble.qubit>) -> (tensor<16 x !ensemble.qubit>)
        %sixteen_index = arith.constant 16 : index
        %fifteen_index = arith.constant 15 : index
        %one = arith.constant 1 : index
        %s_gate = ensemble.gate "S" 1 : () -> (!ensemble.gate)
        %p_gate = ensemble.gate "P" 1 : () -> (!ensemble.gate)

        ensemble.quantum_program_iteration {
            ensemble.reset_tensor %qubits : (tensor<16x!ensemble.physical_qubit>) -> ()

            scf.for %i = %zero_index to %sixteen_index step %one {
                // gate1q "H" qubits[i];
                %1 = tensor.extract %qubits[%i] : tensor<16x!ensemble.physical_qubit>
                ensemble.apply %h_gate %1 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            }
            
            scf.for %i = %zero_index to %fifteen_index step %one {
                // %qubits[i]
                %qubit_at_i = tensor.extract %qubits[%i] : tensor<16x!ensemble.physical_qubit> // qubit[i]
                %iplus1 = arith.addi %i, %one : index  // i + 1
                // %qubits[i+1]
                %qubit_at_i_plus_1 = tensor.extract %qubits[%iplus1] : tensor<16x!ensemble.physical_qubit> // qubit[i+1]
            
                // gate2q "CX" qubits[i], qubits[i + 1];
                ensemble.apply %cx_gate %qubit_at_i, %qubit_at_i_plus_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

                %phase_gate_powers_0_i = tensor.extract %phase_gate_powers[%zero_index, %i] : tensor<4x16xi32>
                %phase_gate_powers_0_i_index = arith.index_cast %phase_gate_powers_0_i : i32 to index
                
                // for (j = 0; j < phase_gate_powers[0][i]; j++)
                // need to use an scf for because phase_gate_powers is not known at compile time
                scf.for %j = %zero_index to %phase_gate_powers_0_i_index step %one { 
                    // gate1q "S" qubits[i + 1];
                    ensemble.apply %s_gate %qubit_at_i_plus_1 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                }
                
                // gate2q "CX" qubits[i], qubits[i + 1];
                ensemble.apply %cx_gate %qubit_at_i, %qubit_at_i_plus_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }

            scf.for %i = %zero_index to %sixteen_index step %one {
                // %qubits[i]
                %qubit_at_i = tensor.extract %qubits[%i] : tensor<16x!ensemble.physical_qubit> // qubit[i]
                
                //gate1q "S" qubits[i];
                //gate1q "P" qubits[i];
                ensemble.apply %s_gate %qubit_at_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                ensemble.apply %p_gate %qubit_at_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()

                // phase_gate_powers[1][i]
                %phase_gate_powers_1_i = tensor.extract %phase_gate_powers[%one, %i] : tensor<4x16xi32>
                %phase_gate_powers_1_i_index = arith.index_cast %phase_gate_powers_1_i : i32 to index
                
                // for (j = 0; j < phase_gate_powers[1][i]; j++)
                // need to use an scf for because phase_gate_powers is not known at compile time
                scf.for %j = %zero_index to %phase_gate_powers_1_i_index step %one { 
                    // gate1q "S" qubits[i];
                    ensemble.apply %s_gate %qubit_at_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                }

                //gate1q "P" qubits[i];
                //gate1q "S" qubits[i];
                ensemble.apply %p_gate %qubit_at_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                ensemble.apply %s_gate %qubit_at_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            }

            scf.for %i = %zero_index to %fifteen_index step %one {
                // %qubits[i]
                %qubit_at_i = tensor.extract %qubits[%i] : tensor<16x!ensemble.physical_qubit> // qubit[i]
                %iplus1 = arith.addi %i, %one : index  // i + 1
                // %qubits[i+1]
                %qubit_at_i_plus_1 = tensor.extract %qubits[%iplus1] : tensor<16x!ensemble.physical_qubit> // qubit[i+1]
            
                // gate2q "CX" qubits[i], qubits[i + 1];
                ensemble.apply %cx_gate %qubit_at_i, %qubit_at_i_plus_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

                %two = arith.constant 2 : index
                %phase_gate_powers_2_i = tensor.extract %phase_gate_powers[%two, %i] : tensor<4x16xi32>
                %phase_gate_powers_2_i_index = arith.index_cast %phase_gate_powers_2_i : i32 to index
                
                // for (j = 0; j < phase_gate_powers[0][i]; j++)
                // need to use an scf for because phase_gate_powers is not known at compile time
                scf.for %j = %zero_index to %phase_gate_powers_2_i_index step %one { 
                    // gate1q "S" qubits[i + 1];
                    ensemble.apply %s_gate %qubit_at_i_plus_1 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                }
                
                // gate2q "CX" qubits[i], qubits[i + 1];
                ensemble.apply %cx_gate %qubit_at_i, %qubit_at_i_plus_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }

            scf.for %i = %zero_index to %sixteen_index step %one {
                // %qubits[i]
                %qubit_at_i = tensor.extract %qubits[%i] : tensor<16x!ensemble.physical_qubit> // qubit[i]
                
                //gate1q "S" qubits[i];
                //gate1q "P" qubits[i];
                ensemble.apply %s_gate %qubit_at_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                ensemble.apply %p_gate %qubit_at_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()

                // phase_gate_powers[1][i]
                %three = arith.constant 3: index
                %phase_gate_powers_3_i = tensor.extract %phase_gate_powers[%three, %i] : tensor<4x16xi32>
                %phase_gate_powers_3_i_index = arith.index_cast %phase_gate_powers_3_i : i32 to index
                
                // for (j = 0; j < phase_gate_powers[1][i]; j++)
                // need to use an scf for because phase_gate_powers is not known at compile time
                scf.for %j = %zero_index to %phase_gate_powers_3_i_index step %one { 
                    // gate1q "S" qubits[i];
                    ensemble.apply %s_gate %qubit_at_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                }

                //gate1q "P" qubits[i];
                //gate1q "S" qubits[i];
                ensemble.apply %p_gate %qubit_at_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                ensemble.apply %s_gate %qubit_at_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                
                // cbit[i]
                %cbit_at_i = tensor.extract %cbits[%i] : tensor<16x!ensemble.cbit> 
                //measure qubits[i], bits[i];
                ensemble.measure %qubit_at_i, %cbit_at_i : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
            }
            ensemble.transmit_results %cbits : (tensor<16x!ensemble.cbit>) -> ()
        }

        return 
    }

    func.func @main() {
        // Allocate qubits and cbits for the circuit
        %qubits = ensemble.program_alloc 16 : () -> tensor<16x!ensemble.physical_qubit>
        %cbits = ensemble.alloc_cbits 16 : () -> tensor<16x!ensemble.cbit>
        
        // Setup loop counters
        %zero_index = arith.constant 0 : index
        %one_index = arith.constant 1 : index
        %num_iterations = arith.constant 1000 : index

        // Run 1000 iterations of the circuit
        scf.for %i = %zero_index to %num_iterations step %one_index {
            %circuit_index = arith.index_cast %i : index to i32
            func.call @iteration_body(%qubits, %cbits, %circuit_index) : (tensor<16x!ensemble.physical_qubit>, tensor<16x!ensemble.cbit>, i32) -> ()
        }
        return
    }
}