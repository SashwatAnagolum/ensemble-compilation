module {
  func.func @main(%arg0: !ensemble.physical_qubit, %arg1: !ensemble.physical_qubit, %cbits: tensor<2 x !ensemble.cbit>) -> !ensemble.physical_qubit {
    // sample an int in [0, 2]
    // Test ApplyGateDistribution verifier
    ensemble.reset %arg0 : (!ensemble.physical_qubit) -> ()
    ensemble.reset %arg1 : (!ensemble.physical_qubit) -> ()
    
    // Create two 2-qubit gates
    %czgate = ensemble.gate "CZ" 2 : () -> (!ensemble.gate)
    %cxgate = ensemble.gate "CX" 2 : () -> (!ensemble.gate)
    %hgate = ensemble.gate "H" 1 : () -> (!ensemble.gate)

    
    // TESTING VERIFIERS, correct first, then incorrect


    // Create a random index
    // TEST ONE: testing that integer distribution verifier works, low bound >= high bound
    %index = ensemble.int_uniform 0, 1, [1] : () -> tensor<1xi32>
    // %index = ensemble.int_uniform 1, 0, [1] : () -> tensor<1xi32>
    
    %c0 = arith.constant 0 : index
    %idx = tensor.extract %index[%c0] : tensor<1xi32>

    // TEST TWO: testing that the gate distribution verifier works. This tests that the gates used in the distribution have the same number of qubits as the gate constructor
    %gates = ensemble.gate_distribution %czgate, %cxgate : (!ensemble.gate, !ensemble.gate) -> (!ensemble.gate_distribution)
    // %gates = ensemble.gate_distribution %hgate, %cxgate : (!ensemble.gate, !ensemble.gate) -> (!ensemble.gate_distribution)

    // TEST THREE: testing number of inputs matches number of outputs
    ensemble.apply_distribution %gates [%idx] %arg0, %arg1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
    // ensemble.apply_distribution %gates [%idx] %arg0, %arg1 : (tensor<2x!ensemble.gate>, i32, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
    
    // TEST FOUR: testing that number of operands matches number of qubits in the gate constructor
    ensemble.apply %czgate %arg0, %arg1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
    // ensemble.apply %czgate %arg0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()

    // TEST FIVE: test that when applying a gate distribution, the number of qubits in each of the gate constructors matches the number of qubits in the distribution
    ensemble.apply_distribution %gates [%idx] %arg0, %arg1 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
    // ensemble.apply_distribution %gates [%idx] %arg0 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

    // TEST SIX: testing that the cnot pair distribution verifier works
    %connectivity = tensor.from_elements %arg0, %arg1 : tensor<1 x 2 x !ensemble.physical_qubit>
    %cnot_pair_distribution = ensemble.cnot_pair_distribution %connectivity, 1 : (tensor<1 x 2 x !ensemble.physical_qubit>) -> tensor<1 x 2 x !ensemble.physical_qubit>
    
    // %connectivity = tensor.from_elements %arg0, %arg1 : tensor<2 x 1 x !ensemble.physical_qubit>
    // %cnot_pair_distribution = ensemble.cnot_pair_distribution %connectivity, 1 : (tensor<2 x 1 x !ensemble.physical_qubit>) -> tensor<1 x 2 x !ensemble.physical_qubit>
    return %arg0 : !ensemble.physical_qubit
  }
}
