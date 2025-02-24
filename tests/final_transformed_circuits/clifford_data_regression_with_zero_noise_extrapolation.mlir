module {
  func.func @main() {
    %cst = arith.constant 3.1415926535897931 : f64
    %cst_0 = arith.constant 1.5707963267948966 : f64
    %cst_1 = arith.constant 0.000000e+00 : f64
    %c2 = arith.constant 2 : index
    %c8_i32 = arith.constant 8 : i32
    %c4_i32 = arith.constant 4 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = ensemble.program_alloc 16 : () -> tensor<16x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 16 : () -> tensor<16x!ensemble.cbit>
    affine.for %arg0 = 0 to 5 {
      affine.for %arg1 = 0 to 100 {
        %2 = ensemble.int_uniform %c0_i32, %c4_i32, [%c8_i32, %c8_i32] : (i32, i32, i32, i32) -> tensor<4x8xi32>
        %3 = ensemble.gate "U3" 1(%cst_0, %cst_1, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %4 = ensemble.gate "CX" 2 {"nativized-peeked"} : () -> !ensemble.gate
        %5 = ensemble.gate "U3" "inverse" 1(%cst_0, %cst_1, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %6 = ensemble.gate "CX" "inverse" 2 {"nativized-peeked"} : () -> !ensemble.gate
        %7 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %8 = ensemble.gate "U3" "inverse" 1(%cst_1, %cst_1, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %9 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %10 = ensemble.gate "U3" "inverse" 1(%cst_1, %cst_1, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        ensemble.quantum_program_iteration {
          ensemble.reset_tensor %0 : (tensor<16x!ensemble.physical_qubit>) -> ()
          affine.for %arg2 = 0 to 8 {
            %extracted = tensor.extract %0[%arg2] : tensor<16x!ensemble.physical_qubit>
            ensemble.apply %3 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            scf.for %arg3 = %c0 to %arg0 step %c1 {
              ensemble.apply %3 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              ensemble.apply %5 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            }
          }
          affine.for %arg2 = 0 to 4 {
            %11 = arith.muli %arg2, %c2 : index
            affine.for %arg3 = 0 to 7 {
              %extracted = tensor.extract %0[%arg3] : tensor<16x!ensemble.physical_qubit>
              %12 = arith.addi %arg3, %c1 : index
              %extracted_2 = tensor.extract %0[%12] : tensor<16x!ensemble.physical_qubit>
              ensemble.apply %4 {"cannot-merge"} %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
              scf.for %arg4 = %c0 to %arg0 step %c1 {
                ensemble.apply %4 {"cannot-merge"} %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                ensemble.apply %6 {"cannot-merge"} %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
              }
              %extracted_3 = tensor.extract %2[%11, %arg3] : tensor<4x8xi32>
              %13 = arith.index_cast %extracted_3 : i32 to index
              scf.for %arg4 = %c0 to %13 step %c1 {
                ensemble.apply %7 {"cannot-merge"} %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                ensemble.apply %8 {"cannot-merge"} %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              }
            }
            affine.for %arg3 = 0 to 8 {
              %extracted = tensor.extract %0[%arg3] : tensor<16x!ensemble.physical_qubit>
              ensemble.apply %7 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              scf.for %arg4 = %c0 to %arg0 step %c1 {
                ensemble.apply %7 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                ensemble.apply %8 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              }
              ensemble.apply %9 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              scf.for %arg4 = %c0 to %arg0 step %c1 {
                ensemble.apply %9 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                ensemble.apply %10 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              }
              %12 = arith.addi %11, %c1 : index
              %extracted_2 = tensor.extract %2[%12, %arg3] : tensor<4x8xi32>
              %13 = arith.index_cast %extracted_2 : i32 to index
              scf.for %arg4 = %c0 to %13 step %c1 {
                ensemble.apply %7 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                scf.for %arg5 = %c0 to %arg0 step %c1 {
                  ensemble.apply %7 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                  ensemble.apply %8 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                }
              }
              ensemble.apply %9 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              scf.for %arg4 = %c0 to %arg0 step %c1 {
                ensemble.apply %9 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                ensemble.apply %10 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              }
              ensemble.apply %7 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              scf.for %arg4 = %c0 to %arg0 step %c1 {
                ensemble.apply %7 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                ensemble.apply %8 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              }
            }
          }
          affine.for %arg2 = 0 to 8 {
            %extracted = tensor.extract %0[%arg2] : tensor<16x!ensemble.physical_qubit>
            %extracted_2 = tensor.extract %1[%arg2] : tensor<16x!ensemble.cbit>
            ensemble.measure %extracted, %extracted_2 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
          }
          ensemble.transmit_results %1 : (tensor<16x!ensemble.cbit>) -> ()
        }
      }
    }
    return
  }
}

