module {
  func.func @iteration_body(%arg0: index, %arg1: tensor<21x!ensemble.physical_qubit>, %arg2: tensor<21x!ensemble.cbit>) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant dense<[0, 1, 2, 3, 4, 5, 6, 7, 8]> : tensor<9xi32>
    %extracted = tensor.extract %cst[%arg0] : tensor<9xi32>
    %0 = arith.index_cast %extracted : i32 to index
    ensemble.reset_tensor %arg1 : (tensor<21x!ensemble.physical_qubit>) -> ()
    %1 = ensemble.gate "H" 1 : () -> !ensemble.gate
    %2 = ensemble.gate "H" "inverse" 1 : () -> !ensemble.gate
    %3 = ensemble.gate "CX" 2 : () -> !ensemble.gate
    %4 = ensemble.gate "CX" "inverse" 2 : () -> !ensemble.gate
    affine.for %arg3 = 0 to 21 {
      %extracted_0 = tensor.extract %arg1[%arg3] : tensor<21x!ensemble.physical_qubit>
      ensemble.apply %1 %extracted_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      scf.for %arg4 = %c0 to %0 step %c1 {
        ensemble.apply %1 %extracted_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        ensemble.apply %2 %extracted_0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      }
    }
    affine.for %arg3 = 0 to 20 {
      %extracted_0 = tensor.extract %arg1[%arg3] : tensor<21x!ensemble.physical_qubit>
      %5 = arith.addi %arg3, %c1 : index
      %extracted_1 = tensor.extract %arg1[%5] : tensor<21x!ensemble.physical_qubit>
      ensemble.apply %3 %extracted_0, %extracted_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
      scf.for %arg4 = %c0 to %0 step %c1 {
        ensemble.apply %3 %extracted_0, %extracted_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply %4 %extracted_0, %extracted_1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
      }
    }
    affine.for %arg3 = 0 to 21 {
      %extracted_0 = tensor.extract %arg1[%arg3] : tensor<21x!ensemble.physical_qubit>
      %extracted_1 = tensor.extract %arg2[%arg3] : tensor<21x!ensemble.cbit>
      ensemble.measure %extracted_0, %extracted_1 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
    }
    return
  }
  func.func @main() {
    %0 = ensemble.program_alloc 21 : () -> tensor<21x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 21 : () -> tensor<21x!ensemble.cbit>
    affine.for %arg0 = 0 to 9 {
      func.call @iteration_body(%arg0, %0, %1) : (index, tensor<21x!ensemble.physical_qubit>, tensor<21x!ensemble.cbit>) -> ()
    }
    return
  }
}

