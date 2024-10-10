// RUN: tutorial-opt %s

module {
  func.func @main(%raw_arg0: !ensemble.physical_qubit, %raw_arg1: !ensemble.physical_qubit, %cbits: tensor<2 x !ensemble.cbit>) -> !ensemble.physical_qubit {
    // sample an int in [0, 2]
    %arg0 = ensemble.1q_reset %raw_arg0 : (!ensemble.physical_qubit) -> (!ensemble.physical_qubit)
    %arg1 = ensemble.1q_reset %raw_arg1 : (!ensemble.physical_qubit) -> (!ensemble.physical_qubit)
    %random_3_floats = ensemble.float_uniform -1.0, 1.0, [3] : () -> (tensor<3 x f32>)
    %index0 = arith.constant 0 : index
    %index1 = arith.constant 1 : index
    %index2 = arith.constant 2 : index
    %2 = tensor.extract %random_3_floats[%index0] : tensor<3 x f32>
    %3 = tensor.extract %random_3_floats[%index1] : tensor<3 x f32>
    %4 = tensor.extract %random_3_floats[%index2] : tensor<3 x f32>
    %three_d_rotation = ensemble.gate "U3" "inverse" ( %2, %3, %4 ) : (f32, f32, f32) -> (!ensemble.gate)
    %cnot = ensemble.gate "CX" : () -> (!ensemble.gate)
    %rotated_qubit = ensemble.apply %three_d_rotation %arg0 : (!ensemble.gate, !ensemble.physical_qubit) -> (!ensemble.physical_qubit)
    %entangled_qubit0, %entangled_qubit1 = ensemble.apply %cnot %rotated_qubit, %arg1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> (!ensemble.physical_qubit, !ensemble.physical_qubit)
    %second_three_d_rotation = ensemble.gate "U3"  ( %2, %3, %4 ) : (f32, f32, f32) -> (!ensemble.gate)
    %0 = arith.constant 0 : i32
    %gates = tensor.from_elements %three_d_rotation, %second_three_d_rotation : tensor<2 x !ensemble.gate>
    %randomly_rotated_qubit0 = ensemble.apply_distribution %gates [%0] %entangled_qubit0 : (tensor<2 x !ensemble.gate>, i32, !ensemble.physical_qubit) -> (!ensemble.physical_qubit)
    %random_number_0_or_1 = ensemble.int_uniform 0, 1, [1]: () -> (tensor<1 xi32>)
    %iswear_its_an_index = arith.index_cast %0 : i32 to index
    %random_number_0_or_1_index = tensor.extract %random_number_0_or_1[%iswear_its_an_index] : tensor<1 xi32>
    %random_qubit = ensemble.qubit_distribution_1q %randomly_rotated_qubit0, %entangled_qubit1 [%random_number_0_or_1_index] : (!ensemble.physical_qubit, !ensemble.physical_qubit, i32) -> (!ensemble.physical_qubit)
    %randomly_rotated_random_qubit1 = ensemble.apply_distribution %gates [%random_number_0_or_1_index] %random_qubit : (tensor<2 x !ensemble.gate>, i32, !ensemble.physical_qubit) -> (!ensemble.physical_qubit)
  }
}