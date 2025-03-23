import collections

import qiskit
import numpy as np
import qiskit_ibm_runtime

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark
from qiskit_benchmark_circuits import circuit_construction_utils


class ShadowQPTBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        num_circuits = 1024
        super().__init__(num_circuits, "ShadowQPT")

        self.num_qubits = 4

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
        circuit = qiskit.QuantumCircuit(self.num_qubits)

        state_prep_indices = np.random.randint(0, 6, (self.num_qubits,))
        measurement_indices = np.random.randint(0, 6, (self.num_qubits,))

        for qubit in range(self.num_qubits):
            for i in range(3):
                circuit.append(
                    self.pauli_measurement_shifts[state_prep_indices[qubit]][
                        i
                    ].inverse(),
                    [qubit],
                )

        circuit.h(0)

        for qubit in range(self.num_qubits - 1):
            circuit.cx(qubit, qubit + 1)

        for qubit in range(self.num_qubits):
            for i in range(3):
                circuit.append(
                    self.pauli_measurement_shifts[measurement_indices[qubit]][i],
                    [qubit],
                )

        circuit.measure_all()

        return circuit
