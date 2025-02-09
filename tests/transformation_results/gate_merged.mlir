module {
  func.func @main() {
    %cst = arith.constant 3.9269999999999996 : f64
    %cst_0 = arith.constant 6.283200e+00 : f64
    %cst_1 = arith.constant 2.356200e+00 : f64
    %c0 = arith.constant 0 : index
    %cst_2 = arith.constant 7.854000e-01 : f64
    %cst_3 = arith.constant 3.141600e+00 : f64
    %cst_4 = arith.constant 0.000000e+00 : f64
    %cst_5 = arith.constant 1.570800e+00 : f64
    %0 = ensemble.program_alloc 1 : () -> tensor<1x!ensemble.physical_qubit>
    %1 = ensemble.gate "U3" 1(%cst_5, %cst_4, %cst_3) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
    %2 = ensemble.gate "U3" 1(%cst_2, %cst_5, %cst_4) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
    %3 = ensemble.gate "CNOT" 2 {"nativized-peeked"} : () -> !ensemble.gate
    %extracted = tensor.extract %0[%c0] : tensor<1x!ensemble.physical_qubit>
    affine.for %arg0 = 0 to 1 {
      ensemble.apply %1 {"cannot-merge", "first-apply", "identified-it"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      %4 = ensemble.gate "U3" 1(%cst_5, %cst_4, %cst_3) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      affine.for %arg1 = 0 to 1 {
        ensemble.apply %4 {"cannot-merge", "identified-it", "second-applyed"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      }
      ensemble.apply %2 {"cannot-merge", "identified-it", "third-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    }
    affine.for %arg0 = 0 to 1 {
      ensemble.apply %1 {"cannot-merge", "first-apply", "identified-it"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      %4 = ensemble.gate "U3" 1(%cst_5, %cst_4, %cst_3) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      affine.for %arg1 = 0 to 3 {
        ensemble.apply %4 {"cannot-merge", "identified-it", "second-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      }
      ensemble.apply %2 {"cannot-merge", "identified-it", "third-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    }
    affine.for %arg0 = 0 to 1 {
      %4 = ensemble.gate "U3" 1(%cst, %cst_5, %cst_0) {"generated-by-merging", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      ensemble.apply %4 {"cannot-merge", "identified-it", "third-apply"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
    }
    affine.for %arg0 = 0 to 1 {
      %4 = ensemble.gate "U3" 1(%cst_1, %cst_5, %cst_3) {"generated-by-merging", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      ensemble.apply %4 {"cannot-merge", "identified-it"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
      ensemble.apply %3 %extracted, %extracted : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
    }
    return
  }
}

