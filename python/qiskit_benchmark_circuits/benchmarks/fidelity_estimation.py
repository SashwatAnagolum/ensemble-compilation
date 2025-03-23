import collections

import qiskit
import numpy as np
import qiskit_ibm_runtime

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark
from qiskit_benchmark_circuits import circuit_construction_utils


class FidelityEstimationBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        num_circuits = 512
        super().__init__(num_circuits, "Fidelity Estimation")

        self.num_qubits = 8

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        circuit = qiskit.QuantumCircuit(self.num_qubits, self.num_qubits)

        circuit.h(0)

        for i in range(7):
            circuit.cx(i, i + 1)

        circuit_construction_utils.add_local_pauli_measurements(
            circuit,
            list(range(self.num_qubits)),
        )

        return circuit
