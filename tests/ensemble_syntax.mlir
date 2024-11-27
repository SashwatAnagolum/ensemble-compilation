// RUN: tutorial-opt %s

module {
  func.func @main(%raw_arg0: !ensemble.physical_qubit, %raw_arg1: !ensemble.physical_qubit, %raw_arg2: !ensemble.physical_qubit, %raw_arg3: !ensemble.physical_qubit, %cbits: tensor<2 x !ensemble.cbit>) -> !ensemble.physical_qubit {
    // sample an int in [0, 2]
    ensemble.reset %raw_arg0 : (!ensemble.physical_qubit) -> ()
    ensemble.reset %raw_arg1 : (!ensemble.physical_qubit) -> ()
    ensemble.reset %raw_arg2 : (!ensemble.physical_qubit) -> ()
    ensemble.reset %raw_arg3 : (!ensemble.physical_qubit) -> ()
    %float_low = arith.constant -1.0 : f32
    %float_high = arith.constant 1.0 : f32
    %three = arith.constant 3 : i32
    %random_3_floats = ensemble.float_uniform %float_low, %float_high, [%three] : (f32, f32, i32) -> tensor<3xf32>
    %index0 = arith.constant 0 : index
    %index1 = arith.constant 1 : index
    %index2 = arith.constant 2 : index
    %2 = tensor.extract %random_3_floats[%index0] : tensor<3xf32>
    %3 = tensor.extract %random_3_floats[%index1] : tensor<3xf32>
    %4 = tensor.extract %random_3_floats[%index2] : tensor<3xf32>
    %three_d_rotation = ensemble.gate "U3" "inverse" 1 (%2, %3, %4) : (f32, f32, f32) -> (!ensemble.gate)
    %second_three_d_rotation = ensemble.gate "U3" 1 (%4, %2, %3) : (f32, f32, f32) -> (!ensemble.gate)
    %gates = ensemble.gate_distribution %three_d_rotation, %second_three_d_rotation : (!ensemble.gate, !ensemble.gate) -> (!ensemble.gate_distribution)
    %czgate = ensemble.gate "CZ" 2 : () -> (!ensemble.gate)
    %cnotgate = ensemble.gate "CNOT" 2 : () -> (!ensemble.gate)
    ensemble.apply %czgate %raw_arg0, %raw_arg1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
    %integer_0 = arith.index_cast %index0 : index to i32
    
    ensemble.apply_distribution %gates [%integer_0] %raw_arg0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
    %int_low = arith.constant 0 : i32
    %int_high = arith.constant 1 : i32  
    %one = arith.constant 1 : i32
    %random_number_0_or_1 = ensemble.int_uniform %int_low, %int_high, [%one] : (i32, i32, i32) -> tensor<1xi32>
    %random_number_0_or_1_index = tensor.extract %random_number_0_or_1[%index0] : tensor<1xi32>
    %random_qubit = ensemble.qubit_distribution_1q %raw_arg0, %raw_arg1 [%random_number_0_or_1_index] : (!ensemble.physical_qubit, !ensemble.physical_qubit, i32) -> (!ensemble.physical_qubit)

  // create a tensor representing the connectivity graph by creating a tensor<4x2x!ensemble.qubit> of shape 3x2 of type qubit by doing from_elements
    %connectivity = tensor.from_elements %raw_arg0, %raw_arg1, %raw_arg1, %raw_arg2, %raw_arg2, %raw_arg3, %raw_arg3, %raw_arg0 : tensor<4 x 2 x !ensemble.physical_qubit>
    %two = arith.constant 2 : i32
    %cnot_pair_distribution = ensemble.cnot_pair_distribution %connectivity, [%two, %two] : (tensor<4 x 2 x !ensemble.physical_qubit>, i32, i32) -> tensor<2 x 2 x 2 x !ensemble.physical_qubit>
    // for each cnot pair, extract the qubits and apply the cnot gate
    %cnot_pair_00_qubit0 = tensor.extract %cnot_pair_distribution[%index0, %index0, %index0] : tensor<2 x 2 x 2 x !ensemble.physical_qubit>
    %cnot_pair_00_qubit1 = tensor.extract %cnot_pair_distribution[%index0, %index0, %index1] : tensor<2 x 2 x 2 x !ensemble.physical_qubit>
    %cnot_pair_01_qubit0 = tensor.extract %cnot_pair_distribution[%index0, %index1, %index0] : tensor<2 x 2 x 2 x !ensemble.physical_qubit>
    %cnot_pair_01_qubit1 = tensor.extract %cnot_pair_distribution[%index0, %index1, %index1] : tensor<2 x 2 x 2 x !ensemble.physical_qubit>

    ensemble.apply %cnotgate %cnot_pair_00_qubit0, %cnot_pair_00_qubit1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
    ensemble.apply %cnotgate %cnot_pair_01_qubit0, %cnot_pair_01_qubit1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

    %cnot_pair_10_qubit0 = tensor.extract %cnot_pair_distribution[%index1, %index0, %index0] : tensor<2 x 2 x 2 x !ensemble.physical_qubit>
    %cnot_pair_10_qubit1 = tensor.extract %cnot_pair_distribution[%index1, %index0, %index1] : tensor<2 x 2 x 2 x !ensemble.physical_qubit>
    %cnot_pair_11_qubit0 = tensor.extract %cnot_pair_distribution[%index1, %index1, %index0] : tensor<2 x 2 x 2 x !ensemble.physical_qubit>
    %cnot_pair_11_qubit1 = tensor.extract %cnot_pair_distribution[%index1, %index1, %index1] : tensor<2 x 2 x 2 x !ensemble.physical_qubit>

    ensemble.apply %cnotgate %cnot_pair_10_qubit0, %cnot_pair_10_qubit1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
    ensemble.apply %cnotgate %cnot_pair_11_qubit0, %cnot_pair_11_qubit1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()


    %permutation = ensemble.permutation 4 : () -> tensor<4xi32>
    %permutation_index = tensor.extract %permutation[%index0] : tensor<4xi32>
    %permuted_qubit = ensemble.qubit_distribution_1q %raw_arg0, %raw_arg1, %raw_arg2, %raw_arg3 [%permutation_index] : (!ensemble.physical_qubit, !ensemble.physical_qubit, !ensemble.physical_qubit, !ensemble.physical_qubit, i32) -> (!ensemble.physical_qubit)
    ensemble.apply %cnotgate %permuted_qubit, %random_qubit : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
    return %permuted_qubit : !ensemble.physical_qubit
  }
}