module {
    func.func @quantum_volume_iteration(%circuit_index: index, %qubits: tensor<10x!ensemble.physical_qubit>, %bits: tensor<10x!ensemble.cbit>) {
        %two = arith.constant 2 : i32
        %circuit_index_i32 = arith.index_cast %circuit_index : index to i32
        %num_qubits = arith.addi %circuit_index_i32, %two : i32
        %pi = arith.constant 3.14159265359 : f64

        %qubit_pairs = ensemble.permutation %num_qubits : (i32) -> tensor<?xi32>
        %two_pi = arith.constant 6.28318530718 : f64
        %zero_f64 = arith.constant 0.0 : f64
        %four = arith.constant 4 : i32
        %three = arith.constant 3 : i32`
        %rotation_angles = ensemble.float_uniform %zero_f64, %two_pi, [%num_qubits, %num_qubits, %four, %three] : (f64, f64, i32, i32, i32, i32) -> tensor<?x?x4x3xf64>

        ensemble.reset_tensor %qubits : (tensor<10x!ensemble.physical_qubit>) -> ()
        %zero_index = arith.constant 0 : index
        %one_index = arith.constant 1 : index
        %two_index = arith.constant 2 : index
        %num_qubits_index = arith.index_cast %num_qubits : i32 to index
        scf.for %i = %zero_index to %num_qubits_index step %one_index {
            scf.for %j = %zero_index to %num_qubits_index step %two_index {
                %rotation_angle_0 = tensor.extract %rotation_angles[%i, %j, %zero_index, %zero_index] : tensor<?x?x4x3xf64>
                %rotation_angle_1 = tensor.extract %rotation_angles[%i, %j, %zero_index, %one_index] : tensor<?x?x4x3xf64>
                %rotation_angle_2 = tensor.extract %rotation_angles[%i, %j, %zero_index, %two_index] : tensor<?x?x4x3xf64>

                %U3_one = ensemble.gate "U3" 3 (%rotation_angle_0, %rotation_angle_1, %rotation_angle_2) : (f64, f64, f64) -> !ensemble.gate
                %qubit_pair_i_j = tensor.extract %qubit_pairs[%i, %j] : tensor<?xi32>
                ensemble.apply_gate %U3_one, %qubits[%qubit_pair_i_j] : (!ensemble.gate, tensor<10x!ensemble.physical_qubit>) -> ()
                
            }
        }
        return
    }

    func.func @main() {
        %qubits = ensemble.program_alloc 10 : () -> tensor<10x!ensemble.physical_qubit>
        %bits = ensemble.alloc_cbits 10 : () -> tensor<10x!ensemble.cbit>

        %zero_index = arith.constant 0 : index
        %six_index = arith.constant 6 : index 
        %one_index = arith.constant 1 : index
        scf.for %circuit_index = %zero_index to %six_index step %one_index {
            func.call @quantum_volume_iteration(%circuit_index, %qubits, %bits) : (index, tensor<10x!ensemble.physical_qubit>, tensor<10x!ensemble.cbit>) -> ()
        }
        return
    }
}
