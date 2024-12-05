module {
    func.func @iteration_body(%circuit_index: index, %qubits: tensor<21x!ensemble.physical_qubit>, %bits: tensor<21x!ensemble.cbit>) {
        %loop_repetitions = arith.constant dense<[0, 1, 2, 3, 4, 5, 6, 7, 8]> : tensor<9xi32>
        %loop_repetition = tensor.extract %loop_repetitions[%circuit_index] : tensor<9xi32>
        %loop_repetition_index = arith.index_cast %loop_repetition : i32 to index
        %zero_index = arith.constant 0 : index
        %one_index = arith.constant 1 : index

        ensemble.reset_tensor %qubits : (tensor<21x!ensemble.physical_qubit>) -> ()

        %H = ensemble.gate "H" 1 : () -> !ensemble.gate
        %Inverse_H = ensemble.gate "H" "inverse" 1 : () -> !ensemble.gate
        %CX = ensemble.gate "CX" 2 : () -> !ensemble.gate
        %Inverse_CX = ensemble.gate "CX" "inverse" 2 : () -> !ensemble.gate

        affine.for %i = 0 to 21 {
            %qubit_i = tensor.extract %qubits[%i] : tensor<21x!ensemble.physical_qubit>
            ensemble.apply %H %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()

            scf.for %j = %zero_index to %loop_repetition_index step %one_index {
                ensemble.apply %H %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
                ensemble.apply %Inverse_H %qubit_i : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            }
        }

        affine.for %i = 0 to 20 {
            %qubit_i = tensor.extract %qubits[%i] : tensor<21x!ensemble.physical_qubit>
            %i_plus_one = arith.addi %i, %one_index : index
            %qubit_i_plus_one = tensor.extract %qubits[%i_plus_one] : tensor<21x!ensemble.physical_qubit>
            ensemble.apply %CX %qubit_i, %qubit_i_plus_one : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()

            scf.for %j = %zero_index to %loop_repetition_index step %one_index {
                ensemble.apply %CX %qubit_i, %qubit_i_plus_one : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                ensemble.apply %Inverse_CX %qubit_i, %qubit_i_plus_one : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }
        }

        affine.for %i = 0 to 21 {
            %qubit_i = tensor.extract %qubits[%i] : tensor<21x!ensemble.physical_qubit>
            %bit_i = tensor.extract %bits[%i] : tensor<21x!ensemble.cbit>
            ensemble.measure %qubit_i, %bit_i : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        return
    }

    func.func @main() {
        %qubits = ensemble.program_alloc 21 : () -> tensor<21x!ensemble.physical_qubit>
        %bits = ensemble.alloc_cbits 21 : () -> tensor<21x!ensemble.cbit>
        affine.for %circuit_index = 0 to 9 {
            func.call @iteration_body(%circuit_index, %qubits, %bits) : (index, tensor<21x!ensemble.physical_qubit>, tensor<21x!ensemble.cbit>) -> ()
        }
        return
    }
}
