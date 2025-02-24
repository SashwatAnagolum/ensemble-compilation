module {
  func.func @main() {
    %cst = arith.constant 1.5707963267948966 : f64
    %cst_0 = arith.constant 0.000000e+00 : f64
    %cst_1 = arith.constant 3.1415926535897931 : f64
    %cst_2 = arith.constant dense<[0, 1, 0, 1, 0, 1]> : tensor<6xi32>
    %c1_i32 = arith.constant 1 : i32
    %c13_i32 = arith.constant 13 : i32
    %c3 = arith.constant 3 : index
    %cst_3 = arith.constant dense<[4, 8, 12]> : tensor<3xi32>
    %c30 = arith.constant 30 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c6_i32 = arith.constant 6 : i32
    %c3_i32 = arith.constant 3 : i32
    %c0_i32 = arith.constant 0 : i32
    %0 = ensemble.program_alloc 6 : () -> tensor<6x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 6 : () -> tensor<6x!ensemble.cbit>
    affine.for %arg0 = 0 to 1000 {
      %2 = ensemble.int_uniform %c0_i32, %c3_i32, [%c6_i32] : (i32, i32, i32) -> tensor<6xi32>
      affine.for %arg1 = 0 to 30 {
        %3 = arith.muli %arg0, %c30 : index
        %4 = arith.addi %3, %arg1 : index
        %5 = ensemble.gate "U3" 1(%cst_1, %cst_0, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %6 = ensemble.gate "U3" 1(%cst_1, %cst, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %7 = ensemble.gate "U3" 1(%cst_0, %cst_1, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %8 = ensemble.gate_distribution %6, %6, %5, %5, %5, %6, %5, %6, %7 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %9 = arith.index_cast %4 : index to i32
        %10 = ensemble.int_uniform %c0_i32, %c3_i32, [%c13_i32, %c6_i32] : (i32, i32, i32, i32) -> tensor<13x6xi32>
        %11 = ensemble.gate_distribution %5, %6, %7 : (!ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.quantum_program_iteration {
          ensemble.reset_tensor %0 : (tensor<6x!ensemble.physical_qubit>) -> ()
          affine.for %arg2 = 0 to 6 {
            %extracted_4 = tensor.extract %2[%arg2] : tensor<6xi32>
            %16 = arith.index_cast %extracted_4 : i32 to index
            %extracted_5 = tensor.extract %10[%c0, %arg2] : tensor<13x6xi32>
            %17 = arith.index_cast %extracted_5 : i32 to index
            %extracted_6 = tensor.extract %0[%arg2] : tensor<6x!ensemble.physical_qubit>
            %18 = arith.muli %16, %c3 : index
            %19 = arith.addi %18, %17 : index
            ensemble.apply_distribution %8[%19] {"cannot-merge"} %extracted_6 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
          }
          %12 = arith.remsi %9, %c3_i32 : i32
          %13 = arith.index_cast %12 : i32 to index
          %extracted = tensor.extract %cst_3[%13] : tensor<3xi32>
          %14 = arith.subi %extracted, %c1_i32 : i32
          %15 = arith.index_cast %14 : i32 to index
          scf.for %arg2 = %c0 to %15 step %c1 {
            affine.for %arg3 = 0 to 6 {
              %extracted_4 = tensor.extract %cst_2[%arg3] : tensor<6xi32>
              %16 = arith.index_cast %extracted_4 : i32 to index
              %extracted_5 = tensor.extract %0[%arg3] : tensor<6x!ensemble.physical_qubit>
              ensemble.apply_distribution %11[%16] {"cannot-merge"} %extracted_5 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
            }
            affine.for %arg3 = 0 to 6 {
              %extracted_4 = tensor.extract %10[%arg2, %arg3] : tensor<13x6xi32>
              %16 = arith.index_cast %extracted_4 : i32 to index
              %extracted_5 = tensor.extract %0[%arg3] : tensor<6x!ensemble.physical_qubit>
              ensemble.apply_distribution %11[%16] {"cannot-merge"} %extracted_5 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
            }
          }
          affine.for %arg2 = 0 to 6 {
            %extracted_4 = tensor.extract %cst_2[%arg2] : tensor<6xi32>
            %16 = arith.index_cast %extracted_4 : i32 to index
            %extracted_5 = tensor.extract %0[%arg2] : tensor<6x!ensemble.physical_qubit>
            ensemble.apply_distribution %11[%16] {"cannot-merge"} %extracted_5 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
          }
          affine.for %arg2 = 0 to 6 {
            %extracted_4 = tensor.extract %0[%arg2] : tensor<6x!ensemble.physical_qubit>
            %extracted_5 = tensor.extract %10[%15, %arg2] : tensor<13x6xi32>
            %16 = arith.index_cast %extracted_5 : i32 to index
            %extracted_6 = tensor.extract %2[%arg2] : tensor<6xi32>
            %17 = arith.index_cast %extracted_6 : i32 to index
            %18 = arith.muli %17, %c3 : index
            %19 = arith.addi %18, %16 : index
            ensemble.apply_distribution %8[%19] {"cannot-merge"} %extracted_4 : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
          }
          affine.for %arg2 = 0 to 6 {
            %extracted_4 = tensor.extract %0[%arg2] : tensor<6x!ensemble.physical_qubit>
            %extracted_5 = tensor.extract %1[%arg2] : tensor<6x!ensemble.cbit>
            ensemble.measure %extracted_4, %extracted_5 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
          }
          ensemble.transmit_results %1 : (tensor<6x!ensemble.cbit>) -> ()
        }
      }
    }
    return
  }
}

