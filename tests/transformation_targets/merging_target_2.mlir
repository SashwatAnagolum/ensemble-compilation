module {
  func.func @main() {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst_0 = arith.constant 0.000000e+00 : f64
    %cst_1 = arith.constant 1.000000e+00 : f64
    %cst_2 = arith.constant 2.000000e+00 : f64
    %cst_3 = arith.constant 3.000000e+00 : f64

    %0 = ensemble.program_alloc 2 : () -> tensor<2x!ensemble.physical_qubit>
    %results = ensemble.alloc_cbits 2 : () -> tensor<2x!ensemble.cbit>
    %1 = ensemble.gate "U3" 1(%cst_2, %cst_1, %cst_0) : (f64, f64, f64) -> !ensemble.gate
    %2 = ensemble.gate "U3" 1(%cst_0, %cst_1, %cst_2) : (f64, f64, f64) -> !ensemble.gate
    %3 = ensemble.gate "U3" 1(%cst_2, %cst_2, %cst_2) : (f64, f64, f64) -> !ensemble.gate

    // [2, 1, 0] , [0, 1, 2]
    %4 = ensemble.gate_distribution %1, %2: (!ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    // [0, 1, 2] , [2, 2, 2]
    %5 = ensemble.gate_distribution %2, %3: (!ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution

    %q0 = tensor.extract %0[%c0] : tensor<2x!ensemble.physical_qubit>
    %q1 = tensor.extract %0[%c1] : tensor<2x!ensemble.physical_qubit>
    ensemble.quantum_program_iteration {
      ensemble.apply_distribution %4 [%c0]  %q0 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
      ensemble.apply %1  %q0 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      // [2, 1, 0] , [0, 1, 2] merged with [2, 1, 0]. is [4, 2, 0], [2, 2, 2]
      ensemble.apply_distribution %5 [%c1] %q1 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
      ensemble.apply %2  %q1 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      ensemble.transmit_results %results : (tensor<2x!ensemble.cbit>) -> ()
    }

    return
  }
}
