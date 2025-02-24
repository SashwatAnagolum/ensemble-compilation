module {
  func.func @main() {
    %cst = arith.constant 3.1415926535897931 : f64
    %cst_0 = arith.constant 1.5707963267948966 : f64
    %cst_1 = arith.constant 0.000000e+00 : f64
    %c16_i32 = arith.constant 16 : i32
    %c4_i32 = arith.constant 4 : i32
    %c0_i32 = arith.constant 0 : i32
    %c2 = arith.constant 2 : index
    %c3 = arith.constant 3 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = ensemble.program_alloc 16 : () -> tensor<16x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 16 : () -> tensor<16x!ensemble.cbit>
    affine.for %arg0 = 0 to 1000 {
      %2 = ensemble.int_uniform %c0_i32, %c4_i32, [%c4_i32, %c16_i32] : (i32, i32, i32, i32) -> tensor<4x16xi32>
      %3 = ensemble.gate "U3" 1(%cst_0, %cst_1, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %4 = ensemble.gate "CX" 2 {"nativized-peeked"} : () -> !ensemble.gate
      %5 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      ensemble.quantum_program_iteration {
        ensemble.reset_tensor %0 : (tensor<16x!ensemble.physical_qubit>) -> ()
        affine.for %arg1 = 0 to 16 {
          %extracted = tensor.extract %0[%arg1] : tensor<16x!ensemble.physical_qubit>
          ensemble.apply %3 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        }
        affine.for %arg1 = 0 to 15 {
          %extracted = tensor.extract %0[%arg1] : tensor<16x!ensemble.physical_qubit>
          %6 = arith.addi %arg1, %c1 : index
          %extracted_2 = tensor.extract %0[%6] : tensor<16x!ensemble.physical_qubit>
          ensemble.apply %4 %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          %extracted_3 = tensor.extract %2[%c0, %arg1] : tensor<4x16xi32>
          %7 = arith.index_cast %extracted_3 : i32 to index
          scf.for %arg2 = %c0 to %7 step %c1 {
            ensemble.apply %5 {"cannot-merge"} %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
          ensemble.apply %4 %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        }
        affine.for %arg1 = 0 to 16 {
          %extracted = tensor.extract %0[%arg1] : tensor<16x!ensemble.physical_qubit>
          %6 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst_0) {"generated-by-merging", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
          ensemble.apply %6 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          %extracted_2 = tensor.extract %2[%c1, %arg1] : tensor<4x16xi32>
          %7 = arith.index_cast %extracted_2 : i32 to index
          scf.for %arg2 = %c0 to %7 step %c1 {
            ensemble.apply %5 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
          %8 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst_0) {"generated-by-merging", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
          ensemble.apply %8 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        }
        affine.for %arg1 = 0 to 15 {
          %extracted = tensor.extract %0[%arg1] : tensor<16x!ensemble.physical_qubit>
          %6 = arith.addi %arg1, %c1 : index
          %extracted_2 = tensor.extract %0[%6] : tensor<16x!ensemble.physical_qubit>
          ensemble.apply %4 %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          %extracted_3 = tensor.extract %2[%c2, %arg1] : tensor<4x16xi32>
          %7 = arith.index_cast %extracted_3 : i32 to index
          scf.for %arg2 = %c0 to %7 step %c1 {
            ensemble.apply %5 {"cannot-merge"} %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
          ensemble.apply %4 %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        }
        affine.for %arg1 = 0 to 16 {
          %extracted = tensor.extract %0[%arg1] : tensor<16x!ensemble.physical_qubit>
          %6 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst_0) {"generated-by-merging", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
          ensemble.apply %6 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          %extracted_2 = tensor.extract %2[%c3, %arg1] : tensor<4x16xi32>
          %7 = arith.index_cast %extracted_2 : i32 to index
          scf.for %arg2 = %c0 to %7 step %c1 {
            ensemble.apply %5 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
          %8 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst_0) {"generated-by-merging", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
          ensemble.apply %8 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          %extracted_3 = tensor.extract %1[%arg1] : tensor<16x!ensemble.cbit>
          ensemble.measure %extracted, %extracted_3 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        ensemble.transmit_results %1 : (tensor<16x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

