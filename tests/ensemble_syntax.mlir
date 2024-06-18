// RUN: tutorial-opt %s

module {
  func.func @main(%arg0: !ensemble.qubit, %arg1: !ensemble.qubit) -> !ensemble.qubit {
    %0 = ensemble.gate1q "H" %arg0 : (!ensemble.qubit) -> (!ensemble.qubit)
    %1 = ensemble.gate1q "H" %arg1 : (!ensemble.qubit) -> (!ensemble.qubit)

    return %1: !ensemble.qubit
  }
}