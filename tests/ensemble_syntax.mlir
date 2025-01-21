// RUN: tutorial-opt %s

module {
  func.func private @iteration_body(%raw_arg0: !ensemble.physical_qubit, %raw_arg1: !ensemble.physical_qubit, %raw_arg2: !ensemble.physical_qubit, %raw_arg3: !ensemble.physical_qubit, %cbits: tensor<2 x !ensemble.cbit>, %random_number_0_or_1: tensor<1xi32>) -> () {
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
    
   
    %random_number_0_or_1_index = tensor.extract %random_number_0_or_1[%index0] : tensor<1xi32>
    %random_qubit = ensemble.qubit_distribution_1q %raw_arg0, %raw_arg1 [%random_number_0_or_1_index] : (!ensemble.physical_qubit, !ensemble.physical_qubit, i32) -> (!ensemble.physical_qubit)


    %four = arith.constant 4 : i32
    %permutation = ensemble.permutation %four : (i32) -> tensor<4xi32>
    %permutation_index = tensor.extract %permutation[%index0] : tensor<4xi32>
    %permuted_qubit = ensemble.qubit_distribution_1q %raw_arg0, %raw_arg1, %raw_arg2, %raw_arg3 [%permutation_index] : (!ensemble.physical_qubit, !ensemble.physical_qubit, !ensemble.physical_qubit, !ensemble.physical_qubit, i32) -> (!ensemble.physical_qubit)
    ensemble.apply %cnotgate %permuted_qubit, %random_qubit : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
    return
  }

  func.func @main() -> () {
    %qubits = ensemble.program_alloc 4 : () -> tensor<4x!ensemble.physical_qubit>
    %cbits = ensemble.alloc_cbits 2 : () -> tensor<2x!ensemble.cbit>
    %index0 = arith.constant 0 : index
    %index1 = arith.constant 1 : index
    %index2 = arith.constant 2 : index
    %index3 = arith.constant 3 : index

    %q0 = tensor.extract %qubits[%index0] : tensor<4x!ensemble.physical_qubit>
    %q1 = tensor.extract %qubits[%index1] : tensor<4x!ensemble.physical_qubit>
    %q2 = tensor.extract %qubits[%index2] : tensor<4x!ensemble.physical_qubit>
    %q3 = tensor.extract %qubits[%index3] : tensor<4x!ensemble.physical_qubit>
    %int_low = arith.constant 0 : i32 
    %int_high = arith.constant 1 : i32  
    %one = arith.constant 1 : i32
    %random_number_0_or_1 = ensemble.int_uniform %int_low, %int_high, [%one] : (i32, i32, i32) -> tensor<1xi32>
    
    ensemble.quantum_program_iteration {
      func.call @iteration_body(%q0, %q1, %q2, %q3, %cbits, %random_number_0_or_1) : (!ensemble.physical_qubit, !ensemble.physical_qubit, !ensemble.physical_qubit, !ensemble.physical_qubit, tensor<2x!ensemble.cbit>, tensor<1xi32>) -> ()
      ensemble.transmit_results %cbits : (tensor<2x!ensemble.cbit>) -> ()
    }
    return
  }
}
