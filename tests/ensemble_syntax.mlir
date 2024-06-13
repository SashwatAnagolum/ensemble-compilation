// RUN: tutorial-opt %s

module {
  func.func @main(%arg0: !ensemble.qubit) -> !ensemble.qubit {
    return %arg0 : !ensemble.qubit
  }
}