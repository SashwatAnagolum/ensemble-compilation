module {
  func.func @main() {
    %cst = arith.constant 3.1415926535897931 : f64
    %cst_0 = arith.constant 1.5707963267948966 : f64
    %cst_1 = arith.constant -1.5707963267948966 : f64
    %cst_2 = arith.constant 2.000000e-01 : f64
    %cst_3 = arith.constant 4.200000e-01 : f64
    %cst_4 = arith.constant 0.000000e+00 : f64
    %c8 = arith.constant 8 : index
    %c64 = arith.constant 64 : index
    %c512 = arith.constant 512 : index
    %c4096 = arith.constant 4096 : index
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %0 = ensemble.program_alloc 9 : () -> tensor<9x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 9 : () -> tensor<9x!ensemble.cbit>
    affine.for %arg0 = 0 to 12288 {
      %2 = ensemble.gate "U3" 1(%cst_4, %cst_4, %cst_4) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %3 = ensemble.gate "U3" 1(%cst_0, %cst_4, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %4 = ensemble.gate "U3" 1(%cst, %cst_4, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %5 = ensemble.gate "U3" 1(%cst_0, %cst_1, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %6 = ensemble.gate "U3" 1(%cst_0, %cst_0, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %7 = ensemble.gate "CNOT" 2 {"nativized-peeked"} : () -> !ensemble.gate
      %8 = ensemble.gate "U3" 1(%cst_3, %cst_4, %cst_4) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %9 = ensemble.gate "U3" 1(%cst_2, %cst_1, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %10 = ensemble.gate_distribution %2, %2, %3, %3, %5, %5, %2, %2 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
      %11 = ensemble.gate_distribution %2, %4, %3, %4, %6, %4, %2, %4 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
      %12 = ensemble.gate_distribution %2, %2, %2, %3, %2, %6, %2, %2 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
      %13 = arith.divsi %arg0, %c2 : index
      %14 = arith.remsi %arg0, %c2 : index
      %15 = arith.divsi %13, %c8 : index
      %16 = arith.divsi %13, %c64 : index
      %17 = arith.divsi %13, %c512 : index
      %18 = arith.divsi %13, %c4096 : index
      %19 = arith.remsi %13, %c8 : index
      %20 = arith.remsi %15, %c8 : index
      %21 = arith.remsi %16, %c8 : index
      %22 = arith.remsi %17, %c8 : index
      %23 = arith.remsi %18, %c8 : index
      %from_elements = tensor.from_elements %19, %20, %21, %22, %23 : tensor<5xindex>
      ensemble.quantum_program_iteration {
        ensemble.reset_tensor %0 : (tensor<9x!ensemble.physical_qubit>) -> ()
        %24 = arith.index_cast %14 : index to i32
        %25 = arith.cmpi eq, %24, %c0_i32 : i32
        %26 = arith.cmpi eq, %24, %c1_i32 : i32
        scf.if %25 {
          affine.for %arg1 = 0 to 9 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            ensemble.apply %3 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
          affine.for %arg1 = 0 to 3 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            %27 = arith.addi %arg1, %c1 : index
            %extracted_5 = tensor.extract %0[%27] : tensor<9x!ensemble.physical_qubit>
            ensemble.apply %7 %extracted, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply %8 {"cannot-merge"} %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %7 %extracted, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
          affine.for %arg1 = 0 to 4 {
            affine.for %arg2 = 4 to 9 {
              %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
              %extracted_5 = tensor.extract %0[%arg2] : tensor<9x!ensemble.physical_qubit>
              ensemble.apply %7 %extracted, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
              ensemble.apply %8 {"cannot-merge"} %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              ensemble.apply %7 %extracted, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }
          }
          affine.for %arg1 = 0 to 4 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            ensemble.apply %9 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
          affine.for %arg1 = 0 to 5 {
            %27 = arith.addi %arg1, %c4 : index
            %extracted = tensor.extract %0[%27] : tensor<9x!ensemble.physical_qubit>
            %extracted_5 = tensor.extract %from_elements[%arg1] : tensor<5xindex>
            ensemble.apply_distribution %10[%extracted_5] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
          }
        }
        scf.if %26 {
          affine.for %arg1 = 0 to 5 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            %extracted_5 = tensor.extract %from_elements[%arg1] : tensor<5xindex>
            ensemble.apply_distribution %11[%extracted_5] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %12[%extracted_5] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
          }
          affine.for %arg1 = 5 to 9 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            ensemble.apply %3 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
          affine.for %arg1 = 0 to 5 {
            affine.for %arg2 = 5 to 9 {
              %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
              %extracted_5 = tensor.extract %0[%arg2] : tensor<9x!ensemble.physical_qubit>
              ensemble.apply %7 %extracted, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
              ensemble.apply %8 {"cannot-merge"} %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              ensemble.apply %7 %extracted, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }
          }
          affine.for %arg1 = 5 to 8 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            %27 = arith.addi %arg1, %c1 : index
            %extracted_5 = tensor.extract %0[%27] : tensor<9x!ensemble.physical_qubit>
            ensemble.apply %7 %extracted, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply %8 {"cannot-merge"} %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %7 %extracted, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
          affine.for %arg1 = 0 to 9 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            ensemble.apply %9 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
        }
        affine.for %arg1 = 0 to 9 {
          %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
          %extracted_5 = tensor.extract %1[%arg1] : tensor<9x!ensemble.cbit>
          ensemble.measure %extracted, %extracted_5 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        ensemble.transmit_results %1 : (tensor<9x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

