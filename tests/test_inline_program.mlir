module {
  
  func.func private @iteration_body(%qubits: tensor<8 x !ensemble.physical_qubit>, %cbits: tensor<9 x !ensemble.cbit>, %circuit_index : i32) {

    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c8 = arith.constant 8 : index

    // Initialize first qubit in superposition
    %q0 = tensor.extract %qubits[%c0] : tensor<8x!ensemble.physical_qubit>
    %H = ensemble.gate "H" 1 : () -> !ensemble.gate
    ensemble.apply %H %q0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

    // Create GHZ state with CNOTs between adjacent qubits
    %CX = ensemble.gate "CX" 2 : () -> !ensemble.gate
    scf.for %i = %c0 to %c8 step %c1 {
      %next = arith.addi %i, %c1 : index
      %in_bounds = arith.cmpi slt, %next, %c8 : index
      scf.if %in_bounds {
        %control = tensor.extract %qubits[%i] : tensor<8x!ensemble.physical_qubit>
        %target = tensor.extract %qubits[%next] : tensor<8x!ensemble.physical_qubit>
        ensemble.apply %CX %control, %target : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
      }
    }

    // Measure all qubits
    scf.for %i = %c0 to %c8 step %c1 {
      %q = tensor.extract %qubits[%i] : tensor<8x!ensemble.physical_qubit>
      %b = tensor.extract %cbits[%i] : tensor<9x!ensemble.cbit>
      ensemble.measure %q, %b : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
    }
    return
  }

  func.func @main() {
    %qubits = ensemble.program_alloc 8 : () -> (tensor<8 x !ensemble.physical_qubit>)
    %cbits = ensemble.alloc_cbits 9 : () -> (tensor<9 x !ensemble.cbit>)
    %c0 = arith.constant 0 : index
    %c1000 = arith.constant 1000 : index
    %c1 = arith.constant 1 : index
    %c0i32 = arith.constant 0 : i32
    
    scf.for %circuit_index = %c0 to %c1000 step %c1 {
        %circuit_index_i32 = arith.index_cast %circuit_index : index to i32
        func.call @iteration_body(%qubits, %cbits, %circuit_index_i32) : (tensor<8 x !ensemble.physical_qubit>, tensor<9 x !ensemble.cbit>, i32) -> ()
    }
    return
  }
}
