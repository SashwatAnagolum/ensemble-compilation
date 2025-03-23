import collections

import qiskit
import numpy as np
import qiskit_ibm_runtime

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark
from qiskit_benchmark_circuits import circuit_construction_utils


class EnergyEstimationBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        num_circuits = 8192
        super().__init__(num_circuits, "Hamiltonian Energy Estimation")

        self.num_qubits = 14
        self.num_layers = 4

        self.pauli_measurement_bases = np.random.randint(
            0, 3, (num_circuits, self.num_qubits)
        )

        self.hea_params = np.random.sample((self.num_layers + 1, self.num_qubits, 2))

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        circuit = qiskit.QuantumCircuit(self.num_qubits, self.num_qubits)

        for layer in range(self.num_layers):
            for qubit in range(self.num_qubits):
                circuit.ry(self.hea_params[layer, qubit, 0], qubit)
                circuit.rz(self.hea_params[layer, qubit, 1], qubit)

            for qubit in range(self.num_qubits - 1):
                circuit.cx(qubit, qubit + 1)

        for qubit in range(self.num_qubits):
            circuit.ry(self.hea_params[layer, qubit, 0], qubit)
            circuit.rz(self.hea_params[layer, qubit, 1], qubit)

        circuit_construction_utils.add_local_pauli_measurements(
            circuit,
            list(range(self.num_qubits)),
            self.pauli_measurement_bases[index],
        )

        return circuit
