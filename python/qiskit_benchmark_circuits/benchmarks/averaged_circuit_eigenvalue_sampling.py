import collections

import qiskit
import numpy as np
import qiskit_ibm_runtime

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark
from qiskit_benchmark_circuits import circuit_construction_utils


class ACESBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self, backend: qiskit_ibm_runtime.ibm_backend.IBMBackend) -> None:
        num_circuits = 200000
        super().__init__(num_circuits, "ACES")

        self.num_qubits = 16
        self.num_base_circuits = 20
        self.num_randomizations_per_circuit = 10000
        self.min_depth = 2
        self.max_depth = 100

        self.connectivity = collections.defaultdict(list)

        for edge in backend.coupling_map:
            self.connectivity[edge[0]].append(edge[1])
            self.connectivity[edge[1]].append(edge[0])

        self.current_cnot_indices = None
        self.current_hadamard_indices = None
        self.current_s_indices = None
        self.current_depth = None

    def add_dressed_aces_layer(
        self,
        circuit: qiskit.QuantumCircuit,
        cnot_indices: list[tuple[int, int]],
        hadamard_indices: list[int],
        s_indices: list[int],
    ) -> qiskit.QuantumCircuit:
        i = qiskit.circuit.library.IGate()
        x = qiskit.circuit.library.XGate()
        y = qiskit.circuit.library.YGate()
        z = qiskit.circuit.library.ZGate()

        cnot_pauli_left_frames = [
            [i, i],
            [i, x],
            [i, y],
            [i, z],
            [x, i],
            [x, x],
            [x, y],
            [x, z],
            [y, i],
            [y, x],
            [y, y],
            [y, z],
            [z, i],
            [z, x],
            [z, y],
            [z, z],
        ]

        cnot_pauli_right_frames = [
            [i, i],
            [i, x],
            [z, y],
            [z, z],
            [x, x],
            [x, i],
            [y, z],
            [y, y],
            [y, x],
            [y, i],
            [x, z],
            [x, y],
            [z, i],
            [z, x],
            [i, y],
            [i, z],
        ]

        hadamard_pauli_left_frames = [i, x, y, z]
        hadamard_pauli_right_frames = [i, y, x, z]
        s_pauli_left_frames = [i, x, y, z]
        s_pauli_right_frames = [i, z, y, x]

        cnot_pauli_indices = np.random.randint(0, 16, (len(cnot_indices),))
        hadamard_pauli_indices = np.random.randint(0, 4, (len(hadamard_indices),))
        s_pauli_indices = np.random.randint(0, 4, (len(s_indices),))

        for cnot_index, cnot_pair in enumerate(cnot_indices):
            control, target = cnot_pair

            circuit.append(
                cnot_pauli_left_frames[cnot_pauli_indices[cnot_index]][0], [control]
            )
            circuit.append(
                cnot_pauli_left_frames[cnot_pauli_indices[cnot_index]][1], [target]
            )

            circuit.cx(control, target)

            circuit.append(
                cnot_pauli_right_frames[cnot_pauli_indices[cnot_index]][0], [control]
            )
            circuit.append(
                cnot_pauli_right_frames[cnot_pauli_indices[cnot_index]][1], [target]
            )

        for qubit_index, qubit in enumerate(hadamard_indices):
            circuit.append(
                hadamard_pauli_left_frames[hadamard_pauli_indices[qubit_index]], [qubit]
            )
            circuit.h(qubit)
            circuit.append(
                hadamard_pauli_right_frames[hadamard_pauli_indices[qubit_index]],
                [qubit],
            )

        for qubit_index, qubit in enumerate(s_indices):
            circuit.append(s_pauli_left_frames[s_pauli_indices[qubit_index]], [qubit])
            circuit.s(qubit)
            circuit.append(s_pauli_right_frames[s_pauli_indices[qubit_index]], [qubit])

        return circuit

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        circuit = qiskit.QuantumCircuit(self.num_qubits)

        if not (index % self.num_randomizations_per_circuit):
            self.current_depth = np.random.randint(self.min_depth, self.max_depth + 1)
            self.current_cnot_indices = []
            self.current_hadamard_indices = []
            self.current_s_indices = []

            for layer in range(self.current_depth):
                max_num_cnots = np.random.randint(0, self.num_qubits // 2 + 1)
                self.current_cnot_indices.append(
                    circuit_construction_utils.get_cnot_layer_indices(
                        self.connectivity, range(self.num_qubits), max_num_cnots
                    )
                )

                num_hadamards = np.random.randint(
                    0, self.num_qubits - (2 * len(self.current_cnot_indices[-1])) + 1
                )

                hadamard_probs = np.ones((self.num_qubits,))
                hadamard_probs[
                    [
                        qubit
                        for cnot_pair in self.current_cnot_indices[-1]
                        for qubit in cnot_pair
                    ]
                ] = 0.0

                hadamard_probs /= np.sum(hadamard_probs)
                self.current_hadamard_indices.append(
                    list(
                        np.random.choice(
                            self.num_qubits,
                            num_hadamards,
                            p=hadamard_probs,
                        )
                    )
                )

                hadamard_probs[self.current_hadamard_indices[-1]] = 0
                self.current_s_indices.append(
                    list(np.argwhere(hadamard_probs).flatten())
                )

        for layer in range(self.current_depth):
            self.add_dressed_aces_layer(
                circuit,
                self.current_cnot_indices[layer],
                self.current_hadamard_indices[layer],
                self.current_s_indices[layer],
            )

        circuit.measure_all()

        return circuit
