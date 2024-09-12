// circuit description - 1D Ising QAOA on 16 qubits
// problem hamiltonian - adjacent ZZ terms
// mixer hamiltonian - single-qubit Pauli X rotations




module {
    // # values passed in during circuit sampling
    // global circuit_index;
    // # qubits and classical bits
    // qubit qubits[16];
    // bit bits[16];
    func.func @main(%qubits: tensor<16 x !ensemble.qubit>, %cbits: tensor<16 x !ensemble.cbit>, %circuit_index : i32)  {
        %phase_gate_powers = ensemble.int_uniform 0, 4, [4,16] : () -> tensor<4 x 16 xi32>
        // reset qubits;
        %0 = ensemble.Nq_reset %qubits : (tensor<16 x !ensemble.qubit>) -> (tensor<16 x !ensemble.qubit>)
        
        affine.for %i = 0 to 16 step 1 {
            // gate1q "H" qubits[i];
            %1 = tensor.extract %0[%i] : tensor<16 x !ensemble.qubit>
            %2 = ensemble.gate1q "H" %1 : (!ensemble.qubit) -> (!ensemble.qubit)
        }
        // for (i = 0; i < 15; i++) 
        affine.for %i = 0 to 15 step 1 {
            // %qubits[i]
            %qubit_at_i = tensor.extract %0[%i] : tensor<16 x !ensemble.qubit> // qubit[i]
            %one = arith.constant 1 : index  
            %iplus1 = arith.addi %i, %one : index  // i + 1
            // %qubits[i+1]
            %qubit_at_i_plus_1 = tensor.extract %0[%iplus1] : tensor<16 x !ensemble.qubit> // qubit[i+1]
        
            // gate2q "CX" qubits[i], qubits[i + 1];
            %1, %2 = ensemble.gate2q "CX" %qubit_at_i, %qubit_at_i_plus_1 : (!ensemble.qubit, !ensemble.qubit) -> (!ensemble.qubit, !ensemble.qubit)

            %zero = arith.constant 0 : index
            %phase_gate_powers_0_i = tensor.extract %phase_gate_powers[%zero, %i] : tensor<4 x 16 xi32>
            %phase_gate_powers_0_i_index = arith.index_cast %phase_gate_powers_0_i : i32 to index
            
            // for (j = 0; j < phase_gate_powers[0][i]; j++)
            // need to use an scf for because phase_gate_powers is not known at compile time
            scf.for %j = %zero to %phase_gate_powers_0_i_index step %one { 
                // gate1q "S" qubits[i + 1];
                %3 = ensemble.gate1q "S" %2 : (!ensemble.qubit) -> (!ensemble.qubit)
            }
            
            // gate2q "CX" qubits[i], qubits[i + 1];
            %3, %4 = ensemble.gate2q "CX" %1, %2 : (!ensemble.qubit, !ensemble.qubit) -> (!ensemble.qubit, !ensemble.qubit)
        }


        // for (i = 0; i < 16; i++) 
        affine.for %i = 0 to 16 step 1 {
            // %qubits[i]
            %qubit_at_i = tensor.extract %0[%i] : tensor<16 x !ensemble.qubit> // qubit[i]
            
            //gate1q "S" qubits[i];
            //gate1q "P" qubits[i];
            %2 = ensemble.gate1q "S" %qubit_at_i : (!ensemble.qubit) -> (!ensemble.qubit)
            %3 = ensemble.gate1q "P" %2 : (!ensemble.qubit) -> (!ensemble.qubit)

            // phase_gate_powers[1][i]
            %one = arith.constant 1 : index
            %phase_gate_powers_1_i = tensor.extract %phase_gate_powers[%one, %i] : tensor<4 x 16 xi32>
            %phase_gate_powers_1_i_index = arith.index_cast %phase_gate_powers_1_i : i32 to index
            
            // for (j = 0; j < phase_gate_powers[1][i]; j++)
            %zero = arith.constant 0 : index
            // need to use an scf for because phase_gate_powers is not known at compile time
            scf.for %j = %zero to %phase_gate_powers_1_i_index step %one { 
                // gate1q "S" qubits[i];
                %4 = ensemble.gate1q "S" %3 : (!ensemble.qubit) -> (!ensemble.qubit)
            }

            //gate1q "P" qubits[i];
            //gate1q "S" qubits[i];
            %4 = ensemble.gate1q "P" %3 : (!ensemble.qubit) -> (!ensemble.qubit)
            %5 = ensemble.gate1q "S" %4 : (!ensemble.qubit) -> (!ensemble.qubit)
            
        }

        // for (i = 0; i < 15; i++) 
        affine.for %i = 0 to 15 step 1 {
            // %qubits[i]
            %qubit_at_i = tensor.extract %0[%i] : tensor<16 x !ensemble.qubit> // qubit[i]
            %one = arith.constant 1 : index  
            %iplus1 = arith.addi %i, %one : index  // i + 1
            // %qubits[i+1]
            %qubit_at_i_plus_1 = tensor.extract %0[%iplus1] : tensor<16 x !ensemble.qubit> // qubit[i+1]
        
            // gate2q "CX" qubits[i], qubits[i + 1];
            %1, %2 = ensemble.gate2q "CX" %qubit_at_i, %qubit_at_i_plus_1 : (!ensemble.qubit, !ensemble.qubit) -> (!ensemble.qubit, !ensemble.qubit)

            %zero = arith.constant 0 : index
            %two = arith.constant 2 : index
            %phase_gate_powers_2_i = tensor.extract %phase_gate_powers[%two, %i] : tensor<4 x 16 xi32>
            %phase_gate_powers_2_i_index = arith.index_cast %phase_gate_powers_2_i : i32 to index
            
            // for (j = 0; j < phase_gate_powers[0][i]; j++)
            // need to use an scf for because phase_gate_powers is not known at compile time
            scf.for %j = %zero to %phase_gate_powers_2_i_index step %one { 
                // gate1q "S" qubits[i + 1];
                %3 = ensemble.gate1q "S" %2 : (!ensemble.qubit) -> (!ensemble.qubit)
            }
            
            // gate2q "CX" qubits[i], qubits[i + 1];
            %3, %4 = ensemble.gate2q "CX" %1, %2 : (!ensemble.qubit, !ensemble.qubit) -> (!ensemble.qubit, !ensemble.qubit)
        }

         // for (i = 0; i < 16; i++) 
        affine.for %i = 0 to 16 step 1 {
            // %qubits[i]
            %qubit_at_i = tensor.extract %0[%i] : tensor<16 x !ensemble.qubit> // qubit[i]
            
            //gate1q "S" qubits[i];
            //gate1q "P" qubits[i];
            %2 = ensemble.gate1q "S" %qubit_at_i : (!ensemble.qubit) -> (!ensemble.qubit)
            %3 = ensemble.gate1q "P" %2 : (!ensemble.qubit) -> (!ensemble.qubit)

            // phase_gate_powers[1][i]
            %one = arith.constant 1 : index
            %three = arith.constant 3: index
            %phase_gate_powers_3_i = tensor.extract %phase_gate_powers[%three, %i] : tensor<4 x 16 xi32>
            %phase_gate_powers_3_i_index = arith.index_cast %phase_gate_powers_3_i : i32 to index
            
            // for (j = 0; j < phase_gate_powers[1][i]; j++)
            %zero = arith.constant 0 : index
            // need to use an scf for because phase_gate_powers is not known at compile time
            scf.for %j = %zero to %phase_gate_powers_3_i_index step %one { 
                // gate1q "S" qubits[i];
                %4 = ensemble.gate1q "S" %3 : (!ensemble.qubit) -> (!ensemble.qubit)
            }

            //gate1q "P" qubits[i];
            //gate1q "S" qubits[i];
            %4 = ensemble.gate1q "P" %3 : (!ensemble.qubit) -> (!ensemble.qubit)
            %5 = ensemble.gate1q "S" %4 : (!ensemble.qubit) -> (!ensemble.qubit)
            
            // cbit[i]
            %cbit_at_i = tensor.extract %cbits[%i] : tensor<16 x !ensemble.cbit> 
            //measure qubits[i], bits[i];
            %6, %7 = ensemble.measure %5, %cbit_at_i : (!ensemble.qubit, !ensemble.cbit) -> (!ensemble.qubit, !ensemble.cbit)
        }


        return 
        


// reset qubits;

// for (i = 0; i < 16; i++) {
// 	gate1q "H" qubits[i];
// }

// for (i = 0; i < 15; i++) {
// 	gate2q "CX" qubits[i], qubits[i + 1];
	
// 	for (j = 0; j < phase_gate_powers[0][i]; j++) {
// 		gate1q "S" qubits[i + 1];
// 	}

// 	gate2q "CX" qubits[i], qubits[i + 1];
// }

// for (i = 0; i < 16; i++) {
// 	gate1q "S" qubits[i];
// 	gate1q "P" qubits[i];

// 	for (j = 0; j < phase_gate_powers[1][i]; j++) {
// 		gate1q "S" qubits[i];
// 	}

// 	gate1q "P" qubits[i];
// 	gate1q "S" qubits[i];
// }

// for (i = 0; i < 15; i++) {
// 	gate2q "CX" qubits[i], qubits[i + 1];
	
// 	for (j = 0; j < phase_gate_powers[2][i]; j++) {
// 		gate1q "S" qubits[i + 1];
// 	}

// 	gate2q "CX" qubits[i], qubits[i + 1];
// }

// for (i = 0; i < 16; i++) {
// 	gate1q "S" qubits[i];
// 	gate1q "P" qubits[i];

// 	for (j = 0; j < phase_gate_powers[3][i]; j++) {
// 		gate1q "S" qubits[i];
// 	}

// 	gate1q "P" qubits[i];
// 	gate1q "S" qubits[i];

// 	measure qubits[i], bits[i];
// }


    }
}