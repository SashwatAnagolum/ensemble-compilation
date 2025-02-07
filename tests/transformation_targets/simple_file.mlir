module {
  func.func @main() {
    %c0 = arith.constant 0 : index
    %c10 = arith.constant 10 : index
    %c1 = arith.constant 1 : index
    %0 = ensemble.program_alloc 10 : () -> tensor<10x!ensemble.physical_qubit>

    scf.for %i = %c0 to %c10 step %c1 {
      // Loop body
      %qubit = tensor.extract %0[%i] : tensor<10x!ensemble.physical_qubit>
      ensemble.reset %qubit : (!ensemble.physical_qubit) -> ()
    }

    // Second loop for CNOTs between every pair of qubits
    scf.for %i = %c0 to %c10 step %c1 {
      scf.for %j = %c0 to %c10 step %c1 {
        %qubit_i = tensor.extract %0[%i] : tensor<10x!ensemble.physical_qubit>
        %qubit_j = tensor.extract %0[%j] : tensor<10x!ensemble.physical_qubit>
        %cnot_gate = ensemble.gate "CNOT" 2 : () -> !ensemble.gate
        ensemble.apply %cnot_gate %qubit_i, %qubit_j : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
      }
    }
  
    return
  }
}
