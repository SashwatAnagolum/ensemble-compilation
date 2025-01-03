module {
  func.func private @iteration_body(%qubits: tensor<25x!ensemble.physical_qubit>, %bits: tensor<25x!ensemble.cbit>, %circuit_index: i32, %circuit_depth_val: i32, %num_cnots_in_layer: tensor<?xi32>, %cnot_pairs: tensor<?x?x2x!ensemble.physical_qubit>, %clifford_indices: tensor<?x25xi32>, %half_num_qubits: i32, %num_qubits: i32) -> () {

    %I = ensemble.gate "I" 1 : () -> !ensemble.gate
    %X = ensemble.gate "X" 1 : () -> !ensemble.gate
    %H = ensemble.gate "H" 1 : () -> !ensemble.gate
    %S = ensemble.gate "S" 1 : () -> !ensemble.gate
    %Y = ensemble.gate "Y" 1 : () -> !ensemble.gate
    %Z = ensemble.gate "Z" 1 : () -> !ensemble.gate
    %CX = ensemble.gate "CX" 2 : () -> !ensemble.gate

    %twoq_pauli_left_slices_0 = ensemble.gate_distribution %I, %I, %I, %I, %X, %X, %X, %X, %Y, %Y, %Y, %Y, %Z, %Z, %Z, %Z : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    %twoq_pauli_left_slices_1 = ensemble.gate_distribution %I, %X, %Y, %Z, %I, %X, %Y, %Z, %I, %X, %Y, %Z, %I, %X, %Y, %Z : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    
    %twoq_pauli_right_slices_0 = ensemble.gate_distribution %I, %I, %Z, %Z, %X, %X, %Y, %Y, %Y, %Y, %X, %X, %Z, %Z, %I, %I : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    %twoq_pauli_right_slices_1 = ensemble.gate_distribution %I, %X, %Y, %Z, %X, %I, %Z, %Y, %X, %I, %Z, %Y, %I, %X, %Y, %Z : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution

    %oneq_pauli_left_slices = ensemble.gate_distribution %I, %X, %Y, %Z : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    %oneq_pauli_right_slices = ensemble.gate_distribution %I, %Z, %Y, %X, %I, %Y, %X, %Z : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    
    %sixteen = arith.constant 16 : i32
    %four = arith.constant 4 : i32
    %zero_i32 = arith.constant 0 : i32
    %zero_index = arith.constant 0 : index
    %one_index = arith.constant 1 : index
    %two_index = arith.constant 2 : index
    %two_i32 = arith.constant 2 : i32
    %twoq_pauli_indices = ensemble.int_uniform %zero_i32, %sixteen, [%circuit_depth_val, %half_num_qubits] : (i32, i32, i32, i32) -> tensor<?x?xi32>
    %oneq_pauli_indices = ensemble.int_uniform %zero_i32, %four, [%circuit_depth_val, %num_qubits] : (i32, i32, i32, i32) -> tensor<?x?xi32>

    ensemble.quantum_program_iteration {
      ensemble.reset_tensor %qubits : (tensor<25x!ensemble.physical_qubit>) -> ()
      %circuit_depth_index = arith.index_cast %circuit_depth_val : i32 to index
      scf.for %i = %zero_index to %circuit_depth_index step %one_index {
        %num_cnots = tensor.extract %num_cnots_in_layer[%i] : tensor<?xi32>
        %num_cnots_index = arith.index_cast %num_cnots : i32 to index
        scf.for %cnot_index = %zero_index to %num_cnots_index step %one_index {
          %twoq_pauli_index = tensor.extract %twoq_pauli_indices[%i, %cnot_index] : tensor<?x?xi32>

          %cnot_pair_index_2n = arith.muli %cnot_index, %two_index : index
          %cnot_pair_index_2n_plus_one = arith.addi %cnot_pair_index_2n, %one_index : index

          %qubit_2n = tensor.extract %cnot_pairs[%i, %cnot_index, %zero_index] : tensor<?x?x2x!ensemble.physical_qubit>
          %qubit_2n_plus_one = tensor.extract %cnot_pairs[%i, %cnot_index, %one_index] : tensor<?x?x2x!ensemble.physical_qubit>

          ensemble.apply_distribution %twoq_pauli_left_slices_0 [%twoq_pauli_index] %qubit_2n : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
          ensemble.apply_distribution %twoq_pauli_left_slices_1 [%twoq_pauli_index] %qubit_2n_plus_one : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
          
          ensemble.apply %CX %qubit_2n, %qubit_2n_plus_one : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

          ensemble.apply_distribution %twoq_pauli_right_slices_0 [%twoq_pauli_index] %qubit_2n : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
          ensemble.apply_distribution %twoq_pauli_right_slices_1 [%twoq_pauli_index] %qubit_2n_plus_one : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        }
        %qubit_index_start_i32 = arith.muli %num_cnots, %two_i32 : i32
        %qubit_index_start = arith.index_cast %qubit_index_start_i32 : i32 to index
        %num_qubits_index = arith.index_cast %num_qubits : i32 to index
        scf.for %qubit_index = %qubit_index_start to %num_qubits_index step %one_index {
          %oneq_pauli_left_index = tensor.extract %clifford_indices[%i, %qubit_index] : tensor<?x25xi32> // 0 or 1
          %index_of_oneq_pauli_left_slices = tensor.extract %oneq_pauli_indices[%i, %qubit_index] : tensor<?x?xi32> // 0, 1, 2, or 3
          %qubit = tensor.extract %qubits[%qubit_index] : tensor<25x!ensemble.physical_qubit>
          ensemble.apply_distribution %oneq_pauli_left_slices [%index_of_oneq_pauli_left_slices] %qubit : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

          %clifford_gates_distribution = ensemble.gate_distribution %S, %H : (!ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
          ensemble.apply_distribution %clifford_gates_distribution [%oneq_pauli_left_index] %qubit : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

          // index into it is 4 times oneq_pauli_left_index + index_of_oneq_pauli_left_slices
          %index_of_oneq_pauli_right_slices_temp = arith.muli %four, %oneq_pauli_left_index : i32
          %index_of_oneq_pauli_right_slices = arith.addi %index_of_oneq_pauli_right_slices_temp, %index_of_oneq_pauli_left_slices : i32
          ensemble.apply_distribution %oneq_pauli_right_slices [%index_of_oneq_pauli_right_slices] %qubit : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        }
      }
      %num_qubits_index = arith.index_cast %num_qubits : i32 to index

      scf.for %i = %zero_index to %num_qubits_index step %one_index {
        %qubit = tensor.extract %qubits[%i] : tensor<25x!ensemble.physical_qubit>
        %bit = tensor.extract %bits[%i] : tensor<25x!ensemble.cbit>
        ensemble.measure %qubit, %bit : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
      }
      ensemble.transmit_results %bits : (tensor<25x!ensemble.cbit>) -> ()
    }

    return
    
    
  }

  func.func @main() -> () {
    %min_depth = arith.constant 2 : i32
    %max_depth = arith.constant 100 : i32
    %num_qubits = arith.constant 25 : i32
    %qubits = ensemble.program_alloc 25 : () -> tensor<25x!ensemble.physical_qubit>
    %bits = ensemble.alloc_cbits 25 : () -> tensor<25x!ensemble.cbit>
    %num_randomizations_per_circuit = arith.constant 10000 : i32
    %zero_index = arith.constant 0 : index
    %one_index = arith.constant 1 : index
    %zero_i32 = arith.constant 0 : i32
    %one_i32 = arith.constant 1 : i32
    %two_i32 = arith.constant 2 : i32
    %twenty_four_index = arith.constant 24 : index
    %twenty_index = arith.constant 20 : index
    %thousand_index = arith.constant 1000 : index

    %connectivity = tensor.empty() : tensor<24x2x!ensemble.physical_qubit>
    scf.for %i = %zero_index to %twenty_four_index step %one_index {
      %dst = arith.addi %i, %one_index : index
      %src_qubit = tensor.extract %qubits[%i] : tensor<25x!ensemble.physical_qubit>
      %dst_qubit = tensor.extract %qubits[%dst] : tensor<25x!ensemble.physical_qubit>
      tensor.insert %src_qubit into %connectivity[%i, %zero_index] : tensor<24x2x!ensemble.physical_qubit>
      tensor.insert %dst_qubit into %connectivity[%i, %one_index] : tensor<24x2x!ensemble.physical_qubit>
    }
    
    scf.for %i = %zero_index to %twenty_index step %one_index {
      %circuit_depth = ensemble.int_uniform %min_depth, %max_depth: (i32, i32) -> tensor<1xi32>
      %circuit_depth_val = tensor.extract %circuit_depth[%zero_index] : tensor<1xi32>
      %two = arith.constant 2 : i32
      %half_num_qubits = arith.divsi %num_qubits, %two : i32
      %half_plus_one = arith.addi %half_num_qubits, %one_i32 : i32
      %num_cnots_in_layer = ensemble.int_uniform %zero_i32, %half_plus_one, [%circuit_depth_val] : (i32, i32, i32) -> tensor<?xi32>
      %cnot_pairs = ensemble.cnot_pair_distribution %connectivity, [%circuit_depth_val, %half_num_qubits] : (tensor<24x2x!ensemble.physical_qubit>, i32, i32) -> tensor<?x?x2x!ensemble.physical_qubit>
      %clifford_indices = ensemble.int_uniform %zero_i32, %two_i32, [%circuit_depth_val, %num_qubits] : (i32, i32, i32, i32) -> tensor<?x25xi32>
      scf.for %j = %zero_index to %thousand_index step %one_index {
        %circuit_index = arith.index_cast %j : index to i32
        func.call @iteration_body(%qubits, %bits, %circuit_index, %circuit_depth_val, %num_cnots_in_layer, %cnot_pairs, %clifford_indices, %half_num_qubits, %num_qubits) : (tensor<25x!ensemble.physical_qubit>, tensor<25x!ensemble.cbit>, i32, i32, tensor<?xi32>, tensor<?x?x2x!ensemble.physical_qubit>, tensor<?x25xi32>, i32, i32) -> ()
      }
    }

    return
  }
}

