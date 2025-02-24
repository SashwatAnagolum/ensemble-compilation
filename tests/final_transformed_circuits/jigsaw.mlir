module {
  func.func @main() {
    %cst = arith.constant 0.000000e+00 : f64
    %cst_0 = arith.constant 3.1415926535897931 : f64
    %cst_1 = arith.constant 1.5707963267948966 : f64
    %c0_i32 = arith.constant 0 : i32
    %c12_i32 = arith.constant 12 : i32
    %c2_i32 = arith.constant 2 : i32
    %c12 = arith.constant 12 : index
    %cst_2 = arith.constant dense<[true, false, true, false, true, true, true, false, true, false, false, true]> : tensor<12xi1>
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = ensemble.program_alloc 13 : () -> tensor<13x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 2 : () -> tensor<2x!ensemble.cbit>
    affine.for %arg0 = 0 to 1000 {
      %2 = ensemble.int_uniform %c0_i32, %c12_i32, [%c2_i32] : (i32, i32, i32) -> tensor<2xi32>
      %3 = ensemble.gate "U3" 1(%cst_0, %cst, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %4 = ensemble.gate "U3" 1(%cst_1, %cst, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %5 = ensemble.gate "CX" 2 {"nativized-peeked"} : () -> !ensemble.gate
      ensemble.quantum_program_iteration {
        ensemble.reset_tensor %0 : (tensor<13x!ensemble.physical_qubit>) -> ()
        %extracted = tensor.extract %0[%c12] : tensor<13x!ensemble.physical_qubit>
        ensemble.apply %3 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        affine.for %arg1 = 0 to 13 {
          %extracted_9 = tensor.extract %0[%arg1] : tensor<13x!ensemble.physical_qubit>
          ensemble.apply %4 {"cannot-merge"} %extracted_9 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        }
        affine.for %arg1 = 0 to 12 {
          %extracted_9 = tensor.extract %cst_2[%arg1] : tensor<12xi1>
          scf.if %extracted_9 {
            %extracted_10 = tensor.extract %0[%arg1] : tensor<13x!ensemble.physical_qubit>
            ensemble.apply %5 %extracted_10, %extracted : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
        }
        affine.for %arg1 = 0 to 13 {
          %extracted_9 = tensor.extract %0[%arg1] : tensor<13x!ensemble.physical_qubit>
          ensemble.apply %4 {"cannot-merge"} %extracted_9 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        }
        %extracted_3 = tensor.extract %2[%c0] : tensor<2xi32>
        %extracted_4 = tensor.extract %2[%c1] : tensor<2xi32>
        %6 = arith.index_cast %extracted_3 : i32 to index
        %7 = arith.index_cast %extracted_4 : i32 to index
        %extracted_5 = tensor.extract %1[%c0] : tensor<2x!ensemble.cbit>
        %extracted_6 = tensor.extract %1[%c1] : tensor<2x!ensemble.cbit>
        %extracted_7 = tensor.extract %0[%6] : tensor<13x!ensemble.physical_qubit>
        %extracted_8 = tensor.extract %0[%7] : tensor<13x!ensemble.physical_qubit>
        ensemble.measure %extracted_7, %extracted_5 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        ensemble.measure %extracted_8, %extracted_6 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        ensemble.transmit_results %1 : (tensor<2x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

