module {
  func.func @main() {
    %cst = arith.constant 4.7123889803846897 : f64
    %cst_0 = arith.constant 1.5707963267948966 : f64
    %cst_1 = arith.constant 3.1415926535897931 : f64
    %cst_2 = arith.constant 0.000000e+00 : f64
    %cst_3 = arith.constant -1.000000e+00 : f64
    %cst_4 = arith.constant 5.000000e-01 : f64
    %c2_i32 = arith.constant 2 : i32
    %c14_i32 = arith.constant 14 : i32
    %c8_i32 = arith.constant 8 : i32
    %c0_i32 = arith.constant 0 : i32
    %cst_5 = arith.constant dense<[0.96999999999999997, 1.000000e-02, 1.000000e-02, 1.000000e-02]> : tensor<4xf64>
    %cst_6 = arith.constant dense<[9.200000e-01, 4.000000e-02, 4.000000e-02]> : tensor<3xf64>
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst_7 = arith.constant dense<[2.100000e-01, 2.400000e-01, 1.300000e-01, 1.000000e-01, 8.000000e-01, 1.000000e-01, 2.300000e-01, 5.000000e-01]> : tensor<8xf64>
    %cst_8 = arith.constant dense<[1.000000e-01, 2.000000e-01, 1.000000e-01, 1.300000e-01, 5.000000e-01, 6.000000e-01, 3.000000e-01, 5.000000e-01]> : tensor<8xf64>
    %0 = ensemble.program_alloc 8 : () -> tensor<8x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 8 : () -> tensor<8x!ensemble.cbit>
    affine.for %arg0 = 0 to 100 {
      %2 = ensemble.int_categorical %c0_i32, %cst_5, [%c8_i32, %c8_i32, %c2_i32] : (i32, tensor<4xf64>, i32, i32, i32) -> tensor<8x8x2xi32>
      %3 = ensemble.int_categorical %c0_i32, %cst_6, [%c8_i32, %c14_i32] : (i32, tensor<3xf64>, i32, i32) -> tensor<8x14xi32>
      %4 = ensemble.gate "U3" 1(%cst_2, %cst_2, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %5 = ensemble.gate "CX" 2 {"nativized-peeked"} : () -> !ensemble.gate
      ensemble.quantum_program_iteration {
        ensemble.reset_tensor %0 : (tensor<8x!ensemble.physical_qubit>) -> ()
        affine.for %arg1 = 0 to 8 {
          affine.for %arg2 = 0 to 8 {
            %extracted = tensor.extract %0[%arg2] : tensor<8x!ensemble.physical_qubit>
            ensemble.apply %4 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            %extracted_9 = tensor.extract %2[%arg1, %arg2, %c0] : tensor<8x8x2xi32>
            %extracted_10 = tensor.extract %cst_7[%arg1] : tensor<8xf64>
            %6 = arith.mulf %extracted_10, %cst_4 : f64
            %7 = arith.mulf %6, %cst_3 : f64
            %8 = arith.addf %7, %cst_2 : f64
            %9 = arith.addf %6, %cst_2 : f64
            %10 = ensemble.gate "U3" 1(%cst_2, %8, %9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
            %11 = arith.addf %7, %cst_2 : f64
            %12 = arith.addf %6, %cst_1 : f64
            %13 = ensemble.gate "U3" 1(%cst_1, %11, %12) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
            %14 = arith.addf %7, %cst_1 : f64
            %15 = arith.addf %6, %cst_2 : f64
            %16 = ensemble.gate "U3" 1(%cst_2, %14, %15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
            %17 = arith.addf %7, %cst_2 : f64
            %18 = arith.addf %6, %cst_2 : f64
            %19 = ensemble.gate "U3" 1(%cst_2, %17, %18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
            %20 = ensemble.gate_distribution %10, %13, %16, %19 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
            ensemble.apply_distribution %20[%extracted_9] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            %extracted_11 = tensor.extract %2[%arg1, %arg2, %c1] : tensor<8x8x2xi32>
            %21 = ensemble.gate "U3" 1(%cst_2, %cst_2, %cst_0) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
            %22 = ensemble.gate "U3" 1(%cst_1, %cst_2, %cst) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
            %23 = ensemble.gate "U3" 1(%cst_2, %cst_1, %cst_0) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
            %24 = ensemble.gate "U3" 1(%cst_2, %cst_2, %cst_0) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
            %25 = ensemble.gate_distribution %21, %22, %23, %24 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
            ensemble.apply_distribution %25[%extracted_11] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
          }
          affine.for %arg2 = 0 to 7 {
            %extracted = tensor.extract %0[%arg2] : tensor<8x!ensemble.physical_qubit>
            %6 = arith.addi %arg2, %c1 : index
            %extracted_9 = tensor.extract %0[%6] : tensor<8x!ensemble.physical_qubit>
            ensemble.apply %5 %extracted, %extracted_9 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            %extracted_10 = tensor.extract %cst_8[%arg1] : tensor<8xf64>
            %7 = arith.mulf %extracted_10, %cst_4 : f64
            %8 = arith.mulf %7, %cst_3 : f64
            %9 = ensemble.gate "U3" 1(%cst_2, %8, %7) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
            ensemble.apply %9 {"cannot-merge"} %extracted_9 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %5 %extracted, %extracted_9 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
          affine.for %arg2 = 0 to 8 {
            %extracted = tensor.extract %0[%arg2] : tensor<8x!ensemble.physical_qubit>
            %extracted_9 = tensor.extract %1[%arg2] : tensor<8x!ensemble.cbit>
            ensemble.measure %extracted, %extracted_9 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
          }
        }
        ensemble.transmit_results %1 : (tensor<8x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

