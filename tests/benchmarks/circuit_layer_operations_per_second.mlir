module {
  func.func private @iteration_body(%qubits: tensor<8x!ensemble.physical_qubit>, %bits: tensor<8x!ensemble.cbit>, %circuit_index: i32, %num_qubits: i32, %connectivity: !ensemble.connectivity_graph) -> () {
    %zero_index = arith.constant 0 : index
    %one_index = arith.constant 1 : index
    %two_index = arith.constant 2 : index
    %num_qubits_index = arith.index_cast %num_qubits : i32 to index
    %two = arith.constant 2 : i32
    %half_num_qubits = arith.divsi %num_qubits, %two : i32

    // precomputed values before circuit sampling
    %pi = arith.constant 3.14159265359 : f64
    %zero_const_float = arith.constant 0.0 : f64
    %two_pi_const_float = arith.constant 6.28318530718 : f64

    %cnot_pairs = ensemble.cnot_pair_distribution %connectivity, [%num_qubits, %half_num_qubits] : (!ensemble.connectivity_graph, i32, i32) -> tensor<8x4x2x!ensemble.physical_qubit>
    %rotation_angles = ensemble.float_uniform %zero_const_float, %two_pi_const_float, [%num_qubits, %num_qubits] : (f64, f64, i32, i32) -> tensor<8x8xf64>

    ensemble.quantum_program_iteration {
      ensemble.reset_tensor %qubits : (tensor<8x!ensemble.physical_qubit>) -> ()

      scf.for %i = %zero_index to %num_qubits_index step %one_index {
        scf.for %j = %zero_index to %num_qubits_index step %two_index {
          %q0 = tensor.extract %cnot_pairs[%i, %j, %zero_index] : tensor<8x4x2x!ensemble.physical_qubit>
          %q1 = tensor.extract %cnot_pairs[%i, %j, %one_index] : tensor<8x4x2x!ensemble.physical_qubit>
          %cx_gate = ensemble.gate "CX" 2 : () -> !ensemble.gate
          ensemble.apply %cx_gate %q0, %q1 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        }

        scf.for %j = %zero_index to %num_qubits_index step %one_index {
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

      scf.for %i = %zero_index to %num_qubits_index step %one_index {
        %qubit = tensor.extract %qubits[%i] : tensor<8x!ensemble.physical_qubit>
        %bit = tensor.extract %bits[%i] : tensor<8x!ensemble.cbit>
        ensemble.measure %qubit, %bit : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
      }
      ensemble.transmit_results %bits : (tensor<8x!ensemble.cbit>) -> ()
    }
    return
  }

  func.func @main() -> () {
    %num_circuits = arith.constant 100 : i32
    %num_qubits = arith.constant 8 : i32
    %qubits = ensemble.program_alloc 8 : () -> tensor<8x!ensemble.physical_qubit>
    %bits = ensemble.alloc_cbits 8 : () -> tensor<8x!ensemble.cbit>

    %zero_index = arith.constant 0 : index
    %one_index = arith.constant 1 : index
    %num_circuits_index = arith.index_cast %num_circuits : i32 to index
    %num_qubits_index = arith.index_cast %num_qubits : i32 to index
    %connectivity = ensemble.device_connectivity %qubits, {dense<[[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 0]]> : tensor<8x2xi32> }: (tensor<8x!ensemble.physical_qubit>) -> !ensemble.connectivity_graph

    scf.for %i = %zero_index to %num_circuits_index step %one_index {
      %circuit_index = arith.index_cast %i : index to i32
      func.call @iteration_body(%qubits, %bits, %circuit_index, %num_qubits, %connectivity) : (tensor<8x!ensemble.physical_qubit>, tensor<8x!ensemble.cbit>, i32, i32, !ensemble.connectivity_graph) -> ()
    }
    return
  }
}
