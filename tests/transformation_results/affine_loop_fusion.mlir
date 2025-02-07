module {
  func.func @main() {
    %cst = arith.constant 1.5707963267948966 : f64
    %cst_0 = arith.constant 0.000000e+00 : f64
    %cst_1 = arith.constant 3.1415926535897931 : f64
    %c25 = arith.constant 25 : index
    %c16_i32 = arith.constant 16 : i32
    %c4_i32 = arith.constant 4 : i32
    %c13_i32 = arith.constant 13 : i32
    %c12_i32 = arith.constant 12 : i32
    %c1000 = arith.constant 1000 : index
    %c20 = arith.constant 20 : index
    %c0_i32 = arith.constant 0 : i32
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c2_i32 = arith.constant 2 : i32
    %c100_i32 = arith.constant 100 : i32
    %c25_i32 = arith.constant 25 : i32
    %0 = ensemble.program_alloc 25 : () -> tensor<25x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 25 : () -> tensor<25x!ensemble.cbit>
    %2 = ensemble.device_connectivity %0, {dense<[[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [12, 13], [13, 14], [14, 15], [15, 16], [16, 17], [17, 18], [18, 19], [19, 20], [20, 21], [21, 22], [22, 23], [23, 24]]> : tensor<24x2xi32>} : (tensor<25x!ensemble.physical_qubit>) -> !ensemble.connectivity_graph
    affine.for %arg0 = 0 to 20 {
      %3 = ensemble.int_uniform %c2_i32, %c100_i32 : (i32, i32) -> tensor<1xi32>
      %extracted = tensor.extract %3[%c0] : tensor<1xi32>
      %4 = ensemble.int_uniform %c0_i32, %c13_i32, [%extracted] : (i32, i32, i32) -> tensor<?xi32>
      %5 = ensemble.cnot_pair_distribution %2, [%extracted, %c12_i32] : (!ensemble.connectivity_graph, i32, i32) -> tensor<?x?x2x!ensemble.physical_qubit>
      %6 = ensemble.int_uniform %c0_i32, %c2_i32, [%extracted, %c25_i32] : (i32, i32, i32, i32) -> tensor<?x25xi32>
      affine.for %arg1 = 0 to 1000 {
        %7 = ensemble.gate "U3" 1(%cst_0, %cst_0, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %8 = ensemble.gate "U3" 1(%cst_1, %cst_0, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %9 = ensemble.gate "U3" 1(%cst, %cst_0, %cst_1) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %10 = ensemble.gate "U3" 1(%cst_0, %cst_0, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %11 = ensemble.gate "U3" 1(%cst_1, %cst, %cst) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %12 = ensemble.gate "U3" 1(%cst_0, %cst_1, %cst_0) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %13 = ensemble.gate "CX" 2 {"nativized-peeked"} : () -> !ensemble.gate
        %14 = ensemble.gate_distribution %7, %7, %7, %7, %8, %8, %8, %8, %11, %11, %11, %11, %12, %12, %12, %12 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %15 = ensemble.gate_distribution %7, %8, %11, %12, %7, %8, %11, %12, %7, %8, %11, %12, %7, %8, %11, %12 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %16 = ensemble.gate_distribution %7, %7, %12, %12, %8, %8, %11, %11, %11, %11, %8, %8, %12, %12, %7, %7 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %17 = ensemble.gate_distribution %7, %8, %11, %12, %8, %7, %12, %11, %8, %7, %12, %11, %7, %8, %11, %12 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %18 = ensemble.gate_distribution %7, %8, %11, %12 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %19 = ensemble.gate_distribution %7, %12, %11, %8, %7, %11, %8, %12 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %20 = ensemble.int_uniform %c0_i32, %c16_i32, [%extracted, %c12_i32] : (i32, i32, i32, i32) -> tensor<?x?xi32>
        %21 = ensemble.int_uniform %c0_i32, %c4_i32, [%extracted, %c25_i32] : (i32, i32, i32, i32) -> tensor<?x?xi32>
        ensemble.quantum_program_iteration {
          ensemble.reset_tensor %0 : (tensor<25x!ensemble.physical_qubit>) -> ()
          %22 = arith.index_cast %extracted : i32 to index
          scf.for %arg2 = %c0 to %22 step %c1 {
            %extracted_2 = tensor.extract %4[%arg2] : tensor<?xi32>
            %23 = arith.index_cast %extracted_2 : i32 to index
            scf.for %arg3 = %c0 to %23 step %c1 {
              %extracted_3 = tensor.extract %20[%arg2, %arg3] : tensor<?x?xi32>
              %extracted_4 = tensor.extract %5[%arg2, %arg3, %c0] : tensor<?x?x2x!ensemble.physical_qubit>
              %extracted_5 = tensor.extract %5[%arg2, %arg3, %c1] : tensor<?x?x2x!ensemble.physical_qubit>
              ensemble.apply_distribution %14[%extracted_3] %extracted_4 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
              ensemble.apply_distribution %15[%extracted_3] %extracted_5 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
              ensemble.apply %13 %extracted_4, %extracted_5 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
              ensemble.apply_distribution %16[%extracted_3] %extracted_4 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
              ensemble.apply_distribution %17[%extracted_3] %extracted_5 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            }
            %24 = arith.muli %extracted_2, %c2_i32 : i32
            %25 = arith.index_cast %24 : i32 to index
            scf.for %arg3 = %25 to %c25 step %c1 {
              %extracted_3 = tensor.extract %6[%arg2, %arg3] : tensor<?x25xi32>
              %extracted_4 = tensor.extract %21[%arg2, %arg3] : tensor<?x?xi32>
              %extracted_5 = tensor.extract %0[%arg3] : tensor<25x!ensemble.physical_qubit>
              ensemble.apply_distribution %18[%extracted_4] %extracted_5 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
              %26 = ensemble.gate_distribution %10, %9 : (!ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
              ensemble.apply_distribution %26[%extracted_3] %extracted_5 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
              %27 = arith.muli %extracted_3, %c4_i32 : i32
              %28 = arith.addi %27, %extracted_4 : i32
              ensemble.apply_distribution %19[%28] %extracted_5 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
            }
          }
          affine.for %arg2 = 0 to 25 {
            %extracted_2 = tensor.extract %0[%arg2] : tensor<25x!ensemble.physical_qubit>
            %extracted_3 = tensor.extract %1[%arg2] : tensor<25x!ensemble.cbit>
            ensemble.measure %extracted_2, %extracted_3 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
          }
          ensemble.transmit_results %1 : (tensor<25x!ensemble.cbit>) -> ()
        }
      }
    }
    return
  }
}

