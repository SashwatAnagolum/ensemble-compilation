module {
    func.func private @circuit_iteration(%qubits: tensor<13 x !ensemble.physical_qubit>, %cbits: tensor<2 x !ensemble.cbit>, %circuit_index: index){
        %c0 = arith.constant 0: i1
        %c1 = arith.constant 1: i1
        // secret_key = [1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 1]
        %secret_key = tensor.from_elements %c1, %c0, %c1, %c0, %c1, %c1, %c1, %c0, %c1, %c0, %c0, %c1 :  tensor<12xi1>

        // # random variables sampled every time we sample a circuit
        // measured_qubits = int_uniform(low=0, high=12, size=(2,))
        %zero = arith.constant 0 : i32
        %twelve = arith.constant 12 : i32
        %two = arith.constant 2 : i32
        %measured_qubits = ensemble.int_uniform %zero, %twelve, [%two] : (i32, i32, i32) -> tensor<2 x i32>
        
        // gate declarations
        %x_gate = ensemble.gate "X" 1 : () -> (!ensemble.gate)
        %h_gate = ensemble.gate "H" 1 : () -> (!ensemble.gate)
        %cx_gate = ensemble.gate "CX" 2 : () -> (!ensemble.gate)

        // reset qubits;
        ensemble.quantum_program_iteration {
            ensemble.reset_tensor %qubits : (tensor<13 x !ensemble.physical_qubit>) -> ()

            // gate1q "X" qubits[12]
            %twelve_index = arith.constant 12: index
            %qubit12 = tensor.extract %qubits[%twelve_index] : tensor<13 x !ensemble.physical_qubit>
            ensemble.apply %x_gate %qubit12 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            // for (i = 0; i < 13; i++)
            %zero_index = arith.constant 0 : index
            %thirteen_index = arith.constant 13 : index
            %one_index = arith.constant 1 : index
            scf.for %i = %zero_index to %thirteen_index step %one_index {
                // qubits[i]
                %qubit_at_i = tensor.extract %qubits[%i]: tensor<13 x !ensemble.physical_qubit>
                // gate1q "H" qubits[i];
                ensemble.apply %h_gate %qubit_at_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            }

            // for (i = 0; i < 12; i++)
            %twelve_index_2 = arith.constant 12 : index
            scf.for %i = %zero_index to %twelve_index_2 step %one_index {
                // if (secret_key[i])
                %secret_key_at_i = tensor.extract %secret_key [%i]: tensor<12xi1>
                scf.if %secret_key_at_i  {
                    %qubit_at_i = tensor.extract %qubits[%i]: tensor<13 x !ensemble.physical_qubit>
                    // gate2q "CX" qubits[i], qubits[12];
                    ensemble.apply %cx_gate %qubit_at_i, %qubit12 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                } 
            }

            // for (i = 0; i < 13; i++)
            scf.for %i = %zero_index to %thirteen_index step %one_index {
                // qubits[i]
                %qubit_at_i = tensor.extract %qubits[%i]: tensor<13 x !ensemble.physical_qubit>
                // gate1q "H" qubits[i];
                ensemble.apply %h_gate %qubit_at_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            }

            // measured_qubits[0:1]
            %measured_qubit_at_0 = tensor.extract %measured_qubits[%zero_index] : tensor<2 x i32>
            %measured_qubit_at_1 = tensor.extract %measured_qubits[%one_index]: tensor<2 x i32>
            %measured_qubit_at_0_index = arith.index_cast %measured_qubit_at_0 : i32 to index
            %measured_qubit_at_1_index = arith.index_cast %measured_qubit_at_1 : i32 to index

            // bit[0], bit[1]
            %cbit_0 = tensor.extract %cbits[%zero_index]: tensor<2 x !ensemble.cbit>
            %cbit_1 = tensor.extract %cbits[%one_index]: tensor<2 x !ensemble.cbit>

            // qubits[measured_qubits[0]], qubits[measured_qubits[1]]
            %qubit_0 = tensor.extract %qubits[%measured_qubit_at_0_index]: tensor<13 x !ensemble.physical_qubit>
            %qubit_1 = tensor.extract %qubits[%measured_qubit_at_1_index]: tensor<13 x !ensemble.physical_qubit>

            // measure qubits[measured_qubits[0]], bits[0];
            // measure qubits[measured_qubits[1]], bits[1];
            ensemble.measure %qubit_0, %cbit_0 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
            ensemble.measure %qubit_1, %cbit_1 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()

            ensemble.transmit_results %cbits : (tensor<2 x !ensemble.cbit>) -> ()
        }

        return
    }

    func.func @main() {
        %zero_index = arith.constant 0 : index
        %one_index = arith.constant 1 : index
        %thousand_index = arith.constant 1000 : index

        %qubits = ensemble.program_alloc 13 : () -> tensor<13 x !ensemble.physical_qubit>
        %cbits = ensemble.alloc_cbits 2 : () -> tensor<2 x !ensemble.cbit>

        scf.for %i = %zero_index to %thousand_index step %one_index {
            func.call @circuit_iteration(%qubits, %cbits, %i) : (tensor<13 x !ensemble.physical_qubit>, tensor<2 x !ensemble.cbit>, index) -> ()
        }

        return
    }
}