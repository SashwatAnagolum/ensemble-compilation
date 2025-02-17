module {
  func.func @main() {
    %cst = arith.constant 6.2831853071795862 : f64
    %cst_0 = arith.constant 0.000000e+00 : f64
    %cst_1 = arith.constant 3.1415926535897931 : f64
    %cst_2 = arith.constant 1.5707963267948966 : f64
    %cst_3 = arith.constant dense<[0, 1, 2, 3, 4, 5, 6, 7, 8]> : tensor<9xi32>
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = ensemble.program_alloc 21 : () -> tensor<21x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 21 : () -> tensor<21x!ensemble.cbit>
    affine.for %arg0 = 0 to 9 {
      %extracted = tensor.extract %cst_3[%arg0] : tensor<9xi32>
      %2 = arith.index_cast %extracted : i32 to index
      %3 = ensemble.gate "U3" 1(%cst_2, %cst_0, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %4 = ensemble.gate "CX" 2 {"nativized-peeked"} : () -> !ensemble.gate
      %5 = ensemble.gate "CX" "inverse" 2 {"nativized-peeked"} : () -> !ensemble.gate
      ensemble.quantum_program_iteration {
        ensemble.reset_tensor %0 : (tensor<21x!ensemble.physical_qubit>) -> ()
        affine.for %arg1 = 0 to 21 {
          %extracted_4 = tensor.extract %0[%arg1] : tensor<21x!ensemble.physical_qubit>
          ensemble.apply %3 {"cannot-merge"} %extracted_4 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          scf.for %arg2 = %c0 to %2 step %c1 {
            %6 = ensemble.gate "U3" "inverse" 1(%cst_1, %cst_0, %cst) {"generated-by-merging", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
            ensemble.apply %6 {"cannot-merge"} %extracted_4 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
        }
        affine.for %arg1 = 0 to 20 {
          %extracted_4 = tensor.extract %0[%arg1] : tensor<21x!ensemble.physical_qubit>
          %6 = arith.addi %arg1, %c1 : index
          %extracted_5 = tensor.extract %0[%6] : tensor<21x!ensemble.physical_qubit>
          ensemble.apply %4 %extracted_4, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          scf.for %arg2 = %c0 to %2 step %c1 {
            ensemble.apply %4 %extracted_4, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply %5 %extracted_4, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
        }
        affine.for %arg1 = 0 to 21 {
          %extracted_4 = tensor.extract %0[%arg1] : tensor<21x!ensemble.physical_qubit>
          %extracted_5 = tensor.extract %1[%arg1] : tensor<21x!ensemble.cbit>
          ensemble.measure %extracted_4, %extracted_5 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        ensemble.transmit_results %1 : (tensor<21x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

