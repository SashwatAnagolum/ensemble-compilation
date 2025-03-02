import collections

import qiskit
import numpy as np
import qiskit_ibm_runtime

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark
from qiskit_benchmark_circuits import circuit_construction_utils


class CharacterizingTopologicalOrderBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        num_circuits = 1024
        super().__init__(num_circuits, "Characterizing Topological Order")

        self.num_qubits = 8
        self.num_cbits = 9
        self.measured_qubits = [14, 10, 6, 19, 15, 11, 24, 20, 16]

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        circuit = qiskit.QuantumCircuit(self.num_qubits, self.num_cbits)

        for i in range(3):
            for j in range(4):
                circuit.h(9 * i + j)

        for i in range(3):
            for j in range(1, 3):
                circuit.cx(9 * i + j, 9 * i + j + 4)

        for i in range(3):
            for j in range(1, 3):
                circuit.cx(9 * i + j, 9 * i + j + 5)

        for i in range(3):
            circuit.cx(9 * i, 9 * i + 4)
            circuit.cx(9 * i + 3, 9 * i + 8)
            circuit.cx(9 * i + 5, 9 * i + 10)
            circuit.cx(9 * i + 7, 9 * i + 11)

        for i in range(3):
            circuit.cx(9 * i, 9 * i + 5)
            circuit.cx(9 * i + 3, 9 * i + 7)

        for i in range(3):
            circuit.cx(9 * i + 4, 9 * i + 9)
            circuit.cx(9 * i + 8, 9 * i + 12)

        circuit_construction_utils.add_local_pauli_measurements(
            circuit,
            self.measured_qubits,
        )

        return circuit
