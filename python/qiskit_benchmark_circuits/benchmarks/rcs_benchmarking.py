import collections

import qiskit
import numpy as np
import qiskit_ibm_runtime

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark
from qiskit_benchmark_circuits import circuit_construction_utils


class RCSBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self, backend: qiskit_ibm_runtime.ibm_backend.IBMBackend) -> None:
        num_circuits = 640
        super().__init__(num_circuits, "RCS")

        self.num_qubits = 16
        self.num_circuits_per_depth = 32
        self.depths = [2 * i for i in range(1, 21)]

        self.connectivity = collections.defaultdict(list)

        for edge in backend.coupling_map:
            self.connectivity[edge[0]].append(edge[1])
            self.connectivity[edge[1]].append(edge[0])

        i = qiskit.circuit.library.IGate()
        x = qiskit.circuit.library.XGate()
        y = qiskit.circuit.library.YGate()
        z = qiskit.circuit.library.ZGate()
        h = qiskit.circuit.library.HGate()

        self.pauli_gates = [i, x, y, z]
        self.clifford_gates = [x, y, z, h]

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        circuit = qiskit.QuantumCircuit(self.num_qubits)

        circuit_depth = self.depths[index // self.num_circuits_per_depth]
        num_cnots = np.random.randint(
            0,
            (self.num_qubits // 2) + 1,
            (circuit_depth // 2,),
        )

        pauli_indices = np.random.randint(0, 4, (circuit_depth + 1, self.num_qubits))
        initial_clifford_indices = np.random.randint(0, 4, (self.num_qubits,))
        clifford_indices = np.random.randint(
            0, 4, (circuit_depth // 2, self.num_qubits)
        )

        cnot_layer_indices = [
            circuit_construction_utils.get_cnot_layer_indices(
                self.connectivity,
                range(self.num_qubits),
                num_cnots_in_layer,
            ).flatten()
            for num_cnots_in_layer in num_cnots
        ]

        for qubit in range(self.num_qubits):
            circuit.append(
                self.clifford_gates[initial_clifford_indices[qubit]], [qubit]
            )
            circuit.append(self.pauli_gates[pauli_indices[0, qubit]], [qubit])

        for layer in range(circuit_depth // 2):
            for cnot_index in range(cnot_layer_indices[layer].shape[0] // 2):
                circuit.cx(
                    cnot_layer_indices[layer][2 * cnot_index],
                    cnot_layer_indices[layer][2 * cnot_index + 1],
                )

            for qubit in range(self.num_qubits):
                if qubit not in cnot_layer_indices[layer]:
                    circuit.append(
                        self.clifford_gates[clifford_indices[layer, qubit]], [qubit]
                    )

                circuit.append(
                    self.pauli_gates[pauli_indices[layer + 1, qubit]], [qubit]
                )

        for inv_layer in range(circuit_depth // 2 - 1, -1, -1):
            for cnot_index in range(cnot_layer_indices[inv_layer].shape[0] // 2):
                circuit.cx(
                    cnot_layer_indices[inv_layer][2 * cnot_index],
                    cnot_layer_indices[inv_layer][2 * cnot_index + 1],
                )

            for qubit in range(self.num_qubits):
                if qubit not in cnot_layer_indices[inv_layer]:
                    circuit.append(
                        self.clifford_gates[clifford_indices[inv_layer, qubit]], [qubit]
                    )

                circuit.append(
                    self.pauli_gates[pauli_indices[circuit_depth - inv_layer, qubit]],
                    [qubit],
                )

        for qubit in range(self.num_qubits):
            circuit.append(
                self.clifford_gates[initial_clifford_indices[qubit]],
                [qubit],
            )

        circuit.measure_all()

        return circuit
