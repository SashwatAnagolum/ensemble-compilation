module {
  func.func @main(%circuit_index: i32) {
    // deterministic inputs
    // num_circuits = 100;
    // connectivity = [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 0]];
    // num_qubits = 8;
    %num_circuits = arith.constant 100 : i32
    %num_qubits = arith.constant 8 : i32
    %num_qubits_index = arith.constant 8 : index
    %zero = arith.constant 0 : i32
    %one = arith.constant 1 : i32
    %two = arith.constant 2 : i32
    %zero_index = arith.constant 0 : index  
    %one_index = arith.constant 1 : index
    %two_index = arith.constant 2 : index
    %half_num_qubits = arith.divsi %num_qubits, %two : i32
    %qubits = ensemble.program_alloc 8 : () -> tensor<8x!ensemble.physical_qubit>


    // precomputed values before circuit sampling
    // pi = 3.14159265359;
    %pi = arith.constant 3.14159265359 : f64

    // values passed in during circuit sampling
    // global circuit_index;

    // random variables sampled every time we sample a circuit
    // cnot_pairs = random_cnot_layers(connectivity=connectivity, num_layers=num_qubits); # size (8, 4, 2)
    // rotation_angles = float_uniform(low=0, high=2 * pi, size=(num_qubits, num_qubits));
    %connectivity = tensor.empty() : tensor<8x2x!ensemble.physical_qubit>
    affine.for %i = 0 to 8 {
      %dst = arith.addi %i, %one_index : index
      // getting modulo of dst by num_qubits
      %dst_i32 = arith.index_cast %dst : index to i32
      %dst_temp = arith.divsi %dst_i32, %num_qubits : i32
      %mod = arith.subi %dst_i32, %dst_temp : i32
      %mod_index = arith.index_cast %mod : i32 to index
      %src_qubit = tensor.extract %qubits[%i] : tensor<8x!ensemble.physical_qubit>
      %dst_qubit = tensor.extract %qubits[%mod_index] : tensor<8x!ensemble.physical_qubit>
      tensor.insert %src_qubit into %connectivity[%i, %zero_index] : tensor<8x2x!ensemble.physical_qubit>
      tensor.insert %dst_qubit into %connectivity[%i, %one_index] : tensor<8x2x!ensemble.physical_qubit>
    }
    %cnot_pairs = ensemble.cnot_pair_distribution %connectivity, [%num_qubits, %half_num_qubits] : (tensor<8x2x!ensemble.physical_qubit>, i32, i32) -> tensor<8x4x2x!ensemble.physical_qubit>
    %zero_const_float = arith.constant 0.0 : f64
    %two_pi_const_float = arith.constant 6.28318530718 : f64
    %rotation_angles = ensemble.float_uniform %zero_const_float, %two_pi_const_float, [%num_qubits, %num_qubits] : (f64, f64, i32, i32) -> tensor<8x8xf64>

    // qubits and classical bits
    // qubit qubits[num_qubits];
    // bit bits[num_qubits];
    %bits = tensor.empty() : tensor<8x!ensemble.cbit>

    // circuit description - CLOPS_H circuits on an example 8 qubit device
    // with ring connectivity and RZ, X, SX, and CNOT native gates
    // reset qubits;
    ensemble.reset_tensor %qubits : (tensor<8x!ensemble.physical_qubit>) -> ()
    

    // for (i = 0; i < num_qubits; i++) {
    affine.for %i = 0 to 8 step 1 {
      // for (j = 0; j < num_qubits; j+= 2) {
      affine.for %j = 0 to 8 step 2 {
        // gate2q "CX" qubits[cnot_pairs[i][j][0]], qubits[cnot_pairs[i][j][1]];
        %q0 = tensor.extract %cnot_pairs[%i, %j, %zero_index] : tensor<8x4x2x!ensemble.physical_qubit>
        %q1 = tensor.extract %cnot_pairs[%i, %j, %one_index] : tensor<8x4x2x!ensemble.physical_qubit>
        %cx_gate = ensemble.gate "CX" 2 : () -> !ensemble.gate
        ensemble.apply %cx_gate %q0, %q1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
      }

      // for (j = 0; j < num_qubits; j++) {
      affine.for %j = 0 to 8 step 1 {
        // gate1q "RZ" (rotation_angles[i][j]) qubits[j];
        // gate1q "SX" qubits[j];
        // gate1q "X" qubits[j];
        %angle = tensor.extract %rotation_angles[%i, %j] : tensor<8x8xf64>
        %qubit = tensor.extract %qubits[%j] : tensor<8x!ensemble.physical_qubit>
        %rz_gate = ensemble.gate "RZ" 1 (%angle) : (f64) -> !ensemble.gate
        %sx_gate = ensemble.gate "SX" 1 : () -> !ensemble.gate
        %x_gate = ensemble.gate "X" 1 : () -> !ensemble.gate
        ensemble.apply %rz_gate %qubit : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        ensemble.apply %sx_gate %qubit : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        ensemble.apply %x_gate %qubit : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      }
    }

    // for (i = 0; i < num_qubits; i++) {
    affine.for %i = 0 to 8 step 1 {
      // measure qubits[i], bits[i];
      %qubit = tensor.extract %qubits[%i] : tensor<8x!ensemble.physical_qubit>
      %bit = tensor.extract %bits[%i] : tensor<8x!ensemble.cbit>
      ensemble.measure %qubit, %bit : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
      
    }
    return
  }
}
