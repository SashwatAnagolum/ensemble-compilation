module {
  func.func @main() {
    %c0 = arith.constant 0 : index
    %cst = arith.constant 7.854000e-01 : f64
    %cst_0 = arith.constant 3.141600e+00 : f64
    %cst_1 = arith.constant 0.000000e+00 : f64
    %cst_2 = arith.constant 1.570800e+00 : f64
    %0 = ensemble.program_alloc 1 : () -> tensor<1x!ensemble.physical_qubit>
    %1 = ensemble.gate "U3" 1(%cst_2, %cst_1, %cst_0) : (f64, f64, f64) -> !ensemble.gate
    %2 = ensemble.gate "U3" 1(%cst, %cst_2, %cst_1) : (f64, f64, f64) -> !ensemble.gate
    %3 = ensemble.gate "CNOT" 2 : () -> !ensemble.gate
    %unused = ensemble.gate_distribution  %1, %2, %1 : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
    %extracted = tensor.extract %0[%c0] : tensor<1x!ensemble.physical_qubit>

    affine.for %i = 0 to 1 {
      ensemble.apply %1 {"first-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      %cst_3 = arith.constant 0.000000e+00 : f64

      %u3_1 = ensemble.gate "U3" 1(%cst_2, %cst_3, %cst_0) : (f64, f64, f64) -> !ensemble.gate
      affine.for %ii = 0 to 1 {
        ensemble.apply %u3_1 {"second-applyed"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      }
      ensemble.apply %2 {"third-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    }

    affine.for %i = 0 to 1 {
      ensemble.apply %1 {"first-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      %cst_3 = arith.constant 0.000000e+00 : f64

      %u3_1 = ensemble.gate "U3" 1(%cst_2, %cst_3, %cst_0) : (f64, f64, f64) -> !ensemble.gate
      %lowerBound = arith.constant 0 : index
      %upperBound = arith.constant 3 : index
      %step = arith.constant 1 : index
      scf.for %ii = %lowerBound to %upperBound step %step {
        ensemble.apply %u3_1 {"second-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      }
      ensemble.apply %2 {"third-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    }

    affine.for %i = 0 to 1 {
      // first applies the first U3 1.5708, 0, 3.1416
      // then applies the second U3 1.5708, 0, 3.1416
      // then applies the third U3 0.7854, 1.5708, 0 

      // merged becomes the sum of the parameters of the first, second, and third U3
      // the merged gate is applied once
      // merged gate is U3 1.5708 + 1.5708 + 0.7854, 0 + 0 + 1.5708, 3.1416 + 3.1416 + 0 which is U3 3.927, 1.5708, 6.2832

      ensemble.apply %1 {"first-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      %cst_3 = arith.constant 0.000000e+00 : f64

      %u3_1 = ensemble.gate "U3" 1(%cst_2, %cst_3, %cst_0) : (f64, f64, f64) -> !ensemble.gate
      ensemble.apply %u3_1 {"second-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      ensemble.apply %2 {"third-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    }

    affine.for %i = 0 to 1 {
      ensemble.apply %1 %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      ensemble.apply %2 %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      ensemble.apply %3 %extracted, %extracted : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
    }

    return
  }
}
