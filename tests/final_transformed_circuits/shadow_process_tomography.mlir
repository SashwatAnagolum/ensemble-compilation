module {
  func.func @main() {
    %cst = arith.constant 3.1415926535897931 : f64
    %cst_0 = arith.constant 0.000000e+00 : f64
    %cst_1 = arith.constant 1.5707963267948966 : f64
    %c0_i32 = arith.constant 0 : i32
    %c6_i32 = arith.constant 6 : i32
    %c2_i32 = arith.constant 2 : i32
    %c4_i32 = arith.constant 4 : i32
    %c1_i32 = arith.constant 1 : i32
    %c3_i32 = arith.constant 3 : i32
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = ensemble.program_alloc 4 : () -> tensor<4x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 4 : () -> tensor<4x!ensemble.cbit>
    affine.for %arg0 = 0 to 1024 {
      %2 = ensemble.gate "U3" 1(%cst_0, %cst_0, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %3 = ensemble.gate "U3" 1(%cst_1, %cst_0, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %4 = ensemble.gate "U3" 1(%cst, %cst_0, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %5 = ensemble.gate "U3" 1(%cst_0, %cst_0, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %6 = ensemble.gate "U3" "inverse" 1(%cst_0, %cst_0, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %7 = ensemble.gate "U3" "inverse" 1(%cst_1, %cst_0, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %8 = ensemble.gate "U3" "inverse" 1(%cst, %cst_0, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %9 = ensemble.gate "U3" "inverse" 1(%cst_0, %cst_0, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %10 = ensemble.gate "CX" 2 {"nativized-peeked"} : () -> !ensemble.gate
      %11 = ensemble.gate_distribution %2, %3, %5, %2, %2, %3, %4, %4, %4 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
      %12 = ensemble.gate_distribution %6, %7, %9, %6, %6, %7, %8, %8, %8 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
      %13 = ensemble.int_uniform %c0_i32, %c6_i32, [%c2_i32, %c4_i32] : (i32, i32, i32, i32) -> tensor<2x4xi32>
      ensemble.quantum_program_iteration {
        ensemble.reset_tensor %0 : (tensor<4x!ensemble.physical_qubit>) -> ()
        affine.for %arg1 = 0 to 4 {
          %extracted_2 = tensor.extract %13[%c0, %arg1] : tensor<2x4xi32>
          %14 = arith.muli %extracted_2, %c3_i32 : i32
          %15 = arith.addi %14, %c2_i32 : i32
          %16 = arith.addi %14, %c3_i32 : i32
          %17 = arith.index_cast %16 : i32 to index
          %18 = arith.index_cast %15 : i32 to index
          %19 = arith.index_cast %14 : i32 to index
          %extracted_3 = tensor.extract %0[%arg1] : tensor<4x!ensemble.physical_qubit>
          ensemble.apply_distribution %12[%18] {"cannot-merge"} %extracted_3 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
          ensemble.apply_distribution %12[%17] {"cannot-merge"} %extracted_3 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
          ensemble.apply_distribution %12[%19] {"cannot-merge"} %extracted_3 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
        }
        %extracted = tensor.extract %0[%c0] : tensor<4x!ensemble.physical_qubit>
        ensemble.apply %3 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        affine.for %arg1 = 0 to 3 {
          %extracted_2 = tensor.extract %0[%arg1] : tensor<4x!ensemble.physical_qubit>
          %14 = arith.addi %arg1, %c1 : index
          %extracted_3 = tensor.extract %0[%14] : tensor<4x!ensemble.physical_qubit>
          ensemble.apply %10 %extracted_2, %extracted_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        }
        affine.for %arg1 = 0 to 4 {
          %extracted_2 = tensor.extract %0[%arg1] : tensor<4x!ensemble.physical_qubit>
          %extracted_3 = tensor.extract %13[%c1, %arg1] : tensor<2x4xi32>
          %14 = arith.muli %extracted_3, %c3_i32 : i32
          %15 = arith.index_cast %14 : i32 to index
          %16 = arith.addi %14, %c1_i32 : i32
          %17 = arith.index_cast %16 : i32 to index
          ensemble.apply_distribution %11[%15] {"cannot-merge"} %extracted_2 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
          ensemble.apply_distribution %11[%17] {"cannot-merge"} %extracted_2 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
        }
        affine.for %arg1 = 0 to 4 {
          %extracted_2 = tensor.extract %0[%arg1] : tensor<4x!ensemble.physical_qubit>
          %extracted_3 = tensor.extract %1[%arg1] : tensor<4x!ensemble.cbit>
          ensemble.measure %extracted_2, %extracted_3 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        ensemble.transmit_results %1 : (tensor<4x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

