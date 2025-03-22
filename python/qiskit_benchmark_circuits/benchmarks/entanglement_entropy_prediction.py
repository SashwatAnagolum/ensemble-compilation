import collections

import qiskit
import numpy as np
import qiskit_ibm_runtime

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark
from qiskit_benchmark_circuits import circuit_construction_utils


class EntanglementEntropyBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        num_circuits = 512
        super().__init__(num_circuits, "Entanglement Entropy Prediction")

        self.num_qubits = 10

        i = qiskit.circuit.library.IGate()
        x = qiskit.circuit.library.XGate()
        s = qiskit.circuit.library.SGate()
        h = qiskit.circuit.library.HGate()

        self.pauli_measurement_shifts = [
            [i, i, i],
            [i, h, i],
            [s, h, i],
            [i, i, x],
            [i, h, x],
            [s, h, x],
        ]

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        circuit = qiskit.QuantumCircuit(self.num_qubits, self.num_qubits)

        circuit.h(0)

        for qubit in range(self.num_qubits - 1):
            circuit.cx(qubit, qubit + 1)

        circuit_construction_utils.add_local_pauli_measurements(
            circuit,
            list(range(self.num_qubits)),
        )

        return circuit
