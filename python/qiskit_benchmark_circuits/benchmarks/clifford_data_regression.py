import qiskit
import numpy as np

from typing import Generator

import qiskit.circuit

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark


class CDRBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        self.num_circuits = 100
        self.num_qubits = 16
        self.phase_gate_options = [
            qiskit.circuit.library.SGate(),
            qiskit.circuit.library.ZGate(),
            qiskit.circuit.library.SdgGate(),
            qiskit.circuit.library.IGate(),
        ]

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        circuit = qiskit.QuantumCircuit(self.num_qubits)

        for i in range(self.num_qubits):
            circuit.h(i)

        for layer in range(2):
            for i in range(self.num_qubits - 1):
                circuit.cx(i, i + 1)
                circuit.append(self.phase_gate_options[np.random.randint(4)], [i + 1])
                circuit.cx(i, i + 1)

            for i in range(self.num_qubits):
                circuit.s(i)
                circuit.sx(i)
                circuit.append(self.phase_gate_options[np.random.randint(4)], [i])
                circuit.sx(i)
                circuit.s(i)

        circuit.measure_all()

        return circuit
