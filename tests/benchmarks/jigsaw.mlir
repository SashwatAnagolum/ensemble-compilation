module {
    func.func @main(%qubits: tensor<13 x !ensemble.qubit>, %cbits: tensor<2 x !ensemble.cbit>, %circuit_index: i32){
        %c0 = arith.constant 0: i1
        %c1 = arith.constant 1: i1
        // secret_key = [1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 1]
        %secret_key = tensor.from_elements %c1, %c0, %c1, %c0, %c1, %c1, %c1, %c0, %c1, %c0, %c0, %c1 :  tensor<12xi1>

        // # random variables sampled every time we sample a circuit
        // measured_qubits = int_uniform(low=0, high=12, size=(2,))
        %measured_qubits = ensemble.int_uniform 0, 12, [2]: () -> tensor<2 x i32>
        // reset qubits;
        %0 = ensemble.Nq_reset %qubits: (tensor<13 x !ensemble.qubit>) -> (tensor<13 x !ensemble.qubit>)

        // gate1q "X" qubits[12]
        %twelve = arith.constant 12: index
        %qubit12 = tensor.extract %0[%twelve] : tensor<13 x !ensemble.qubit>
        %1 = ensemble.gate1q "X" %qubit12 : (!ensemble.qubit) -> (!ensemble.qubit)

        // for (i = 0; i < 13; i++)
        affine.for %i = 0 to 13 step 1 {
            // qubits[i]
            %qubit_at_i = tensor.extract %0 [%i]: tensor<13 x !ensemble.qubit>
            // gate1q "H" qubits[i];
            %2 = ensemble.gate1q "H" %qubit_at_i : (!ensemble.qubit) -> (!ensemble.qubit)
        }

        // for (i = 0; i < 12; i++)
        affine.for %i = 0 to 12 step 1 {
            // if (secret_key[i])
            %secret_key_at_i = tensor.extract %secret_key [%i]: tensor<12xi1>
            scf.if %secret_key_at_i  {
                %qubit_at_i = tensor.extract %0 [%i]: tensor<13 x !ensemble.qubit>
                // gate2q "CX" qubits[i], qubits[12];
                %2, %3 = ensemble.gate2q "CX" %qubit_at_i, %qubit12 : (!ensemble.qubit, !ensemble.qubit) -> (!ensemble.qubit, !ensemble.qubit)
            } 
        }

         // for (i = 0; i < 13; i++)
        affine.for %i = 0 to 13 step 1 {
            // qubits[i]
            %qubit_at_i = tensor.extract %0 [%i]: tensor<13 x !ensemble.qubit>
            // gate1q "H" qubits[i];
            %2 = ensemble.gate1q "H" %qubit_at_i : (!ensemble.qubit) -> (!ensemble.qubit)
        }

        // measured_qubits[0:1]
        %zero_index = arith.constant 0: index
        %one_index = arith.constant 1: index
        %measured_qubit_at_0 = tensor.extract %measured_qubits[%zero_index] : tensor<2 x i32>
        %measured_qubit_at_1 = tensor.extract %measured_qubits[%one_index]: tensor<2 x i32>
        %measured_qubit_at_0_index = arith.index_cast %measured_qubit_at_0 : i32 to index
        %measured_qubit_at_1_index = arith.index_cast %measured_qubit_at_1 : i32 to index
                

        // bit[0], bit[1]
        %cbit_0 = tensor.extract %cbits[%zero_index]: tensor<2 x !ensemble.cbit>
        %cbit_1 = tensor.extract %cbits[%one_index]: tensor<2 x !ensemble.cbit>

        // qubits[measured_qubits[0]], qubits[measured_qubits[1]]
        %2 = tensor.extract %0[%measured_qubit_at_0_index]: tensor<13 x !ensemble.qubit>
        %3 = tensor.extract %0[%measured_qubit_at_1_index]: tensor<13 x !ensemble.qubit>

        // measure qubits[measured_qubits[0]], bits[0];
        // measure qubits[measured_qubits[1]], bits[1];
        %4, %5 = ensemble.measure %2, %cbit_0 : (!ensemble.qubit, !ensemble.cbit) -> (!ensemble.qubit, !ensemble.cbit)
        %6, %7 = ensemble.measure %3, %cbit_1 : (!ensemble.qubit, !ensemble.cbit) -> (!ensemble.qubit, !ensemble.cbit)


        return
    }
}