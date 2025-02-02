module {
  func.func @main() {
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
    scf.for %arg0 = %c0 to %c20 step %c1 {
      %3 = ensemble.int_uniform %c2_i32, %c100_i32 : (i32, i32) -> tensor<1xi32>
      %extracted = tensor.extract %3[%c0] : tensor<1xi32>
      %4 = ensemble.int_uniform %c0_i32, %c13_i32, [%extracted] : (i32, i32, i32) -> tensor<?xi32>
      %5 = ensemble.cnot_pair_distribution %2, [%extracted, %c12_i32] : (!ensemble.connectivity_graph, i32, i32) -> tensor<?x?x2x!ensemble.physical_qubit>
      %6 = ensemble.int_uniform %c0_i32, %c2_i32, [%extracted, %c25_i32] : (i32, i32, i32, i32) -> tensor<?x25xi32>
      scf.for %arg1 = %c0 to %c1000 step %c1 {
        %7 = ensemble.gate "I" 1 {"zero-noise-touched"} : () -> !ensemble.gate
        %8 = ensemble.gate "I" "transpose" 1 {"zero-noise-created"} : () -> !ensemble.gate
        %9 = ensemble.gate "X" 1 {"zero-noise-touched"} : () -> !ensemble.gate
        %10 = ensemble.gate "X" "transpose" 1 {"zero-noise-created"} : () -> !ensemble.gate
        %11 = ensemble.gate "H" 1 {"zero-noise-touched"} : () -> !ensemble.gate
        %12 = ensemble.gate "H" "transpose" 1 {"zero-noise-created"} : () -> !ensemble.gate
        %13 = ensemble.gate "S" 1 {"zero-noise-touched"} : () -> !ensemble.gate
        %14 = ensemble.gate "S" "transpose" 1 {"zero-noise-created"} : () -> !ensemble.gate
        %15 = ensemble.gate "Y" 1 {"zero-noise-touched"} : () -> !ensemble.gate
        %16 = ensemble.gate "Y" "transpose" 1 {"zero-noise-created"} : () -> !ensemble.gate
        %17 = ensemble.gate "Z" 1 {"zero-noise-touched"} : () -> !ensemble.gate
        %18 = ensemble.gate "Z" "transpose" 1 {"zero-noise-created"} : () -> !ensemble.gate
        %19 = ensemble.gate "CX" 2 {"zero-noise-touched"} : () -> !ensemble.gate
        %20 = ensemble.gate "CX" "transpose" 2 {"zero-noise-created"} : () -> !ensemble.gate
        %21 = ensemble.gate_distribution %7, %7, %7, %7, %9, %9, %9, %9, %15, %15, %15, %15, %17, %17, %17, %17 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %22 = ensemble.gate_distribution %7, %9, %15, %17, %7, %9, %15, %17, %7, %9, %15, %17, %7, %9, %15, %17 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %23 = ensemble.gate_distribution %7, %7, %17, %17, %9, %9, %15, %15, %15, %15, %9, %9, %17, %17, %7, %7 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %24 = ensemble.gate_distribution %7, %9, %15, %17, %9, %7, %17, %15, %9, %7, %17, %15, %7, %9, %15, %17 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %25 = ensemble.gate_distribution %7, %9, %15, %17 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %26 = ensemble.gate_distribution %7, %17, %15, %9, %7, %15, %9, %17 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        %27 = ensemble.int_uniform %c0_i32, %c16_i32, [%extracted, %c12_i32] : (i32, i32, i32, i32) -> tensor<?x?xi32>
        %28 = ensemble.int_uniform %c0_i32, %c4_i32, [%extracted, %c25_i32] : (i32, i32, i32, i32) -> tensor<?x?xi32>
        affine.for %arg2 = 0 to 8 {
          ensemble.quantum_program_iteration {
            ensemble.reset_tensor %0 : (tensor<25x!ensemble.physical_qubit>) -> ()
            %29 = arith.index_cast %extracted : i32 to index
            scf.for %arg3 = %c0 to %29 step %c1 {
              %extracted_0 = tensor.extract %4[%arg3] : tensor<?xi32>
              %30 = arith.index_cast %extracted_0 : i32 to index
              scf.for %arg4 = %c0 to %30 step %c1 {
                %extracted_1 = tensor.extract %27[%arg3, %arg4] : tensor<?x?xi32>
                %extracted_2 = tensor.extract %5[%arg3, %arg4, %c0] : tensor<?x?x2x!ensemble.physical_qubit>
                %extracted_3 = tensor.extract %5[%arg3, %arg4, %c1] : tensor<?x?x2x!ensemble.physical_qubit>
                ensemble.apply_distribution %21[%extracted_1] %extracted_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
                ensemble.apply_distribution %22[%extracted_1] %extracted_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
                ensemble.apply %19 {"zero-noise-touched"} %extracted_2, %extracted_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                scf.for %arg5 = %c0 to %arg2 step %c1 {
                  ensemble.apply %19 {"zero-noise-created"} %extracted_2, %extracted_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                  ensemble.apply %20 {"zero-noise-created"} %extracted_2, %extracted_3 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
                }
                ensemble.apply_distribution %23[%extracted_1] %extracted_2 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
                ensemble.apply_distribution %24[%extracted_1] %extracted_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
              }
              %31 = arith.muli %extracted_0, %c2_i32 : i32
              %32 = arith.index_cast %31 : i32 to index
              scf.for %arg4 = %32 to %c25 step %c1 {
                %extracted_1 = tensor.extract %6[%arg3, %arg4] : tensor<?x25xi32>
                %extracted_2 = tensor.extract %28[%arg3, %arg4] : tensor<?x?xi32>
                %extracted_3 = tensor.extract %0[%arg4] : tensor<25x!ensemble.physical_qubit>
                ensemble.apply_distribution %25[%extracted_2] %extracted_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
                %33 = ensemble.gate_distribution %13, %11 : (!ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
                ensemble.apply_distribution %33[%extracted_1] %extracted_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
                %34 = arith.muli %extracted_1, %c4_i32 : i32
                %35 = arith.addi %34, %extracted_2 : i32
                ensemble.apply_distribution %26[%35] %extracted_3 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
              }
            }
            scf.for %arg3 = %c0 to %c25 step %c1 {
              %extracted_0 = tensor.extract %0[%arg3] : tensor<25x!ensemble.physical_qubit>
              %extracted_1 = tensor.extract %1[%arg3] : tensor<25x!ensemble.cbit>
              ensemble.measure %extracted_0, %extracted_1 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
            }
            ensemble.transmit_results %1 : (tensor<25x!ensemble.cbit>) -> ()
          } {"zero-noise-touched"}
        }
      }
    }
    return
  }
}

