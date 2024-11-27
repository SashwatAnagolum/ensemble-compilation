module {
  func.func @iteration_body(%qubits: tensor<25x!ensemble.physical_qubit>, %bits: tensor<25x!ensemble.cbit>, %circuit_index: i32, %circuit_depth_val: i32, %num_cnots_in_layer: tensor<1xi32>, %cnot_pairs: tensor<?x2x!ensemble.physical_qubit>, %clifford_indices: tensor<?x25xi32>) -> () {

    %I = ensemble.gate "I" 1 : () -> !ensemble.gate
    %X = ensemble.gate "X" 1 : () -> !ensemble.gate
    %Y = ensemble.gate "Y" 1 : () -> !ensemble.gate
    %Z = ensemble.gate "Z" 1 : () -> !ensemble.gate
    %CX = ensemble.gate "CX" 2 : () -> !ensemble.gate

    %twoq_pauli_left_slices_0 = ensemble.gate_distribution %I, %I, %I, %I, %X, %X, %X, %X, %Y, %Y, %Y, %Y, %Z, %Z, %Z, %Z : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    %twoq_pauli_left_slices_1 = ensemble.gate_distribution %I, %X, %Y, %Z, %I, %X, %Y, %Z, %I, %X, %Y, %Z, %I, %X, %Y, %Z : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    
    %twoq_pauli_right_slices_0 = ensemble.gate_distribution %I, %I, %Z, %Z, %X, %X, %Y, %Y, %Y, %Y, %X, %X, %Z, %Z, %I, %I : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    %twoq_pauli_right_slices_1 = ensemble.gate_distribution %I, %X, %Y, %Z, %X, %I, %Z, %Y, %X, %I, %Z, %Y, %I, %X, %Y, %Z : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution

    %oneq_pauli_left_slices = ensemble.gate_distribution %I, %X, %Y, %Z : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    %oneq_pauli_right_slices_0 = ensemble.gate_distribution %I, %Z, %Y, %X : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    %oneq_pauli_right_slices_1 = ensemble.gate_distribution %I, %Y, %X, %Z : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    
    %sixteen = arith.constant 16 : i32
    %three = arith.constant 3 : i32
    %zero_i32 = arith.constant 0 : i32
    %two_i32 = arith.constant 2 : i32
    %twoq_pauli_indices = ensemble.int_uniform %zero_i32, %sixteen, [%circuit_depth_val, %half_num_qubits] : (i32, i32, i32, i32) -> tensor<?x?xi32>
    %oneq_pauli_indices = ensemble.int_uniform %zero_i32, %three, [%circuit_depth_val, %num_qubits] : (i32, i32, i32, i32) -> tensor<?x?xi32>

    ensemble.reset_tensor %qubits : tensor<25x!ensemble.physical_qubit>

    scf.for %i = %zero_i32 to %circuit_depth_val step %one_i32 {
      %num_cnots = tensor.extract %num_cnots_in_layer[%i] : tensor<?xi32>
      scf.for %cnot_index = %zero_i32 to %num_cnots step %one_i32 {
        %2q_pauli_index = tensor.extract %twoq_pauli_indices[%i, %cnot_index] : tensor<?xi32>
        %2q_pauli_left_slice_0 = tensor.extract %twoq_pauli_left_slices_0[%2q_pauli_index] : tensor<?xi32>
        %2q_pauli_left_slice_1 = tensor.extract %twoq_pauli_left_slices_1[%2q_pauli_index] : tensor<?xi32>

        %cnot_pair_index_2n = arith.muli %cnot_index, %two_i32 : index
        %cnot_pair_index_2n_plus_one = arith.addi %cnot_pair_index_2n, %one_i32 : index
        
        
      }
    }

    return
    
    

    // %zero = arith.constant 0 : i32
    // %one = arith.constant 1 : i32
    // %half_num_qubits = arith.divsi %num_qubits, %one : i32

    // %cond = arith.remi_signed %circuit_index, %num_randomizations_per_circuit : i32
    // %is_zero = arith.cmpi eq, %cond, %zero : i32
    // %circuit_depth = scf.if %is_zero -> (i32) {
    //   %depth = ensemble.int_uniform %min_depth, %max_depth, [1] : (i32, i32) -> tensor<1xi32>
    //   %depth_val = tensor.extract %depth[%zero] : tensor<1xi32>
    //   scf.yield %depth_val : i32
    // } else {
    //   scf.yield %zero : i32
    // }

    // %num_cnots_in_layer = ensemble.int_uniform %zero, %half_num_qubits, [%circuit_depth] : (i32, i32) -> tensor<?xi32>
    // %cnot_pairs = ensemble.cnot_pair_distribution %connectivity, %circuit_depth : (tensor<24x2xi32>, i32) -> tensor<?x2xi32>
    // %clifford_indices = ensemble.int_uniform %zero, %one, [%circuit_depth, %num_qubits] : (i32, i32) -> tensor<?xi32>
    // %2q_pauli_indices = ensemble.int_uniform %zero, 16, [%circuit_depth, %half_num_qubits] : (i32, i32) -> tensor<?xi32>
    // %1q_pauli_indices = ensemble.int_uniform %zero, 3, [%circuit_depth, %num_qubits] : (i32, i32) -> tensor<?xi32>

    // %qubits = tensor.empty() : tensor<25x!ensemble.physical_qubit>
    // %bits = tensor.empty() : tensor<25x!ensemble.cbit>

    // scf.for %i = %zero to %circuit_depth step %one {
    //   %num_cnots = tensor.extract %num_cnots_in_layer[%i] : tensor<?xi32>
    //   scf.for %cnot_index = %zero to %num_cnots step %one {
    //     %left_slice_0 = tensor.extract %2q_pauli_indices[%i, %cnot_index, %zero] : tensor<?xi32>
    //     %left_slice_1 = tensor.extract %2q_pauli_indices[%i, %cnot_index, %one] : tensor<?xi32>
    //     %right_slice_0 = tensor.extract %2q_pauli_indices[%i, %cnot_index, %zero] : tensor<?xi32>
    //     %right_slice_1 = tensor.extract %2q_pauli_indices[%i, %cnot_index, %one] : tensor<?xi32>

    //     %qubit_0 = tensor.extract %cnot_pairs[%i, %cnot_index, %zero] : tensor<?xi32>
    //     %qubit_1 = tensor.extract %cnot_pairs[%i, %cnot_index, %one] : tensor<?xi32>

    //     ensemble.apply %left_slice_0 %qubits[%qubit_0] : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    //     ensemble.apply %left_slice_1 %qubits[%qubit_1] : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    //     ensemble.apply "CX" %qubits[%qubit_0], %qubits[%qubit_1] : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
    //     ensemble.apply %right_slice_0 %qubits[%qubit_0] : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    //     ensemble.apply %right_slice_1 %qubits[%qubit_1] : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    //   }

    //   scf.for %qubit_index = arith.muli %num_cnots, %two to %num_qubits step %one {
    //     %left_slice = tensor.extract %1q_pauli_indices[%i, %qubit_index] : tensor<?xi32>
    //     %clifford = tensor.extract %clifford_indices[%i, %qubit_index] : tensor<?xi32>
    //     %right_slice = tensor.extract %1q_pauli_indices[%i, %qubit_index] : tensor<?xi32>

    //     ensemble.apply %left_slice %qubits[%qubit_index] : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    //     ensemble.apply %clifford %qubits[%qubit_index] : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    //     ensemble.apply %right_slice %qubits[%qubit_index] : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    //   }
    // }

    // scf.for %i = %zero to %num_qubits step %one {
    //   ensemble.measure %qubits[%i], %bits[%i] : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
    // }

    // return
  }

  func.func @main() -> () {
    %min_depth = arith.constant 2 : i32
    %max_depth = arith.constant 100 : i32
    %num_qubits = arith.constant 25 : i32
    %qubits = ensemble.program_alloc 25 : () -> tensor<25x!ensemble.physical_qubit>
    %bits = tensor.empty() : tensor<25x!ensemble.cbit>
    %num_randomizations_per_circuit = arith.constant 10000 : i32
    %zero_index = arith.constant 0 : index
    %one_index = arith.constant 1 : index
    %zero_i32 = arith.constant 0 : i32
    %one_i32 = arith.constant 1 : i32
    %two_i32 = arith.constant 2 : i32

    %connectivity = tensor.empty() : tensor<24x2x!ensemble.physical_qubit>
    affine.for %i = 0 to 24 {
      %dst = arith.addi %i, %one_index : index
      %src_qubit = tensor.extract %qubits[%i] : tensor<25x!ensemble.physical_qubit>
      %dst_qubit = tensor.extract %qubits[%dst] : tensor<25x!ensemble.physical_qubit>
      tensor.insert %src_qubit into %connectivity[%i, %zero_index] : tensor<24x2x!ensemble.physical_qubit>
      tensor.insert %dst_qubit into %connectivity[%i, %one_index] : tensor<24x2x!ensemble.physical_qubit>
      affine.yield
    }
    
    affine.for %i = 0 to 20 {
      %circuit_depth = ensemble.int_uniform %min_depth, %max_depth: (i32, i32) -> tensor<1xi32>
      %circuit_depth_val = tensor.extract %circuit_depth[%zero_index] : tensor<1xi32>
      %two = arith.constant 2 : i32
      %half_num_qubits = arith.divsi %num_qubits, %two : i32
      %half_plus_one = arith.addi %half_num_qubits, %one_i32 : i32
      %num_cnots_in_layer = ensemble.int_uniform %zero_i32, %half_plus_one, [%circuit_depth_val] : (i32, i32, i32) -> tensor<1xi32>
      %cnot_pairs = ensemble.cnot_pair_distribution %connectivity, %circuit_depth_val : (tensor<24x2x!ensemble.physical_qubit>, i32) -> tensor<?x2x!ensemble.physical_qubit>
      %clifford_indices = ensemble.int_uniform %zero_i32, %two_i32, [%circuit_depth_val, %num_qubits] : (i32, i32, i32, i32) -> tensor<?x25xi32>
      affine.for %j = 0 to 1000 {
        %j_i32 = arith.index_cast %j : index to i32
        func.call @iteration_body(%qubits, %bits, %circuit_index, %circuit_depth_val, %num_cnots_in_layer, %cnot_pairs, %clifford_indices) : (tensor<25x!ensemble.physical_qubit>, tensor<25x!ensemble.cbit>, i32, i32, tensor<1xi32>, tensor<?x2x!ensemble.physical_qubit>, tensor<?x25xi32>) -> ()
      }
      affine.yield
    }

    return
  }
}

