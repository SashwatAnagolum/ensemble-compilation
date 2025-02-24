module {
  func.func @main() {
    %cst = arith.constant 3.2397674240144743 : f64
    %cst_0 = arith.constant 1.4726215563702154 : f64
    %cst_1 = arith.constant 1.6689710972195777 : f64
    %cst_2 = arith.constant 3.043417883165112 : f64
    %cst_3 = arith.constant 3.3379421944391554 : f64
    %cst_4 = arith.constant 1.3744467859455345 : f64
    %cst_5 = arith.constant 1.7671458676442586 : f64
    %cst_6 = arith.constant 2.9452431127404308 : f64
    %cst_7 = arith.constant 3.5342917352885173 : f64
    %cst_8 = arith.constant 1.1780972450961724 : f64
    %cst_9 = arith.constant 1.9634954084936207 : f64
    %cst_10 = arith.constant 2.748893571891069 : f64
    %cst_11 = arith.constant 3.1415926535897931 : f64
    %cst_12 = arith.constant 1.5707963267948966 : f64
    %cst_13 = arith.constant 0.000000e+00 : f64
    %cst_14 = arith.constant 0.098174770424681035 : f64
    %cst_15 = arith.constant -0.098174770424681035 : f64
    %c0_i32 = arith.constant 0 : i32
    %c16_i32 = arith.constant 16 : i32
    %c1_i32 = arith.constant 1 : i32
    %c18_i32 = arith.constant 18 : i32
    %c4 = arith.constant 4 : index
    %cst_16 = arith.constant 0.39269908169872414 : f64
    %cst_17 = arith.constant 0.19634954084936207 : f64
    %c2 = arith.constant 2 : index
    %c3 = arith.constant 3 : index
    %c2_i32 = arith.constant 2 : i32
    %cst_18 = arith.constant -0.39269908169872414 : f64
    %c5 = arith.constant 5 : index
    %cst_19 = arith.constant -0.19634954084936207 : f64
    %c6 = arith.constant 6 : index
    %c7 = arith.constant 7 : index
    %c8 = arith.constant 8 : index
    %c9 = arith.constant 9 : index
    %c10 = arith.constant 10 : index
    %c11 = arith.constant 11 : index
    %c12 = arith.constant 12 : index
    %c13 = arith.constant 13 : index
    %c14 = arith.constant 14 : index
    %c15 = arith.constant 15 : index
    %c16 = arith.constant 16 : index
    %c17 = arith.constant 17 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = ensemble.program_alloc 4 : () -> tensor<4x!ensemble.physical_qubit>
    %1 = ensemble.alloc_cbits 4 : () -> tensor<4x!ensemble.cbit>
    affine.for %arg0 = 0 to 1000 {
      %2 = ensemble.gate "U3" 1(%cst_13, %cst_13, %cst_13) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %3 = ensemble.gate "U3" 1(%cst_11, %cst_13, %cst_11) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %4 = ensemble.gate "U3" 1(%cst_11, %cst_12, %cst_12) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %5 = ensemble.gate "U3" 1(%cst_13, %cst_11, %cst_13) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %6 = ensemble.gate "U3" 1(%cst_12, %cst_13, %cst_11) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
      %7 = ensemble.gate "CX" 2 {"nativized-peeked"} : () -> !ensemble.gate
      %8 = ensemble.gate_distribution %2, %2, %2, %3, %2, %4, %2, %5, %3, %2, %3, %3, %3, %4, %3, %5, %4, %2, %4, %3, %4, %4, %4, %5, %5, %2, %5, %3, %5, %4, %5, %5 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
      %9 = ensemble.gate_distribution %2, %2, %2, %3, %5, %4, %5, %5, %3, %3, %3, %2, %4, %5, %4, %4, %4, %3, %4, %2, %3, %5, %3, %4, %5, %2, %5, %3, %2, %4, %2, %5 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
      %10 = ensemble.int_uniform %c0_i32, %c16_i32, [%c18_i32] : (i32, i32, i32) -> tensor<18xi32>
      ensemble.quantum_program_iteration {
        ensemble.reset_tensor %0 : (tensor<4x!ensemble.physical_qubit>) -> ()
        affine.for %arg1 = 0 to 4 {
          %extracted_41 = tensor.extract %0[%arg1] : tensor<4x!ensemble.physical_qubit>
          ensemble.apply %6 {"cannot-merge"} %extracted_41 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        }
        %extracted = tensor.extract %0[%c1] : tensor<4x!ensemble.physical_qubit>
        %extracted_20 = tensor.extract %0[%c2] : tensor<4x!ensemble.physical_qubit>
        %extracted_21 = tensor.extract %0[%c3] : tensor<4x!ensemble.physical_qubit>
        %11 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %12 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %13 = ensemble.gate "U3" 1(%cst_13, %cst_15, %cst_14) {"nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        ensemble.apply %11 {"cannot-merge"} %extracted : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        ensemble.apply %12 {"cannot-merge"} %extracted_20 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        ensemble.apply %13 {"cannot-merge"} %extracted_21 : (!ensemble.gate, !ensemble.physical_qubit) -> ()
        %extracted_22 = tensor.extract %0[%c0] : tensor<4x!ensemble.physical_qubit>
        %extracted_23 = tensor.extract %10[%c0] : tensor<18xi32>
        %14 = arith.muli %extracted_23, %c2_i32 : i32
        %15 = arith.addi %14, %c1_i32 : i32
        ensemble.apply_distribution %8[%14] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%15] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted, %extracted_22 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%14] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %16 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %17 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %18 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %19 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %20 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %21 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %22 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %23 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %24 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %25 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %26 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %27 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %28 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %29 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %30 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %31 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %32 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %33 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %34 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %35 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %36 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %37 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %38 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %39 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %40 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %41 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %42 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %43 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %44 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %45 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %46 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %47 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %48 = ensemble.gate_distribution %16, %17, %18, %19, %20, %21, %22, %23, %24, %25, %26, %27, %28, %29, %30, %31, %32, %33, %34, %35, %36, %37, %38, %39, %40, %41, %42, %43, %44, %45, %46, %47 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %48[%15] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_24 = tensor.extract %10[%c1] : tensor<18xi32>
        %49 = arith.muli %extracted_24, %c2_i32 : i32
        %50 = arith.addi %49, %c1_i32 : i32
        ensemble.apply_distribution %8[%49] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%50] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted, %extracted_22 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%49] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %51 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %52 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %53 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %54 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %55 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %56 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %57 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %58 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %59 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %60 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %61 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %62 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %63 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %64 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %65 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %66 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %67 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %68 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %69 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %70 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %71 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %72 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %73 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %74 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %75 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %76 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %77 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %78 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %79 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %80 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %81 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %82 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %83 = ensemble.gate_distribution %51, %52, %53, %54, %55, %56, %57, %58, %59, %60, %61, %62, %63, %64, %65, %66, %67, %68, %69, %70, %71, %72, %73, %74, %75, %76, %77, %78, %79, %80, %81, %82 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %83[%50] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_25 = tensor.extract %10[%c2] : tensor<18xi32>
        %84 = arith.muli %extracted_25, %c2_i32 : i32
        %85 = arith.addi %84, %c1_i32 : i32
        ensemble.apply_distribution %8[%84] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%85] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_20, %extracted_22 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%84] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %86 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %87 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %88 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %89 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %90 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %91 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %92 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %93 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %94 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %95 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %96 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %97 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %98 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %99 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %100 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %101 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %102 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %103 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %104 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %105 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %106 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %107 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %108 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %109 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %110 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %111 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %112 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %113 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %114 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %115 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %116 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %117 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %118 = ensemble.gate_distribution %86, %87, %88, %89, %90, %91, %92, %93, %94, %95, %96, %97, %98, %99, %100, %101, %102, %103, %104, %105, %106, %107, %108, %109, %110, %111, %112, %113, %114, %115, %116, %117 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %118[%85] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_26 = tensor.extract %10[%c3] : tensor<18xi32>
        %119 = arith.muli %extracted_26, %c2_i32 : i32
        %120 = arith.addi %119, %c1_i32 : i32
        ensemble.apply_distribution %8[%119] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%120] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_20, %extracted_22 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        %121 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %122 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %123 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %124 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %125 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %126 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %127 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %128 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %129 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %130 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %131 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %132 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %133 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %134 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %135 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %136 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %137 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %138 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %139 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %140 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %141 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %142 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %143 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %144 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %145 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %146 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %147 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %148 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %149 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %150 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %151 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %152 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %153 = ensemble.gate_distribution %121, %122, %123, %124, %125, %126, %127, %128, %129, %130, %131, %132, %133, %134, %135, %136, %137, %138, %139, %140, %141, %142, %143, %144, %145, %146, %147, %148, %149, %150, %151, %152 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %153[%120] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %154 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %155 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %156 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %157 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %158 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %159 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %160 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %161 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %162 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %163 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %164 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %165 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %166 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %167 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %168 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %169 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %170 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %171 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %172 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %173 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %174 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %175 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %176 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %177 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %178 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %179 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %180 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %181 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %182 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %183 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %184 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %185 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %186 = ensemble.gate_distribution %154, %155, %156, %157, %158, %159, %160, %161, %162, %163, %164, %165, %166, %167, %168, %169, %170, %171, %172, %173, %174, %175, %176, %177, %178, %179, %180, %181, %182, %183, %184, %185 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %186[%119] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_27 = tensor.extract %10[%c4] : tensor<18xi32>
        %187 = arith.muli %extracted_27, %c2_i32 : i32
        %188 = arith.addi %187, %c1_i32 : i32
        ensemble.apply_distribution %8[%187] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%188] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_28 = tensor.extract %10[%c5] : tensor<18xi32>
        %189 = arith.muli %extracted_28, %c2_i32 : i32
        %190 = arith.addi %189, %c1_i32 : i32
        ensemble.apply_distribution %8[%189] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%190] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_21, %extracted_22 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_20, %extracted : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%187] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%189] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %191 = ensemble.gate "U3" 1(%cst_13, %cst_14, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %192 = ensemble.gate "U3" 1(%cst_13, %cst_14, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %193 = ensemble.gate "U3" 1(%cst_13, %cst_14, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %194 = ensemble.gate "U3" 1(%cst_11, %cst_14, %cst_2) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %195 = ensemble.gate "U3" 1(%cst_13, %cst, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %196 = ensemble.gate "U3" 1(%cst_11, %cst_1, %cst_0) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %197 = ensemble.gate "U3" 1(%cst_13, %cst, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %198 = ensemble.gate "U3" 1(%cst_13, %cst, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %199 = ensemble.gate "U3" 1(%cst_11, %cst_14, %cst_2) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %200 = ensemble.gate "U3" 1(%cst_11, %cst_14, %cst_2) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %201 = ensemble.gate "U3" 1(%cst_11, %cst_14, %cst_2) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %202 = ensemble.gate "U3" 1(%cst_13, %cst_14, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %203 = ensemble.gate "U3" 1(%cst_11, %cst_1, %cst_0) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %204 = ensemble.gate "U3" 1(%cst_13, %cst, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %205 = ensemble.gate "U3" 1(%cst_11, %cst_1, %cst_0) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %206 = ensemble.gate "U3" 1(%cst_11, %cst_1, %cst_0) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %207 = ensemble.gate "U3" 1(%cst_11, %cst_1, %cst_0) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %208 = ensemble.gate "U3" 1(%cst_11, %cst_14, %cst_2) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %209 = ensemble.gate "U3" 1(%cst_11, %cst_1, %cst_0) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %210 = ensemble.gate "U3" 1(%cst_13, %cst_14, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %211 = ensemble.gate "U3" 1(%cst_11, %cst_14, %cst_2) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %212 = ensemble.gate "U3" 1(%cst_13, %cst, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %213 = ensemble.gate "U3" 1(%cst_11, %cst_14, %cst_2) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %214 = ensemble.gate "U3" 1(%cst_11, %cst_1, %cst_0) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %215 = ensemble.gate "U3" 1(%cst_13, %cst, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %216 = ensemble.gate "U3" 1(%cst_13, %cst_14, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %217 = ensemble.gate "U3" 1(%cst_13, %cst, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %218 = ensemble.gate "U3" 1(%cst_11, %cst_14, %cst_2) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %219 = ensemble.gate "U3" 1(%cst_13, %cst_14, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %220 = ensemble.gate "U3" 1(%cst_11, %cst_1, %cst_0) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %221 = ensemble.gate "U3" 1(%cst_13, %cst_14, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %222 = ensemble.gate "U3" 1(%cst_13, %cst, %cst_15) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %223 = ensemble.gate_distribution %191, %192, %193, %194, %195, %196, %197, %198, %199, %200, %201, %202, %203, %204, %205, %206, %207, %208, %209, %210, %211, %212, %213, %214, %215, %216, %217, %218, %219, %220, %221, %222 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %223[%188] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_29 = tensor.extract %10[%c6] : tensor<18xi32>
        %224 = arith.muli %extracted_29, %c2_i32 : i32
        %225 = arith.addi %224, %c1_i32 : i32
        ensemble.apply_distribution %8[%224] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%225] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_30 = tensor.extract %10[%c7] : tensor<18xi32>
        %226 = arith.muli %extracted_30, %c2_i32 : i32
        %227 = arith.addi %226, %c1_i32 : i32
        ensemble.apply_distribution %8[%226] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%227] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_21, %extracted_22 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_20, %extracted : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%225] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%226] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %228 = ensemble.gate "U3" 1(%cst_13, %cst_15, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %229 = ensemble.gate "U3" 1(%cst_13, %cst_15, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %230 = ensemble.gate "U3" 1(%cst_13, %cst_15, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %231 = ensemble.gate "U3" 1(%cst_11, %cst_15, %cst) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %232 = ensemble.gate "U3" 1(%cst_13, %cst_2, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %233 = ensemble.gate "U3" 1(%cst_11, %cst_0, %cst_1) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %234 = ensemble.gate "U3" 1(%cst_13, %cst_2, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %235 = ensemble.gate "U3" 1(%cst_13, %cst_2, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %236 = ensemble.gate "U3" 1(%cst_11, %cst_15, %cst) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %237 = ensemble.gate "U3" 1(%cst_11, %cst_15, %cst) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %238 = ensemble.gate "U3" 1(%cst_11, %cst_15, %cst) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %239 = ensemble.gate "U3" 1(%cst_13, %cst_15, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %240 = ensemble.gate "U3" 1(%cst_11, %cst_0, %cst_1) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %241 = ensemble.gate "U3" 1(%cst_13, %cst_2, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %242 = ensemble.gate "U3" 1(%cst_11, %cst_0, %cst_1) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %243 = ensemble.gate "U3" 1(%cst_11, %cst_0, %cst_1) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %244 = ensemble.gate "U3" 1(%cst_11, %cst_0, %cst_1) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %245 = ensemble.gate "U3" 1(%cst_11, %cst_15, %cst) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %246 = ensemble.gate "U3" 1(%cst_11, %cst_0, %cst_1) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %247 = ensemble.gate "U3" 1(%cst_13, %cst_15, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %248 = ensemble.gate "U3" 1(%cst_11, %cst_15, %cst) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %249 = ensemble.gate "U3" 1(%cst_13, %cst_2, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %250 = ensemble.gate "U3" 1(%cst_11, %cst_15, %cst) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %251 = ensemble.gate "U3" 1(%cst_11, %cst_0, %cst_1) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %252 = ensemble.gate "U3" 1(%cst_13, %cst_2, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %253 = ensemble.gate "U3" 1(%cst_13, %cst_15, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %254 = ensemble.gate "U3" 1(%cst_13, %cst_2, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %255 = ensemble.gate "U3" 1(%cst_11, %cst_15, %cst) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %256 = ensemble.gate "U3" 1(%cst_13, %cst_15, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %257 = ensemble.gate "U3" 1(%cst_11, %cst_0, %cst_1) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %258 = ensemble.gate "U3" 1(%cst_13, %cst_15, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %259 = ensemble.gate "U3" 1(%cst_13, %cst_2, %cst_14) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %260 = ensemble.gate_distribution %228, %229, %230, %231, %232, %233, %234, %235, %236, %237, %238, %239, %240, %241, %242, %243, %244, %245, %246, %247, %248, %249, %250, %251, %252, %253, %254, %255, %256, %257, %258, %259 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %260[%227] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %261 = ensemble.gate "U3" 1(%cst_13, %cst_13, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %262 = ensemble.gate "U3" 1(%cst_13, %cst_13, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %263 = ensemble.gate "U3" 1(%cst_13, %cst_13, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %264 = ensemble.gate "U3" 1(%cst_11, %cst_13, %cst_11) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %265 = ensemble.gate "U3" 1(%cst_13, %cst_11, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %266 = ensemble.gate "U3" 1(%cst_11, %cst_12, %cst_12) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %267 = ensemble.gate "U3" 1(%cst_13, %cst_11, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %268 = ensemble.gate "U3" 1(%cst_13, %cst_11, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %269 = ensemble.gate "U3" 1(%cst_11, %cst_13, %cst_11) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %270 = ensemble.gate "U3" 1(%cst_11, %cst_13, %cst_11) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %271 = ensemble.gate "U3" 1(%cst_11, %cst_13, %cst_11) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %272 = ensemble.gate "U3" 1(%cst_13, %cst_13, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %273 = ensemble.gate "U3" 1(%cst_11, %cst_12, %cst_12) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %274 = ensemble.gate "U3" 1(%cst_13, %cst_11, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %275 = ensemble.gate "U3" 1(%cst_11, %cst_12, %cst_12) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %276 = ensemble.gate "U3" 1(%cst_11, %cst_12, %cst_12) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %277 = ensemble.gate "U3" 1(%cst_11, %cst_12, %cst_12) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %278 = ensemble.gate "U3" 1(%cst_11, %cst_13, %cst_11) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %279 = ensemble.gate "U3" 1(%cst_11, %cst_12, %cst_12) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %280 = ensemble.gate "U3" 1(%cst_13, %cst_13, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %281 = ensemble.gate "U3" 1(%cst_11, %cst_13, %cst_11) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %282 = ensemble.gate "U3" 1(%cst_13, %cst_11, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %283 = ensemble.gate "U3" 1(%cst_11, %cst_13, %cst_11) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %284 = ensemble.gate "U3" 1(%cst_11, %cst_12, %cst_12) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %285 = ensemble.gate "U3" 1(%cst_13, %cst_11, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %286 = ensemble.gate "U3" 1(%cst_13, %cst_13, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %287 = ensemble.gate "U3" 1(%cst_13, %cst_11, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %288 = ensemble.gate "U3" 1(%cst_11, %cst_13, %cst_11) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %289 = ensemble.gate "U3" 1(%cst_13, %cst_13, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %290 = ensemble.gate "U3" 1(%cst_11, %cst_12, %cst_12) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %291 = ensemble.gate "U3" 1(%cst_13, %cst_13, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %292 = ensemble.gate "U3" 1(%cst_13, %cst_11, %cst_13) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %293 = ensemble.gate_distribution %261, %262, %263, %264, %265, %266, %267, %268, %269, %270, %271, %272, %273, %274, %275, %276, %277, %278, %279, %280, %281, %282, %283, %284, %285, %286, %287, %288, %289, %290, %291, %292 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %293[%190] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %294 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %295 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %296 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %297 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %298 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %299 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %300 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %301 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %302 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %303 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %304 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %305 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %306 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %307 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %308 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %309 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %310 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %311 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %312 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %313 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %314 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %315 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %316 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %317 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %318 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %319 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %320 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %321 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %322 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %323 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %324 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %325 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %326 = ensemble.gate_distribution %294, %295, %296, %297, %298, %299, %300, %301, %302, %303, %304, %305, %306, %307, %308, %309, %310, %311, %312, %313, %314, %315, %316, %317, %318, %319, %320, %321, %322, %323, %324, %325 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %326[%224] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_31 = tensor.extract %10[%c8] : tensor<18xi32>
        %327 = arith.muli %extracted_31, %c2_i32 : i32
        %328 = arith.addi %327, %c1_i32 : i32
        ensemble.apply_distribution %8[%327] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%328] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_21, %extracted : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%327] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %329 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %330 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %331 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %332 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %333 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %334 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %335 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %336 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %337 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %338 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %339 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %340 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %341 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %342 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %343 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %344 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %345 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %346 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %347 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %348 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %349 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %350 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %351 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %352 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %353 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %354 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %355 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %356 = ensemble.gate "U3" 1(%cst_11, %cst_17, %cst_6) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %357 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %358 = ensemble.gate "U3" 1(%cst_11, %cst_5, %cst_4) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %359 = ensemble.gate "U3" 1(%cst_13, %cst_17, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %360 = ensemble.gate "U3" 1(%cst_13, %cst_3, %cst_19) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %361 = ensemble.gate_distribution %329, %330, %331, %332, %333, %334, %335, %336, %337, %338, %339, %340, %341, %342, %343, %344, %345, %346, %347, %348, %349, %350, %351, %352, %353, %354, %355, %356, %357, %358, %359, %360 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %361[%328] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_32 = tensor.extract %10[%c9] : tensor<18xi32>
        %362 = arith.muli %extracted_32, %c2_i32 : i32
        %363 = arith.addi %362, %c1_i32 : i32
        ensemble.apply_distribution %8[%362] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%363] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_21, %extracted : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        %364 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %365 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %366 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %367 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %368 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %369 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %370 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %371 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %372 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %373 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %374 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %375 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %376 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %377 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %378 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %379 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %380 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %381 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %382 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %383 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %384 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %385 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %386 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %387 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %388 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %389 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %390 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %391 = ensemble.gate "U3" 1(%cst_11, %cst_19, %cst_3) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %392 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %393 = ensemble.gate "U3" 1(%cst_11, %cst_4, %cst_5) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %394 = ensemble.gate "U3" 1(%cst_13, %cst_19, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %395 = ensemble.gate "U3" 1(%cst_13, %cst_6, %cst_17) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %396 = ensemble.gate_distribution %364, %365, %366, %367, %368, %369, %370, %371, %372, %373, %374, %375, %376, %377, %378, %379, %380, %381, %382, %383, %384, %385, %386, %387, %388, %389, %390, %391, %392, %393, %394, %395 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %396[%363] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %397 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %398 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %399 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %400 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %401 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %402 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %403 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %404 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %405 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %406 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %407 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %408 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %409 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %410 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %411 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %412 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %413 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %414 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %415 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %416 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %417 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %418 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %419 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %420 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %421 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %422 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %423 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %424 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %425 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %426 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %427 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %428 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %429 = ensemble.gate_distribution %397, %398, %399, %400, %401, %402, %403, %404, %405, %406, %407, %408, %409, %410, %411, %412, %413, %414, %415, %416, %417, %418, %419, %420, %421, %422, %423, %424, %425, %426, %427, %428 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %429[%362] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_33 = tensor.extract %10[%c10] : tensor<18xi32>
        %430 = arith.muli %extracted_33, %c2_i32 : i32
        %431 = arith.addi %430, %c1_i32 : i32
        ensemble.apply_distribution %8[%430] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%431] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_21, %extracted_20 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%430] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %432 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %433 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %434 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %435 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %436 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %437 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %438 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %439 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %440 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %441 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %442 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %443 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %444 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %445 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %446 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %447 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %448 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %449 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %450 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %451 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %452 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %453 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %454 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %455 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %456 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %457 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %458 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %459 = ensemble.gate "U3" 1(%cst_11, %cst_16, %cst_10) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %460 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %461 = ensemble.gate "U3" 1(%cst_11, %cst_9, %cst_8) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %462 = ensemble.gate "U3" 1(%cst_13, %cst_16, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %463 = ensemble.gate "U3" 1(%cst_13, %cst_7, %cst_18) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %464 = ensemble.gate_distribution %432, %433, %434, %435, %436, %437, %438, %439, %440, %441, %442, %443, %444, %445, %446, %447, %448, %449, %450, %451, %452, %453, %454, %455, %456, %457, %458, %459, %460, %461, %462, %463 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %464[%431] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_34 = tensor.extract %10[%c11] : tensor<18xi32>
        %465 = arith.muli %extracted_34, %c2_i32 : i32
        %466 = arith.addi %465, %c1_i32 : i32
        ensemble.apply_distribution %8[%465] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%466] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_21, %extracted_20 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%465] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %467 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %468 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %469 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %470 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %471 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %472 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %473 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %474 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %475 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %476 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %477 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %478 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %479 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %480 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %481 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %482 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %483 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %484 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %485 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %486 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %487 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %488 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %489 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %490 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %491 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %492 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %493 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %494 = ensemble.gate "U3" 1(%cst_11, %cst_18, %cst_7) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %495 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %496 = ensemble.gate "U3" 1(%cst_11, %cst_8, %cst_9) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %497 = ensemble.gate "U3" 1(%cst_13, %cst_18, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %498 = ensemble.gate "U3" 1(%cst_13, %cst_10, %cst_16) {"generated-by-merging-here", "nativized-created", "nativized-peeked"} : (f64, f64, f64) -> !ensemble.gate
        %499 = ensemble.gate_distribution %467, %468, %469, %470, %471, %472, %473, %474, %475, %476, %477, %478, %479, %480, %481, %482, %483, %484, %485, %486, %487, %488, %489, %490, %491, %492, %493, %494, %495, %496, %497, %498 : (!ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate, !ensemble.gate) -> !ensemble.gate_distribution
        ensemble.apply_distribution %499[%466] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_35 = tensor.extract %10[%c12] : tensor<18xi32>
        %500 = arith.muli %extracted_35, %c2_i32 : i32
        %501 = arith.addi %500, %c1_i32 : i32
        ensemble.apply_distribution %8[%500] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%501] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_36 = tensor.extract %10[%c13] : tensor<18xi32>
        %502 = arith.muli %extracted_36, %c2_i32 : i32
        %503 = arith.addi %502, %c1_i32 : i32
        ensemble.apply_distribution %8[%502] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%503] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_21, %extracted_22 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_20, %extracted : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%500] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%501] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%502] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%503] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_37 = tensor.extract %10[%c14] : tensor<18xi32>
        %504 = arith.muli %extracted_37, %c2_i32 : i32
        %505 = arith.addi %504, %c1_i32 : i32
        ensemble.apply_distribution %8[%504] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%505] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_38 = tensor.extract %10[%c15] : tensor<18xi32>
        %506 = arith.muli %extracted_38, %c2_i32 : i32
        %507 = arith.addi %506, %c1_i32 : i32
        ensemble.apply_distribution %8[%506] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%507] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_22, %extracted_21 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted, %extracted_20 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%504] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%505] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%506] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%507] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_39 = tensor.extract %10[%c16] : tensor<18xi32>
        %508 = arith.muli %extracted_39, %c2_i32 : i32
        %509 = arith.addi %508, %c1_i32 : i32
        ensemble.apply_distribution %8[%508] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%509] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        %extracted_40 = tensor.extract %10[%c17] : tensor<18xi32>
        %510 = arith.muli %extracted_40, %c2_i32 : i32
        %511 = arith.addi %510, %c1_i32 : i32
        ensemble.apply_distribution %8[%510] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %8[%511] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_21, %extracted_22 : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply %7 %extracted_20, %extracted : (!ensemble.gate, !ensemble.physical_qubit, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%508] {"cannot-merge"} %extracted_21 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%509] {"cannot-merge"} %extracted_22 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%510] {"cannot-merge"} %extracted_20 : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.apply_distribution %9[%511] {"cannot-merge"} %extracted : (!ensemble.gate_distribution, i32, !ensemble.physical_qubit) -> ()
        ensemble.transmit_results %1 : (tensor<4x!ensemble.cbit>) -> ()
      }
    }
    return
  }
}

