// RUN: tutorial-opt %s

module {
  func.func @main(%arg0: !ensemble.qubit, %arg1: !ensemble.qubit) -> !ensemble.qubit {
    // sample an int in [0, 2]
    %0 = ensemble.int_uniform 0 , 3 : () -> (i32)

    // sample an int in [0, 1]
    %1 = ensemble.int_uniform 0 , 2 : () -> (i32)

    // sample an int in [0, 5] with non-unform probabilities
    %2 = ensemble.int_categorical 0, [0.3, 0.2, 0.1, 0.1, 0.05, 0.25] : () -> (i32)

    %3 = ensemble.gate_distribution_1q [ "H", "X", "Z" ] [ %0 ] %arg0 : (!ensemble.qubit , i32) -> (!ensemble.qubit)
    %4, %5 = ensemble.gate_distribution_2q [ "CZ", "CX" ] [ %1 ] %3, %arg1 : (!ensemble.qubit , !ensemble.qubit, i32) -> (!ensemble.qubit , !ensemble.qubit)
    %6 = ensemble.gate_distribution_1q [ "H", "X", "Y", "Z", "S", "T" ] [ %2 ] %5 : (!ensemble.qubit , i32) -> (!ensemble.qubit)

    return %6: !ensemble.qubit
  }
}