module {
  func.func @main() {
    %cst = arith.constant 0.000000e+00 : f64
    %cst_0 = arith.constant 3.1415926535897931 : f64
    %cst_1 = arith.constant 1.5707963267948966 : f64
    %c32 = arith.constant 32 : index
    %c16_i32 = arith.constant 16 : i32
    %c2_i32 = arith.constant 2 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c4_i32 = arith.constant 4 : i32
    %c8_i32 = arith.constant 8 : i32
    %c9_i32 = arith.constant 9 : i32
    %c16 = arith.constant 16 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst_2 = arith.constant dense<[2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40]> : tensor<20xi32>
    %0 = ensemble.program_alloc 16 : () -> tensor<16x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 16 : () -> tensor<16x!ensemble.cbit>
    %2 = ensemble.device_connectivity %0, {dense<[[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [12, 13], [13, 14], [14, 15]]> : tensor<15x2xi32>} : (tensor<16x!ensemble.physical_qubit>) -> !ensemble.connectivity_graph
    affine.for %arg0 = 0 to 640 {
      %3 = ensemble.gate "U3" 1(%cst_0, %cst, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %4 = ensemble.gate "U3" 1(%cst_0, %cst_1, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %5 = ensemble.gate "U3" 1(%cst, %cst_0, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %6 = ensemble.gate "U3" 1(%cst_1, %cst, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %7 = ensemble.gate "CX" 2 {"nativized-peeked"} : () -> !ensemble.gate
      %8 = ensemble.gate_distribution %3, %4, %5, %6 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
      %9 = ensemble.gate_distribution %3, %4, %5 : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
      %10 = arith.divsi %arg0, %c32 : index
      %extracted = tensor.extract %cst_2[%10] : tensor<20xi32>
      %11 = arith.index_cast %extracted : i32 to index
      %12 = ensemble.int_uniform %c0_i32, %c9_i32, [%extracted] : (i32, i32, i32) -> tensor<?xi32>
      %13 = ensemble.cnot_pair_distribution %2, [%extracted, %c8_i32] : (!ensemble.connectivity_graph, i32, i32) -> tensor<?x8x2x!ensemble.physical_qubit>
      %14 = arith.addi %extracted, %c1_i32 : i32
      %15 = ensemble.int_uniform %c0_i32, %c4_i32, [%14, %c16_i32] : (i32, i32, i32, i32) -> tensor<?x16xi32>
      %16 = ensemble.int_uniform %c0_i32, %c4_i32, [%extracted, %c16_i32] : (i32, i32, i32, i32) -> tensor<?x16xi32>
      %17 = ensemble.int_uniform %c0_i32, %c4_i32, [%c16_i32] : (i32, i32, i32) -> tensor<16xi32>
      ensemble.quantum_program_iteration {
        ensemble.reset_tensor %0 : (tensor<16x!ensemble.physical_qubit>) -> ()
        affine.for %arg1 = 0 to 16 {
          %extracted_3 = tensor.extract %17[%arg1] : tensor<16xi32>
          %extracted_4 = tensor.extract %0[%arg1] : tensor<16x!ensemble.physical_qubit>
          ensemble.apply_distribution %8[%extracted_3] {"cannot-merge"} %extracted_4 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        }
        affine.for %arg1 = 0 to 16 {
          %extracted_3 = tensor.extract %15[%c0, %arg1] : tensor<?x16xi32>
          %extracted_4 = tensor.extract %0[%arg1] : tensor<16x!ensemble.physical_qubit>
          ensemble.apply_distribution %9[%extracted_3] {"cannot-merge"} %extracted_4 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        }
        scf.for %arg1 = %c0 to %11 step %c1 {
          %extracted_3 = tensor.extract %12[%arg1] : tensor<?xi32>
          %18 = arith.index_cast %extracted_3 : i32 to index
          scf.for %arg2 = %c0 to %18 step %c1 {
            %extracted_4 = tensor.extract %13[%arg1, %arg2, %c0] : tensor<?x8x2x!ensemble.physical_qubit>
            %extracted_5 = tensor.extract %13[%arg1, %arg2, %c1] : tensor<?x8x2x!ensemble.physical_qubit>
            ensemble.apply %7 %extracted_4, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
          %19 = arith.muli %extracted_3, %c2_i32 : i32
          %20 = arith.index_cast %19 : i32 to index
          scf.for %arg2 = %20 to %c16 step %c1 {
            %extracted_4 = tensor.extract %16[%arg1, %arg2] : tensor<?x16xi32>
            %extracted_5 = tensor.extract %0[%arg2] : tensor<16x!ensemble.physical_qubit>
            ensemble.apply_distribution %8[%extracted_4] {"cannot-merge"} %extracted_5 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
          }
          %21 = arith.addi %arg1, %c1 : index
          affine.for %arg2 = 0 to 16 {
            %extracted_4 = tensor.extract %15[%21, %arg2] : tensor<?x16xi32>
            %extracted_5 = tensor.extract %0[%arg2] : tensor<16x!ensemble.physical_qubit>
            ensemble.apply_distribution %9[%extracted_4] {"cannot-merge"} %extracted_5 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
          }
        }
        affine.for %arg1 = 0 to 16 {
          %extracted_3 = tensor.extract %17[%arg1] : tensor<16xi32>
          %extracted_4 = tensor.extract %0[%arg1] : tensor<16x!ensemble.physical_qubit>
          ensemble.apply_distribution %8[%extracted_3] {"cannot-merge"} %extracted_4 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        }
        affine.for %arg1 = 0 to 16 {
          %extracted_3 = tensor.extract %0[%arg1] : tensor<16x!ensemble.physical_qubit>
          %extracted_4 = tensor.extract %1[%arg1] : tensor<16x!ensemble.cbit>
          ensemble.measure %extracted_3, %extracted_4 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        ensemble.transmit_results %1 : (tensor<16x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

