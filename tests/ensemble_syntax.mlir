// RUN: tutorial-opt %s

module {
  func.func @main(%raw_arg0: !ensemble.physical_qubit, %raw_arg1: !ensemble.physical_qubit, %cbits: tensor<2 x !ensemble.cbit>) -> !ensemble.physical_qubit {
    // sample an int in [0, 2]
    %arg0 = ensemble.reset %raw_arg0 : (!ensemble.physical_qubit) -> (!ensemble.physical_qubit)
    %arg1 = ensemble.reset %raw_arg1 : (!ensemble.physical_qubit) -> (!ensemble.physical_qubit)
    %random_3_floats = ensemble.float_uniform -1.0, 1.0, [3] : () -> tensor<3xf32>
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
    %entangled_qubit0, %entangled_qubit1 = ensemble.apply %czgate %arg0, %arg1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> (!ensemble.physical_qubit, !ensemble.physical_qubit)
    %integer_0 = arith.index_cast %index0 : index to i32
    %randomly_rotated_qubit0 = ensemble.apply_distribution %gates [%integer_0] %entangled_qubit0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> (!ensemble.physical_qubit)
    %random_number_0_or_1 = ensemble.int_uniform 0, 1, [1] : () -> tensor<1xi32>
    %random_number_0_or_1_index = tensor.extract %random_number_0_or_1[%index0] : tensor<1xi32>
    %random_qubit = ensemble.qubit_distribution_1q %randomly_rotated_qubit0, %entangled_qubit1 [%random_number_0_or_1_index] : (!ensemble.physical_qubit, !ensemble.physical_qubit, i32) -> (!ensemble.physical_qubit)
    %randomly_rotated_random_qubit1 = ensemble.apply_distribution %gates [%random_number_0_or_1_index] %random_qubit : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> (!ensemble.physical_qubit)
    return %randomly_rotated_random_qubit1 : !ensemble.physical_qubit
  }
}