module {
  func.func @main() {
    %c20 = arith.constant 20 : index
    %c21 = arith.constant 21 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = ensemble.program_alloc 21 : () -> tensor<21x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 21 : () -> tensor<21x!ensemble.cbit>
    %2 = ensemble.gate "H" 1 : () -> !ensemble.gate
    %3 = ensemble.gate "CX" 2 : () -> !ensemble.gate
    ensemble.quantum_program_iteration {
      ensemble.reset_tensor %0 : (tensor<21x!ensemble.physical_qubit>) -> ()
      scf.for %arg0 = %c0 to %c21 step %c1 {
        %extracted = tensor.extract %0[%arg0] : tensor<21x!ensemble.physical_qubit>
        ensemble.apply %2 %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      }
      scf.for %arg0 = %c0 to %c20 step %c1 {
        %extracted = tensor.extract %0[%arg0] : tensor<21x!ensemble.physical_qubit>
        %4 = arith.addi %arg0, %c1 : index
        %extracted_0 = tensor.extract %0[%4] : tensor<21x!ensemble.physical_qubit>
        ensemble.apply %3 %extracted, %extracted_0 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
      }
      scf.for %arg0 = %c0 to %c21 step %c1 {
        %extracted = tensor.extract %0[%arg0] : tensor<21x!ensemble.physical_qubit>
        %extracted_0 = tensor.extract %1[%arg0] : tensor<21x!ensemble.cbit>
        ensemble.measure %extracted, %extracted_0 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
      }
      ensemble.transmit_results %1 : (tensor<21x!ensemble.cbit>) -> ()
    }
    return
  }
}

