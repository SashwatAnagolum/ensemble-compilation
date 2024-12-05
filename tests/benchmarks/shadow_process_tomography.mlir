module {
    func.func @main() {
        %num_circuits = arith.constant 1024 : i32
        %num_measurement_bases = arith.constant 1024 : i32
        %num_qubits = arith.constant 4 : i32

        %qubits = ensemble.program_alloc 4 : () -> tensor<4x!ensemble.physical_qubit>
        %bits = ensemble.alloc_cbits 4 : () -> tensor<4x!ensemble.cbit>

       

        return
    }
}
