module {
  func.func @main() {
    %c1 = arith.constant 1 : index
    %c3 = arith.constant 3 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 7.854000e-01 : f64
    %cst_0 = arith.constant 3.141600e+00 : f64
    %cst_1 = arith.constant 0.000000e+00 : f64
    %cst_2 = arith.constant 1.570800e+00 : f64
    %0 = ensemble.program_alloc 1 : () -> tensor<1x!ensemble.physical_qubit>
    %1 = ensemble.gate "U3" 1(%cst_2, %cst_1, %cst_0) : (f64, f64, f64) -> !ensemble.gate
    %2 = ensemble.gate "U3" 1(%cst, %cst_2, %cst_1) : (f64, f64, f64) -> !ensemble.gate
    %3 = ensemble.gate "CNOT" 2 : () -> !ensemble.gate
    %extracted = tensor.extract %0[%c0] : tensor<1x!ensemble.physical_qubit>
    affine.for %arg0 = 0 to 1 {
      ensemble.apply %1 {"first-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      %4 = ensemble.gate "U3" 1(%cst_2, %cst_1, %cst_0) : (f64, f64, f64) -> !ensemble.gate
      affine.for %arg1 = 0 to 1 {
        ensemble.apply %4 {"second-applyed"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      }
      ensemble.apply %2 {"third-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    }
    affine.for %arg0 = 0 to 1 {
      ensemble.apply %1 {"first-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      %4 = ensemble.gate "U3" 1(%cst_2, %cst_1, %cst_0) : (f64, f64, f64) -> !ensemble.gate
      scf.for %arg1 = %c0 to %c3 step %c1 {
        ensemble.apply %4 {"second-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      }
      ensemble.apply %2 {"third-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    }
    affine.for %arg0 = 0 to 1 {
      ensemble.apply %1 {"first-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      %4 = ensemble.gate "U3" 1(%cst_2, %cst_1, %cst_0) : (f64, f64, f64) -> !ensemble.gate
      ensemble.apply %4 {"second-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      ensemble.apply %2 {"third-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    }
    affine.for %arg0 = 0 to 1 {
      ensemble.apply %1 %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      ensemble.apply %2 %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      ensemble.apply %3 %extracted, %extracted : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
    }
    return
  }
}

