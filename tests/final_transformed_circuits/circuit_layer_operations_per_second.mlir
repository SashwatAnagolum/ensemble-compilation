module {
  func.func @main() {
    %cst = arith.constant 4.7123889803846897 : f64
    %cst_0 = arith.constant -1.000000e+00 : f64
    %cst_1 = arith.constant 5.000000e-01 : f64
    %cst_2 = arith.constant -1.5707963267948966 : f64
    %c4_i32 = arith.constant 4 : i32
    %cst_3 = arith.constant 0.000000e+00 : f64
    %cst_4 = arith.constant 6.2831853071800001 : f64
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c8_i32 = arith.constant 8 : i32
    %0 = ensemble.program_alloc 8 : () -> tensor<8x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 8 : () -> tensor<8x!ensemble.cbit>
    %2 = ensemble.device_connectivity %0, {dense<[[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 0]]> : tensor<8x2xi32>} : (tensor<8x!ensemble.physical_qubit>) -> !ensemble.connectivity_graph
    affine.for %arg0 = 0 to 100 {
      %3 = ensemble.cnot_pair_distribution %2, [%c8_i32, %c4_i32] : (!ensemble.connectivity_graph, i32, i32) -> tensor<8x4x2x!ensemble.physical_qubit>
      %4 = ensemble.float_uniform %cst_3, %cst_4, [%c8_i32, %c8_i32] : (f64, f64, i32, i32) -> tensor<8x8xf64>
      ensemble.quantum_program_iteration {
        ensemble.reset_tensor %0 : (tensor<8x!ensemble.physical_qubit>) -> ()
        affine.for %arg1 = 0 to 8 {
          affine.for %arg2 = 0 to 8 step 2 {
            %extracted = tensor.extract %3[%arg1, %arg2, %c0] : tensor<8x4x2x!ensemble.physical_qubit>
            %extracted_5 = tensor.extract %3[%arg1, %arg2, %c1] : tensor<8x4x2x!ensemble.physical_qubit>
            %5 = ensemble.gate "CX" 2 {"nativized-peeked"} : () -> !ensemble.gate
            ensemble.apply %5 %extracted, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
          affine.for %arg2 = 0 to 8 {
            %extracted = tensor.extract %4[%arg1, %arg2] : tensor<8x8xf64>
            %extracted_5 = tensor.extract %0[%arg2] : tensor<8x!ensemble.physical_qubit>
            %5 = arith.mulf %extracted, %cst_1 : f64
            %6 = arith.mulf %5, %cst_0 : f64
            %7 = arith.addf %6, %cst_2 : f64
            %8 = arith.addf %5, %cst : f64
            %9 = ensemble.gate "U3" 1(%cst, %7, %8) {"generated-by-merging", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
            ensemble.apply %9 {"cannot-merge"} %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
        }
        affine.for %arg1 = 0 to 8 {
          %extracted = tensor.extract %0[%arg1] : tensor<8x!ensemble.physical_qubit>
          %extracted_5 = tensor.extract %1[%arg1] : tensor<8x!ensemble.cbit>
          ensemble.measure %extracted, %extracted_5 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        ensemble.transmit_results %1 : (tensor<8x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

