module {
  func.func @main() {
    %c20 = arith.constant 20 : index
    %c21 = arith.constant 21 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = ensemble.program_alloc 21 : () -> tensor<21x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 21 : () -> tensor<21x!ensemble.cbit>
    %2 = ensemble.gate "H" 1 {"zero-noise-peeked"} : () -> !ensemble.gate
    %3 = ensemble.gate "H" "transpose" 1 {"zero-noise-created"} : () -> !ensemble.gate
    %4 = ensemble.gate "CX" 2 {"zero-noise-peeked"} : () -> !ensemble.gate
    %5 = ensemble.gate "CX" "transpose" 2 {"zero-noise-created"} : () -> !ensemble.gate
    affine.for %arg0 = 0 to 8 {
      ensemble.quantum_program_iteration {
        ensemble.reset_tensor %0 : (tensor<21x!ensemble.physical_qubit>) -> ()
        scf.for %arg1 = %c0 to %c21 step %c1 {
          %extracted = tensor.extract %0[%arg1] : tensor<21x!ensemble.physical_qubit>
          ensemble.apply %2 {"zero-noise-peeked"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          scf.for %arg2 = %c0 to %arg0 step %c1 {
            ensemble.apply %2 {"zero-noise-created"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %3 {"zero-noise-created"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
        }
        scf.for %arg1 = %c0 to %c20 step %c1 {
          %extracted = tensor.extract %0[%arg1] : tensor<21x!ensemble.physical_qubit>
          %6 = arith.addi %arg1, %c1 : index
          %extracted_0 = tensor.extract %0[%6] : tensor<21x!ensemble.physical_qubit>
          ensemble.apply %4 {"zero-noise-peeked"} %extracted, %extracted_0 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          scf.for %arg2 = %c0 to %arg0 step %c1 {
            ensemble.apply %4 {"zero-noise-created"} %extracted, %extracted_0 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply %5 {"zero-noise-created"} %extracted, %extracted_0 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
        }
        scf.for %arg1 = %c0 to %c21 step %c1 {
          %extracted = tensor.extract %0[%arg1] : tensor<21x!ensemble.physical_qubit>
          %extracted_0 = tensor.extract %1[%arg1] : tensor<21x!ensemble.cbit>
          ensemble.measure %extracted, %extracted_0 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        ensemble.transmit_results %1 : (tensor<21x!ensemble.cbit>) -> ()
      } {"zero-noise-peeked"}
    }
    return
  }
}

