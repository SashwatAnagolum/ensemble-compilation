import collections

import qiskit
import numpy as np
import qiskit_ibm_runtime

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark
from qiskit_benchmark_circuits import circuit_construction_utils


class CLOPSHBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self, backend: qiskit_ibm_runtime.ibm_backend.IBMBackend) -> None:
        num_circuits = 1000
        super().__init__(num_circuits, "CLOPS-H")

        self.num_different_circuits = 100
        self.num_parameterizations_per_circuit = 10
        self.num_qubits = 16  # backend.num_qubits
        self.num_layers = self.num_qubits
        self.connectivity = collections.defaultdict(list)

        for edge in backend.coupling_map:
            self.connectivity[edge[0]].append(edge[1])
            self.connectivity[edge[1]].append(edge[0])

        self.current_edges = None

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        circuit = qiskit.QuantumCircuit(self.num_qubits)

        if not (index % self.num_parameterizations_per_circuit):
            self.current_edges = [
                circuit_construction_utils.get_cnot_layer_indices(
                    self.connectivity, range(self.num_qubits), self.num_qubits // 2
                ).flatten()
                for i in range(self.num_layers)
            ]

        params = 2 * np.pi * np.random.sample((self.num_layers, self.num_qubits))

        for layer in range(self.num_layers):
            for cnot_index in range(len(self.current_edges[layer]) // 2):
                circuit.ecr(
                    self.current_edges[layer][2 * cnot_index],
                    self.current_edges[layer][2 * cnot_index + 1],
                )

            for qubit in range(self.num_qubits):
                circuit.sx(qubit)
                circuit.x(qubit)
                circuit.rz(params[layer, qubit], qubit)

        return circuit
