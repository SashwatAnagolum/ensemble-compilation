module {
  func.func @main() {
    %cst = arith.constant 1.5707963267948966 : f64
    %cst_0 = arith.constant 3.1415926535897931 : f64
    %cst_1 = arith.constant 0.000000e+00 : f64
    %cst_2 = arith.constant -5.000000e-02 : f64
    %cst_3 = arith.constant 5.000000e-02 : f64
    %cst_4 = arith.constant 1.000000e-01 : f64
    %c1_i32 = arith.constant 1 : i32
    %c2_i32 = arith.constant 2 : i32
    %c216_i32 = arith.constant 216 : i32
    %c36_i32 = arith.constant 36 : i32
    %c6_i32 = arith.constant 6 : i32
    %c3 = arith.constant 3 : index
    %c4 = arith.constant 4 : index
    %cst_5 = arith.constant dense<[false, false, true, true, false, false]> : tensor<6xi1>
    %c1 = arith.constant 1 : index
    %0 = ensemble.program_alloc 4 : () -> tensor<4x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 6 : () -> tensor<6x!ensemble.cbit>
    affine.for %arg0 = 0 to 2592 {
      %2 = ensemble.gate "U3" 1(%cst, %cst_1, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %3 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %4 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %5 = ensemble.gate "U3" 1(%cst_1, %cst_1, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %6 = ensemble.gate "U3" 1(%cst_1, %cst_0, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %7 = ensemble.gate_distribution %3, %4, %3, %3, %5, %6 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
      %8 = arith.index_cast %arg0 : index to i32
      %9 = arith.remsi %8, %c2_i32 : i32
      %10 = arith.cmpi eq, %9, %c1_i32 : i32
      %11 = arith.divsi %8, %c2_i32 : i32
      %12 = arith.divsi %11, %c216_i32 : i32
      %13 = arith.divsi %11, %c36_i32 : i32
      %14 = arith.divsi %11, %c6_i32 : i32
      %15 = arith.remsi %12, %c6_i32 : i32
      %16 = arith.remsi %13, %c6_i32 : i32
      %17 = arith.remsi %14, %c6_i32 : i32
      %18 = arith.remsi %11, %c6_i32 : i32
      %from_elements = tensor.from_elements %15, %16, %17, %18 : tensor<4xi32>
      ensemble.quantum_program_iteration {
        ensemble.reset_tensor %0 : (tensor<4x!ensemble.physical_qubit>) -> ()
        %19 = ensemble.gate "CX" 2 {"nativized-peeked"} : () -> !ensemble.gate
        affine.for %arg1 = 0 to 4 {
          affine.for %arg2 = 0 to 4 {
            %extracted_8 = tensor.extract %0[%arg2] : tensor<4x!ensemble.physical_qubit>
            %21 = ensemble.gate "U3" 1(%cst_4, %cst_2, %cst_3) {"generated-by-merging", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
            ensemble.apply %21 {"cannot-merge"} %extracted_8 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
          affine.for %arg2 = 0 to 3 {
            %extracted_8 = tensor.extract %0[%arg2] : tensor<4x!ensemble.physical_qubit>
            %21 = arith.addi %arg2, %c1 : index
            %extracted_9 = tensor.extract %0[%21] : tensor<4x!ensemble.physical_qubit>
            ensemble.apply %19 %extracted_8, %extracted_9 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
          %extracted = tensor.extract %from_elements[%arg1] : tensor<4xi32>
          %20 = arith.index_cast %extracted : i32 to index
          %extracted_6 = tensor.extract %0[%c3] : tensor<4x!ensemble.physical_qubit>
          ensemble.apply_distribution %7[%20] {"cannot-merge"} %extracted_6 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
          %extracted_7 = tensor.extract %cst_5[%20] : tensor<6xi1>
          scf.if %extracted_7 {
            %extracted_8 = tensor.extract %1[%c4] : tensor<6x!ensemble.cbit>
            ensemble.measure %extracted_6, %extracted_8 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
          }
        }
        affine.for %arg1 = 0 to 4 {
          %extracted = tensor.extract %0[%arg1] : tensor<4x!ensemble.physical_qubit>
          %20 = ensemble.gate "U3" 1(%cst_4, %cst_2, %cst_3) {"generated-by-merging", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
          ensemble.apply %20 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        }
        scf.if %10 {
          affine.for %arg1 = 0 to 4 {
            %extracted = tensor.extract %0[%arg1] : tensor<4x!ensemble.physical_qubit>
            ensemble.apply %2 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
        }
        affine.for %arg1 = 0 to 4 {
          %extracted = tensor.extract %0[%arg1] : tensor<4x!ensemble.physical_qubit>
          %extracted_6 = tensor.extract %1[%arg1] : tensor<6x!ensemble.cbit>
          ensemble.measure %extracted, %extracted_6 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        ensemble.transmit_results %1 : (tensor<6x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

