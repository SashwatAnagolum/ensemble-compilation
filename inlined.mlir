module {
  func.func @main() {
    %cst = arith.constant 2.000000e-01 : f64
    %cst_0 = arith.constant 4.200000e-01 : f64
    %cst_1 = arith.constant 0.000000e+00 : f64
    %c8 = arith.constant 8 : index
    %c64 = arith.constant 64 : index
    %c512 = arith.constant 512 : index
    %c4096 = arith.constant 4096 : index
    %c5 = arith.constant 5 : index
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c9 = arith.constant 9 : index
    %c3 = arith.constant 3 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    %c12288 = arith.constant 12288 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = ensemble.program_alloc 9 : () -> tensor<9x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 9 : () -> tensor<9x!ensemble.cbit>
    scf.for %arg0 = %c0 to %c12288 step %c1 {
      %2 = ensemble.gate "I" 1 : () -> !ensemble.gate
      %3 = ensemble.gate "H" 1 : () -> !ensemble.gate
      %4 = ensemble.gate "X" 1 : () -> !ensemble.gate
      %5 = ensemble.gate "SX" 1 : () -> !ensemble.gate
      %6 = ensemble.gate "SXdag" 1 : () -> !ensemble.gate
      %7 = ensemble.gate "CNOT" 2 : () -> !ensemble.gate
      %8 = ensemble.gate "U3" 1(%cst_0, %cst_1, %cst_1) : (f64, f64, f64) -> !ensemble.gate
      %9 = ensemble.gate "RX" 1(%cst) : (f64) -> !ensemble.gate
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
          scf.for %arg1 = %c0 to %c9 step %c1 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            ensemble.apply %3 %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
          scf.for %arg1 = %c0 to %c3 step %c1 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            %27 = arith.addi %arg1, %c1 : index
            %extracted_2 = tensor.extract %0[%27] : tensor<9x!ensemble.physical_qubit>
            ensemble.apply %7 %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply %8 %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %7 %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
          scf.for %arg1 = %c0 to %c4 step %c1 {
            scf.for %arg2 = %c4 to %c9 step %c1 {
              %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
              %extracted_2 = tensor.extract %0[%arg2] : tensor<9x!ensemble.physical_qubit>
              ensemble.apply %7 %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
              ensemble.apply %8 %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              ensemble.apply %7 %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }
          }
          scf.for %arg1 = %c0 to %c4 step %c1 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            ensemble.apply %9 %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
          scf.for %arg1 = %c0 to %c5 step %c1 {
            %27 = arith.addi %arg1, %c4 : index
            %extracted = tensor.extract %0[%27] : tensor<9x!ensemble.physical_qubit>
            %extracted_2 = tensor.extract %from_elements[%arg1] : tensor<5xindex>
            ensemble.apply_distribution %10[%extracted_2] %extracted : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
          }
        }
        scf.if %26 {
          scf.for %arg1 = %c0 to %c5 step %c1 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            %extracted_2 = tensor.extract %from_elements[%arg1] : tensor<5xindex>
            ensemble.apply_distribution %11[%extracted_2] %extracted : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
            ensemble.apply_distribution %12[%extracted_2] %extracted : (!ensemble.gate_distribution, index, !ensemble.physical_qubit) -> ()
          }
          scf.for %arg1 = %c5 to %c9 step %c1 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            ensemble.apply %3 %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
          scf.for %arg1 = %c0 to %c5 step %c1 {
            scf.for %arg2 = %c5 to %c9 step %c1 {
              %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
              %extracted_2 = tensor.extract %0[%arg2] : tensor<9x!ensemble.physical_qubit>
              ensemble.apply %7 %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
              ensemble.apply %8 %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
              ensemble.apply %7 %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            }
          }
          scf.for %arg1 = %c5 to %c8 step %c1 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            %27 = arith.addi %arg1, %c1 : index
            %extracted_2 = tensor.extract %0[%27] : tensor<9x!ensemble.physical_qubit>
            ensemble.apply %7 %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
            ensemble.apply %8 %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
            ensemble.apply %7 %extracted, %extracted_2 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
          }
          scf.for %arg1 = %c0 to %c9 step %c1 {
            %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
            ensemble.apply %9 %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
          }
        }
        scf.for %arg1 = %c0 to %c9 step %c1 {
          %extracted = tensor.extract %0[%arg1] : tensor<9x!ensemble.physical_qubit>
          %extracted_2 = tensor.extract %1[%arg1] : tensor<9x!ensemble.cbit>
          ensemble.measure %extracted, %extracted_2 : (!ensemble.physical_qubit, !ensemble.cbit) -> ()
        }
        ensemble.transmit_results %1 : (tensor<9x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

