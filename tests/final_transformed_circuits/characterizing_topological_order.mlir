module {
  func.func @main() {
    %cst = arith.constant 3.1415926535897931 : f64
    %cst_0 = arith.constant 1.5707963267948966 : f64
    %cst_1 = arith.constant 0.000000e+00 : f64
    %c0_i32 = arith.constant 0 : i32
    %c3_i32 = arith.constant 3 : i32
    %c4_i32 = arith.constant 4 : i32
    %c5_i32 = arith.constant 5 : i32
    %c8_i32 = arith.constant 8 : i32
    %c7_i32 = arith.constant 7 : i32
    %c9_i32 = arith.constant 9 : i32
    %c10_i32 = arith.constant 10 : i32
    %c11_i32 = arith.constant 11 : i32
    %c12_i32 = arith.constant 12 : i32
    %cst_2 = arith.constant dense<[14, 10, 6, 19, 15, 11, 24, 20, 16]> : tensor<9xi32>
    %0 = ensemble.program_alloc 31 : () -> tensor<31x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 31 : () -> tensor<31x!ensemble.cbit>
    affine.for %arg0 = 0 to 1024 {
      %2 = ensemble.gate "U3" 1(%cst_0, %cst_1, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %3 = ensemble.gate "CX" 2 {"nativized-peeked"} : () -> !ensemble.gate
      %4 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %5 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %6 = ensemble.int_uniform %c0_i32, %c3_i32, [%c9_i32] : (i32, i32, i32) -> tensor<9xi32>
      ensemble.reset_tensor %0 : (tensor<31x!ensemble.physical_qubit>) -> ()
      ensemble.quantum_program_iteration {
        affine.for %arg1 = 0 to 3 {
          affine.for %arg2 = 0 to 4 {
            %7 = arith.index_cast %arg1 : index to i32
            %8 = arith.index_cast %arg2 : index to i32
            %9 = arith.muli %7, %c9_i32 : i32
            %10 = arith.addi %9, %8 : i32
            %11 = arith.index_cast %10 : i32 to index
            %extracted = tensor.extract %0[%11] : tensor<31x!ensemble.physical_qubit>
            ensemble.apply %2 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
        }
        affine.for %arg1 = 0 to 3 {
          affine.for %arg2 = 1 to 3 {
            %7 = arith.index_cast %arg1 : index to i32
            %8 = arith.index_cast %arg2 : index to i32
            %9 = arith.muli %7, %c9_i32 : i32
            %10 = arith.addi %9, %8 : i32
            %11 = arith.index_cast %10 : i32 to index
            %12 = arith.addi %10, %c4_i32 : i32
            %13 = arith.index_cast %12 : i32 to index
            %extracted = tensor.extract %0[%11] : tensor<31x!ensemble.physical_qubit>
            %extracted_3 = tensor.extract %0[%13] : tensor<31x!ensemble.physical_qubit>
            ensemble.apply %3 %extracted, %extracted_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
        }
        affine.for %arg1 = 0 to 3 {
          affine.for %arg2 = 1 to 3 {
            %7 = arith.index_cast %arg1 : index to i32
            %8 = arith.index_cast %arg2 : index to i32
            %9 = arith.muli %7, %c9_i32 : i32
            %10 = arith.addi %9, %8 : i32
            %11 = arith.index_cast %10 : i32 to index
            %12 = arith.addi %10, %c5_i32 : i32
            %13 = arith.index_cast %12 : i32 to index
            %extracted = tensor.extract %0[%11] : tensor<31x!ensemble.physical_qubit>
            %extracted_3 = tensor.extract %0[%13] : tensor<31x!ensemble.physical_qubit>
            ensemble.apply %3 %extracted, %extracted_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
        }
        affine.for %arg1 = 0 to 3 {
          %7 = arith.index_cast %arg1 : index to i32
          %8 = arith.muli %7, %c9_i32 : i32
          %9 = arith.addi %8, %c4_i32 : i32
          %10 = arith.addi %8, %c3_i32 : i32
          %11 = arith.addi %8, %c8_i32 : i32
          %12 = arith.addi %8, %c5_i32 : i32
          %13 = arith.addi %8, %c10_i32 : i32
          %14 = arith.addi %8, %c7_i32 : i32
          %15 = arith.addi %8, %c11_i32 : i32
          %16 = arith.index_cast %8 : i32 to index
          %17 = arith.index_cast %9 : i32 to index
          %18 = arith.index_cast %10 : i32 to index
          %19 = arith.index_cast %11 : i32 to index
          %20 = arith.index_cast %12 : i32 to index
          %21 = arith.index_cast %13 : i32 to index
          %22 = arith.index_cast %14 : i32 to index
          %23 = arith.index_cast %15 : i32 to index
          %extracted = tensor.extract %0[%16] : tensor<31x!ensemble.physical_qubit>
          %extracted_3 = tensor.extract %0[%17] : tensor<31x!ensemble.physical_qubit>
          %extracted_4 = tensor.extract %0[%18] : tensor<31x!ensemble.physical_qubit>
          %extracted_5 = tensor.extract %0[%19] : tensor<31x!ensemble.physical_qubit>
          %extracted_6 = tensor.extract %0[%20] : tensor<31x!ensemble.physical_qubit>
          %extracted_7 = tensor.extract %0[%21] : tensor<31x!ensemble.physical_qubit>
          %extracted_8 = tensor.extract %0[%22] : tensor<31x!ensemble.physical_qubit>
          %extracted_9 = tensor.extract %0[%23] : tensor<31x!ensemble.physical_qubit>
          ensemble.apply %3 %extracted, %extracted_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          ensemble.apply %3 %extracted_4, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          ensemble.apply %3 %extracted_6, %extracted_7 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          ensemble.apply %3 %extracted_8, %extracted_9 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        }
        affine.for %arg1 = 0 to 3 {
          %7 = arith.index_cast %arg1 : index to i32
          %8 = arith.muli %7, %c9_i32 : i32
          %9 = arith.addi %8, %c5_i32 : i32
          %10 = arith.addi %8, %c3_i32 : i32
          %11 = arith.addi %8, %c7_i32 : i32
          %12 = arith.index_cast %8 : i32 to index
          %13 = arith.index_cast %9 : i32 to index
          %14 = arith.index_cast %10 : i32 to index
          %15 = arith.index_cast %11 : i32 to index
          %extracted = tensor.extract %0[%12] : tensor<31x!ensemble.physical_qubit>
          %extracted_3 = tensor.extract %0[%13] : tensor<31x!ensemble.physical_qubit>
          %extracted_4 = tensor.extract %0[%14] : tensor<31x!ensemble.physical_qubit>
          %extracted_5 = tensor.extract %0[%15] : tensor<31x!ensemble.physical_qubit>
          ensemble.apply %3 %extracted, %extracted_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          ensemble.apply %3 %extracted_4, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        }
        affine.for %arg1 = 0 to 3 {
          %7 = arith.index_cast %arg1 : index to i32
          %8 = arith.muli %7, %c9_i32 : i32
          %9 = arith.addi %8, %c4_i32 : i32
          %10 = arith.addi %8, %c9_i32 : i32
          %11 = arith.addi %8, %c8_i32 : i32
          %12 = arith.addi %8, %c12_i32 : i32
          %13 = arith.index_cast %9 : i32 to index
          %14 = arith.index_cast %10 : i32 to index
          %15 = arith.index_cast %11 : i32 to index
          %16 = arith.index_cast %12 : i32 to index
          %extracted = tensor.extract %0[%13] : tensor<31x!ensemble.physical_qubit>
          %extracted_3 = tensor.extract %0[%14] : tensor<31x!ensemble.physical_qubit>
          %extracted_4 = tensor.extract %0[%15] : tensor<31x!ensemble.physical_qubit>
          %extracted_5 = tensor.extract %0[%16] : tensor<31x!ensemble.physical_qubit>
          ensemble.apply %3 %extracted, %extracted_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          ensemble.apply %3 %extracted_4, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        }
        affine.for %arg1 = 0 to 9 {
          %extracted = tensor.extract %cst_2[%arg1] : tensor<9xi32>
          %7 = arith.index_cast %extracted : i32 to index
          %extracted_3 = tensor.extract %0[%7] : tensor<31x!ensemble.physical_qubit>
          %extracted_4 = tensor.extract %1[%arg1] : tensor<31x!ensemble.cbit>
          %8 = ensemble.gate_distribution %4, %2, %5 : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
          %9 = ensemble.gate_distribution %4, %4, %2 : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
          %extracted_5 = tensor.extract %6[%arg1] : tensor<9xi32>
          %10 = arith.index_cast %extracted_5 : i32 to index
          ensemble.apply_distribution %8[%10] {"cannot-merge"} %extracted_3 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
          ensemble.apply_distribution %9[%10] {"cannot-merge"} %extracted_3 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
          ensemble.measure %extracted_3, %extracted_4 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        ensemble.transmit_results %1 : (tensor<31x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

