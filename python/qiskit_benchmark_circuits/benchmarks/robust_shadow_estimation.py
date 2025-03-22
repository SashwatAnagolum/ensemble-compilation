import collections

import qiskit
import numpy as np
import qiskit_ibm_runtime

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark
from qiskit_benchmark_circuits import circuit_construction_utils


class RobustShadowEstimationBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        num_circuits = 500000
        super().__init__(num_circuits, "Robust Shadow Estimation")

        self.num_qubits = 10
        self.num_layers = 4
        self.num_calibration_circuits = 250000
        self.num_estimation_circuits = 250000

        self.rx_params = np.random.sample((self.num_layers, self.num_qubits))
        self.rz_params = np.random.sample((self.num_layers, self.num_qubits))

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        circuit = qiskit.QuantumCircuit(self.num_qubits, self.num_qubits)
        pauli_indices = np.random.randint(0, 3, self.num_qubits)

        if index >= self.num_calibration_circuits:
            for layer in range(self.num_layers):
                for qubit in range(self.num_qubits):
                    circuit.rx(self.rx_params[layer][qubit], qubit)
                    circuit.rz(self.rz_params[layer][qubit], qubit)

                if layer < 3:
                    for qubit in range(self.num_qubits - 1):
                        circuit.cx(qubit, qubit + 1)

        circuit_construction_utils.add_local_pauli_measurements(
            circuit, list(range(10)), pauli_indices
        )

        return circuit
