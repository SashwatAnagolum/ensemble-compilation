module {
  func.func @main() {
    %cst = arith.constant -1.000000e+00 : f32
    %cst_0 = arith.constant 1.000000e+00 : f32
    %c3_i32 = arith.constant 3 : i32
    %c4_i32 = arith.constant 4 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c3 = arith.constant 3 : index
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = ensemble.program_alloc 4 : () -> tensor<4x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 2 : () -> tensor<2x!ensemble.cbit>
    %extracted = tensor.extract %0[%c0] : tensor<4x!ensemble.physical_qubit>
    %extracted_1 = tensor.extract %0[%c1] : tensor<4x!ensemble.physical_qubit>
    %extracted_2 = tensor.extract %0[%c2] : tensor<4x!ensemble.physical_qubit>
    %extracted_3 = tensor.extract %0[%c3] : tensor<4x!ensemble.physical_qubit>
    %2 = ensemble.int_uniform %c0_i32, %c1_i32, [%c1_i32] : (i32, i32, i32) -> tensor<1xi32>
    ensemble.quantum_program_iteration {
      ensemble.reset %extracted : (!ensemble.physical_qubit) -> ()
      ensemble.reset %extracted_1 : (!ensemble.physical_qubit) -> ()
      ensemble.reset %extracted_2 : (!ensemble.physical_qubit) -> ()
      ensemble.reset %extracted_3 : (!ensemble.physical_qubit) -> ()
      %3 = ensemble.float_uniform %cst, %cst_0, [%c3_i32] : (f32, f32, i32) -> tensor<3xf32>
      %extracted_4 = tensor.extract %3[%c0] : tensor<3xf32>
      %extracted_5 = tensor.extract %3[%c1] : tensor<3xf32>
      %extracted_6 = tensor.extract %3[%c2] : tensor<3xf32>
      %4 = ensemble.gate "U3" "inverse" 1(%extracted_4, %extracted_5, %extracted_6) : (f32, f32, f32) -> !ensemble.gate
      %5 = ensemble.gate "U3" 1(%extracted_6, %extracted_4, %extracted_5) : (f32, f32, f32) -> !ensemble.gate
      %6 = ensemble.gate_distribution %4, %5 : (!ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
      %7 = ensemble.gate "CZ" 2 : () -> !ensemble.gate
      %8 = ensemble.gate "CNOT" 2 : () -> !ensemble.gate
      ensemble.apply %7 %extracted, %extracted_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
      ensemble.apply_distribution %6[%c0_i32] %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
      %extracted_7 = tensor.extract %2[%c0] : tensor<1xi32>
      %9 = ensemble.qubit_distribution_1q %extracted, %extracted_1[%extracted_7] : (!ensemble.physical_qubit, !ensemble.physical_qubit, i32) -> !ensemble.physical_qubit
      %10 = ensemble.permutation %c4_i32 : (i32) -> tensor<4xi32>
      %extracted_8 = tensor.extract %10[%c0] : tensor<4xi32>
      %11 = ensemble.qubit_distribution_1q %extracted, %extracted_1, %extracted_2, %extracted_3[%extracted_8] : (!ensemble.physical_qubit, !ensemble.physical_qubit, !ensemble.physical_qubit, !ensemble.physical_qubit, i32) -> !ensemble.physical_qubit
      ensemble.apply %8 %11, %9 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
      ensemble.transmit_results %1 : (tensor<2x!ensemble.cbit>) -> ()
    }
    return
  }
}

