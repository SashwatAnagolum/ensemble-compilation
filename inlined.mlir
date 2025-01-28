module {
  func.func @main() {
    %cst = arith.constant dense<[0, 1, 2, 3, 4, 5, 6, 7, 8]> : tensor<9xi32>
    %c21 = arith.constant 21 : index
    %c20 = arith.constant 20 : index
    %c1 = arith.constant 1 : index
    %c9 = arith.constant 9 : index
    %c0 = arith.constant 0 : index
    %0 = ensemble.program_alloc 21 : () -> tensor<21x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 21 : () -> tensor<21x!ensemble.cbit>
    scf.for %arg0 = %c0 to %c9 step %c1 {
      %extracted = tensor.extract %cst[%arg0] : tensor<9xi32>
      %2 = arith.index_cast %extracted : i32 to index
      %3 = ensemble.gate "H" 1 : () -> !ensemble.gate
      %4 = ensemble.gate "H" "inverse" 1 : () -> !ensemble.gate
      %5 = ensemble.gate "CX" 2 : () -> !ensemble.gate
      %6 = ensemble.gate "CX" "inverse" 2 : () -> !ensemble.gate
      ensemble.quantum_program_iteration {
        ensemble.reset_tensor %0 : (tensor<21x!ensemble.physical_qubit>) -> ()
        scf.for %arg1 = %c0 to %c21 step %c1 {
          %extracted_0 = tensor.extract %0[%arg1] : tensor<21x!ensemble.physical_qubit>
          ensemble.apply %3 %extracted_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          scf.for %arg2 = %c0 to %2 step %c1 {
            ensemble.apply %3 %extracted_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %4 %extracted_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
        }
        scf.for %arg1 = %c0 to %c20 step %c1 {
          %extracted_0 = tensor.extract %0[%arg1] : tensor<21x!ensemble.physical_qubit>
          %7 = arith.addi %arg1, %c1 : index
          %extracted_1 = tensor.extract %0[%7] : tensor<21x!ensemble.physical_qubit>
          ensemble.apply %5 %extracted_0, %extracted_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          scf.for %arg2 = %c0 to %2 step %c1 {
            ensemble.apply %5 %extracted_0, %extracted_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply %6 %extracted_0, %extracted_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
        }
        scf.for %arg1 = %c0 to %c21 step %c1 {
          %extracted_0 = tensor.extract %0[%arg1] : tensor<21x!ensemble.physical_qubit>
          %extracted_1 = tensor.extract %1[%arg1] : tensor<21x!ensemble.cbit>
          ensemble.measure %extracted_0, %extracted_1 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        ensemble.transmit_results %1 : (tensor<21x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

