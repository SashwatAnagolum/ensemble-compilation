// RUN: tutorial-opt %s

module {
  func.func @main(%arg0: !ensemble.qubit, %arg1: !ensemble.qubit) -> !ensemble.qubit {
    %0 = ensemble.gate1q "H" %arg0 : (!ensemble.qubit) -> (!ensemble.qubit)
    %1 = ensemble.gate1q "H" %arg1 : (!ensemble.qubit) -> (!ensemble.qubit)

    %2 = ensemble.gate1q "X" %0 : (!ensemble.qubit) -> (!ensemble.qubit)
    %3 = ensemble.gate1q "X" %1 : (!ensemble.qubit) -> (!ensemble.qubit)

    return %3: !ensemble.qubit
  }
}