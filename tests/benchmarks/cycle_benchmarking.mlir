// TODO: check the loops and amounts in the main function
module {
  func.func private @iteration_body(%qubits: tensor<6x!ensemble.physical_qubit>, %bits: tensor<6x!ensemble.cbit>, %circuit_index: index, %num_random_paulis: i32, %num_frame_randomizations: i32, %pauli_indices: tensor<6xi32> ) -> () {
    %I = ensemble.gate "I" 1 : () -> !ensemble.gate
    %X = ensemble.gate "X" 1 : () -> !ensemble.gate
    %Y = ensemble.gate "Y" 1 : () -> !ensemble.gate
    %Z = ensemble.gate "Z" 1 : () -> !ensemble.gate
    %zero_i32 = arith.constant 0 : i32
    %pauli_cycle = arith.constant dense<[0, 1, 0, 1, 0, 1]> : tensor<6xi32>
    %edge_frame_randomization = ensemble.gate_distribution %Y, %Y, %X, %X, %X, %Y, %X, %Y, %Z : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    %four_i32 = arith.constant 4 : i32
    %three_i32 = arith.constant 3 : i32
    %one_i32 = arith.constant 1 : i32
    %zero_index = arith.constant 0 : index
    %one_index = arith.constant 1 : index
    %six_index = arith.constant 6 : index
    %eight_i32 = arith.constant 8 : i32
    %twelve_i32 = arith.constant 12 : i32
    %thirteen_i32 = arith.constant 13 : i32
    %six_i32 = arith.constant 6 : i32
    %num_repetitions = tensor.from_elements %four_i32, %eight_i32, %twelve_i32 : tensor<3xi32>
    %circuit_index_i32 = arith.index_cast %circuit_index : index to i32

    %rc_indices = ensemble.int_uniform %zero_i32, %three_i32, [%thirteen_i32, %six_i32] : (i32, i32, i32, i32) -> tensor<13x6xi32>
    %xyz = ensemble.gate_distribution %X, %Y, %Z : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution

    ensemble.quantum_program_iteration {
      ensemble.reset_tensor %qubits : (tensor<6x!ensemble.physical_qubit>) -> ()

      scf.for %i = %zero_index to %six_index step %one_index {
          // pauli_index_i = pauli_indices[i]
          // rc_index_i = rc_indices[0][i]
          // qubit_i = qubits[i]
          // gate_to_apply = edge_frame_randomization[pauli_index_i][rc_index_i]
          // apply gate_to_apply to qubit_i

          // gate1q edge_frame_randomization[pauli_indices[i]][rc_indices[0][i]] qubits[i];
          %pauli_index_i32 = tensor.extract %pauli_indices[%i] : tensor<6xi32>
          %pauli_index_i = arith.index_cast %pauli_index_i32 : i32 to index
          %rc_index_i32 = tensor.extract %rc_indices[%zero_index, %i] : tensor<13x6xi32>
          %rc_index_i = arith.index_cast %rc_index_i32 : i32 to index
          %qubit_i = tensor.extract %qubits[%i] : tensor<6x!ensemble.physical_qubit>
          %three_index = arith.constant 3 : index
          %temp = arith.muli %pauli_index_i, %three_index : index
          %index_into_gate_distribution = arith.addi %temp, %rc_index_i : index
          
          ensemble.apply_distribution %edge_frame_randomization[%index_into_gate_distribution] %qubit_i : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
      }

      // repeated application of gate cycle and frame randomizations
      // end_index is num_repetitions[circuit_index % 3] - 1
      %circuit_index_mod_three = arith.remsi %circuit_index_i32, %three_i32 : i32
      %circuit_index_mod_three_index = arith.index_cast %circuit_index_mod_three : i32 to index
      %num_repetitions_circuit_index_mod_three = tensor.extract %num_repetitions[%circuit_index_mod_three_index] : tensor<3xi32>
      %end_i32 = arith.subi %num_repetitions_circuit_index_mod_three, %one_i32 : i32
      %end_index = arith.index_cast %end_i32 : i32 to index

      scf.for %rep_index = %zero_index to %end_index step %one_index {
        
        scf.for %i = %zero_index to %six_index step %one_index {
          %pauli_cycle_i32 = tensor.extract %pauli_cycle[%i] : tensor<6xi32>
          %pauli_cycle_i = arith.index_cast %pauli_cycle_i32 : i32 to index
          %qubit_i = tensor.extract %qubits[%i] : tensor<6x!ensemble.physical_qubit>
          
          ensemble.apply_distribution %xyz[%pauli_cycle_i] %qubit_i : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
        }

        scf.for %i = %zero_index to %six_index step %one_index {
          %rc_index_i32 = tensor.extract %rc_indices[%rep_index, %i] : tensor<13x6xi32>
          %rc_index_i = arith.index_cast %rc_index_i32 : i32 to index
          %qubit_i = tensor.extract %qubits[%i] : tensor<6x!ensemble.physical_qubit>
          ensemble.apply_distribution %xyz[%rc_index_i] %qubit_i : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
        }

      }

      scf.for %i = %zero_index to %six_index step %one_index {
        // gate1q ["X", "Y", "Z"][pauli_cycle[i]] qubits[i];
        %pauli_cycle_i32 = tensor.extract %pauli_cycle[%i] : tensor<6xi32>
        %pauli_cycle_i = arith.index_cast %pauli_cycle_i32 : i32 to index
        %qubit_i = tensor.extract %qubits[%i] : tensor<6x!ensemble.physical_qubit>
        ensemble.apply_distribution %xyz[%pauli_cycle_i] %qubit_i : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
      }

      scf.for %i = %zero_index to %six_index step %one_index {
        // gate1q edge_frame_randomization[pauli_indices[i]][rc_indices[num_repetitions[circuit_index % 3] - 1][i]] qubits[i];
        %qubit_i = tensor.extract %qubits[%i] : tensor<6x!ensemble.physical_qubit>
        %rc_index_i32 = tensor.extract %rc_indices[%end_index, %i] : tensor<13x6xi32>
        %rc_index_i = arith.index_cast %rc_index_i32 : i32 to index
        %three_index = arith.constant 3 : index
        %pauli_index_i32 = tensor.extract %pauli_indices[%i] : tensor<6xi32>
        %pauli_index_i = arith.index_cast %pauli_index_i32 : i32 to index
        %temp = arith.muli %pauli_index_i, %three_index : index
        %index_into_gate_distribution = arith.addi %temp, %rc_index_i : index
        ensemble.apply_distribution %edge_frame_randomization[%index_into_gate_distribution] %qubit_i : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
      }

      scf.for %i = %zero_index to %six_index step %one_index {
        %qubit_i = tensor.extract %qubits[%i] : tensor<6x!ensemble.physical_qubit>
        %bit_i = tensor.extract %bits[%i] : tensor<6x!ensemble.cbit>
        ensemble.measure %qubit_i, %bit_i : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
      }

      ensemble.transmit_results %bits : (tensor<6x!ensemble.cbit>) -> ()
    }
    return

    
  }
  func.func @main() -> () {
    %qubits = ensemble.program_alloc 6 : () -> tensor<6x!ensemble.physical_qubit>
    %bits = ensemble.alloc_cbits 6 : () -> tensor<6x!ensemble.cbit>
    %num_random_paulis = arith.constant 64 : i32
    %num_frame_randomizations = arith.constant 10 : i32
    %zero_i32 = arith.constant 0 : i32
    %three_i32 = arith.constant 3 : i32
    %six_i32 = arith.constant 6 : i32
    %zero_index = arith.constant 0 : index
    %one_index = arith.constant 1 : index
    %thousand_index = arith.constant 1000 : index
    %thirty_index = arith.constant 30 : index

    scf.for %i = %zero_index to %thousand_index step %one_index {
      %pauli_indices = ensemble.int_uniform %zero_i32, %three_i32, [%six_i32] : (i32, i32, i32) -> tensor<6xi32>
      
      scf.for %j = %zero_index to %thirty_index step %one_index { 
        // the circuit index is i * 30 + j
        %thirty_i = arith.muli %i, %thirty_index : index
        %circuit_index = arith.addi %thirty_i, %j : index
        func.call @iteration_body(%qubits, %bits, %circuit_index, %num_random_paulis, %num_frame_randomizations, %pauli_indices) : (tensor<6x!ensemble.physical_qubit>, tensor<6x!ensemble.cbit>, index, i32, i32, tensor<6xi32>) -> ()
        
      }
    }
    return

    
  }
}
