

module {
  func.func @iteration_body(%circuit_index: index, %beta_values: tensor<8xf64>, %gamma_values: tensor<8xf64>, %qubits: tensor<8x!ensemble.physical_qubit>, %bits: tensor<8x!ensemble.cbit>) {
    %p_noisy_gate_probabilities = arith.constant dense<[0.97, 0.01, 0.01, 0.01]> : tensor<4xf64>
    %zero = arith.constant 0 : i32
    %zero_index = arith.constant 0 : index
    %one_index = arith.constant 1 : index
    %eight = arith.constant 8 : i32
    %fourteen = arith.constant 14 : i32
    %two = arith.constant 2 : i32
    %p_noisy_gate_choices = ensemble.int_categorical %zero, %p_noisy_gate_probabilities, [%eight, %eight, %two] : (i32, tensor<4xf64>, i32, i32, i32) -> tensor<8x8x2xi32>
    %cx_noisy_gate_probabilities = arith.constant dense<[0.92, 0.04, 0.04]> : tensor<3xf64>
    %cx_noisy_gate_choices = ensemble.int_categorical %zero, %cx_noisy_gate_probabilities, [%eight, %fourteen] : (i32, tensor<3xf64>, i32, i32) -> tensor<8x14xi32>
    %S = ensemble.gate "S" 1 : () -> !ensemble.gate
    %X = ensemble.gate "X" 1 : () -> !ensemble.gate
    %Z = ensemble.gate "Z" 1 : () -> !ensemble.gate
    %P = ensemble.gate "P" 1 : () -> !ensemble.gate
    %XX = ensemble.gate "XX" 1 : () -> !ensemble.gate

    %PXZXX = ensemble.gate_distribution %P, %X, %Z, %XX : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    %CX = ensemble.gate "CX" 2 : () -> !ensemble.gate

    ensemble.reset_tensor %qubits : (tensor<8x!ensemble.physical_qubit>) -> ()

    %eight_index = arith.constant 8 : index
    %seven_index = arith.constant 7 : index
    %hundred_index = arith.constant 100 : index

    scf.for %i = %zero_index to %eight_index step %one_index {
      scf.for %j = %zero_index to %eight_index step %one_index {
        %qubit_j = tensor.extract %qubits[%j] : tensor<8x!ensemble.physical_qubit>
        ensemble.apply %S %qubit_j : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        %p_noisy_gate_choice_0 = tensor.extract %p_noisy_gate_choices[%i, %j, %zero_index] : tensor<8x8x2xi32>
        ensemble.apply_distribution %PXZXX[%p_noisy_gate_choice_0] %qubit_j : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

        %rotation_z_amount = tensor.extract %beta_values[%i] : tensor<8xf64>
        %rz_gate = ensemble.gate "RZ" 1 (%rotation_z_amount) : (f64) -> !ensemble.gate
        ensemble.apply %rz_gate %qubit_j : (!ensemble.gate, !ensemble.physical_qubit) -> ()

        %p_noisy_gate_choice_1 = tensor.extract %p_noisy_gate_choices[%i, %j, %one_index] : tensor<8x8x2xi32>
        ensemble.apply_distribution %PXZXX[%p_noisy_gate_choice_1] %qubit_j : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()

        ensemble.apply %S %qubit_j : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      }
      scf.for %j = %zero_index to %seven_index step %one_index {
        %qubit_j = tensor.extract %qubits[%j] : tensor<8x!ensemble.physical_qubit>
        %j_plus_one = arith.addi %j, %one_index : index
        %qubit_j_plus_one = tensor.extract %qubits[%j_plus_one] : tensor<8x!ensemble.physical_qubit>
        ensemble.apply %CX %qubit_j, %qubit_j_plus_one : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

        %rotation_z_amount = tensor.extract %gamma_values[%i] : tensor<8xf64>
        %rz_gate = ensemble.gate "RZ" 1 (%rotation_z_amount) : (f64) -> !ensemble.gate
        ensemble.apply %rz_gate %qubit_j_plus_one : (!ensemble.gate, !ensemble.physical_qubit) -> ()

        ensemble.apply %CX %qubit_j, %qubit_j_plus_one : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
      }
      scf.for %j = %zero_index to %eight_index step %one_index {
        %qubit_i = tensor.extract %qubits[%j] : tensor<8x!ensemble.physical_qubit>
        %cbit_i = tensor.extract %bits[%j] : tensor<8x!ensemble.cbit>
        ensemble.measure %qubit_i, %cbit_i : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
      }
    }

    return

  }

  func.func @main() {
    %beta_values = arith.constant dense<[0.21, 0.24, 0.13, 0.1, 0.8, 0.1, 0.23, 0.5]> : tensor<8xf64>
    %gamma_values = arith.constant dense<[0.1, 0.2, 0.1, 0.13, 0.5, 0.6, 0.3, 0.5]> : tensor<8xf64>
    %qubits = ensemble.program_alloc 8 : () -> tensor<8x!ensemble.physical_qubit>
    %bits = ensemble.alloc_cbits 8 : () -> tensor<8x!ensemble.cbit>
    %zero_index = arith.constant 0 : index
    %one_index = arith.constant 1 : index
    %hundred_index = arith.constant 100 : index
    scf.for %circuit_index = %zero_index to %hundred_index step %one_index {
      func.call @iteration_body(%circuit_index, %beta_values, %gamma_values, %qubits, %bits) : (index, tensor<8xf64>, tensor<8xf64>, tensor<8x!ensemble.physical_qubit>, tensor<8x!ensemble.cbit>) -> ()
    }
    return

    
  }
}