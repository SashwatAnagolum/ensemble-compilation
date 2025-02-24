module {
  func.func @main() {
    %cst = arith.constant 3.1415926535897931 : f64
    %cst_0 = arith.constant 1.5707963267948966 : f64
    %cst_1 = arith.constant 0.000000e+00 : f64
    %c10_i32 = arith.constant 10 : i32
    %c3_i32 = arith.constant 3 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = ensemble.program_alloc 10 : () -> tensor<10x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 10 : () -> tensor<10x!ensemble.cbit>
    affine.for %arg0 = 0 to 1000 {
      %2 = ensemble.int_uniform %c0_i32, %c3_i32, [%c10_i32] : (i32, i32, i32) -> tensor<10xi32>
      %3 = ensemble.gate "U3" 1(%cst_0, %cst_1, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %4 = ensemble.gate "CX" 2 {"nativized-peeked"} : () -> !ensemble.gate
      %5 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %6 = ensemble.gate "U3" 1(%cst_0, %cst_1, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %7 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %8 = ensemble.gate_distribution %5, %6, %7 : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
      %9 = ensemble.gate_distribution %5, %5, %6 : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
      ensemble.quantum_program_iteration {
        ensemble.reset_tensor %0 : (tensor<10x!ensemble.physical_qubit>) -> ()
        %extracted = tensor.extract %0[%c0] : tensor<10x!ensemble.physical_qubit>
        ensemble.apply %3 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        affine.for %arg1 = 0 to 9 {
          %extracted_2 = tensor.extract %0[%arg1] : tensor<10x!ensemble.physical_qubit>
          %10 = arith.addi %arg1, %c1 : index
          %extracted_3 = tensor.extract %0[%10] : tensor<10x!ensemble.physical_qubit>
          ensemble.apply %4 %extracted_2, %extracted_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        }
        affine.for %arg1 = 0 to 10 {
          %extracted_2 = tensor.extract %0[%arg1] : tensor<10x!ensemble.physical_qubit>
          %extracted_3 = tensor.extract %2[%arg1] : tensor<10xi32>
          ensemble.apply_distribution %8[%extracted_3] {"cannot-merge"} %extracted_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
          ensemble.apply_distribution %9[%extracted_3] {"cannot-merge"} %extracted_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
          %extracted_4 = tensor.extract %1[%arg1] : tensor<10x!ensemble.cbit>
          ensemble.measure %extracted_2, %extracted_4 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        ensemble.transmit_results %1 : (tensor<10x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

