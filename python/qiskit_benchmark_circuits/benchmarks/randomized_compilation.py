import qiskit
import numpy as np

from typing import Generator

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark


class RandomizedCompilationBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        num_circuits = 1024
        self.num_qubits = 4

        super().__init__(num_circuits, "Randomized Compilation")

    def add_hard_cycle(
        self,
        circuit: qiskit.QuantumCircuit,
        cnot_pairs: list[tuple[int, int]],
        num_qubits: int,
    ) -> qiskit.QuantumCircuit:
        i = qiskit.circuit.library.IGate()
        x = qiskit.circuit.library.XGate()
        y = qiskit.circuit.library.YGate()
        z = qiskit.circuit.library.ZGate()

        pauli_left_frames = [
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

        pauli_right_frames = [
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

        pauli_frame_indices = np.random.randint(0, 16, (len(cnot_pairs),))
        pauli_frame_indices_trivial = np.random.randint(0, 16, ((num_qubits + 1) // 2,))
        flattened_cnot_qubits = [
            qubit for cnot_pair in cnot_pairs for qubit in cnot_pair
        ]

        for qubit in range(num_qubits):
            if qubit not in flattened_cnot_qubits:
                circuit.append(
                    pauli_left_frames[pauli_frame_indices_trivial[qubit // 2]][
                        qubit % 2
                    ],
                    [qubit],
                )

        for pair_index, cnot_pair in enumerate(cnot_pairs):
            circuit.append(
                pauli_left_frames[pauli_frame_indices[pair_index]][0], [cnot_pair[0]]
            )
            circuit.append(
                pauli_left_frames[pauli_frame_indices[pair_index]][1], [cnot_pair[1]]
            )
            circuit.cx(cnot_pair[0], cnot_pair[1])
            circuit.append(
                pauli_right_frames[pauli_frame_indices[pair_index]][0], [cnot_pair[0]]
            )
            circuit.append(
                pauli_right_frames[pauli_frame_indices[pair_index]][1], [cnot_pair[1]]
            )

        for qubit in range(num_qubits):
            if qubit not in flattened_cnot_qubits:
                circuit.append(
                    pauli_left_frames[pauli_frame_indices_trivial[qubit // 2]][
                        qubit % 2
                    ],
                    [qubit],
                )

        return circuit

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        circuit = qiskit.QuantumCircuit(self.num_qubits)

        circuit.h(range(self.num_qubits))

        circuit.rz(np.pi / 4, 1)
        circuit.rz(np.pi / 8, 2)
        circuit.rz(np.pi / 8, 3)

        self.add_hard_cycle(circuit, [(1, 0)], self.num_qubits)

        circuit.rz(-np.pi / 4, 0)

        self.add_hard_cycle(circuit, [(1, 0)], self.num_qubits)

        circuit.rz(np.pi / 4, 0)

        self.add_hard_cycle(circuit, [(2, 0)], self.num_qubits)

        circuit.rz(-np.pi / 8, 0)

        self.add_hard_cycle(circuit, [(2, 0)], self.num_qubits)

        circuit.rz(np.pi / 8, 0)
        circuit.rz(np.pi / 4, 2)

        self.add_hard_cycle(circuit, [(3, 0), (2, 1)], self.num_qubits)

        circuit.rz(-np.pi / 16, 0)
        circuit.rz(-np.pi / 4, 1)

        self.add_hard_cycle(circuit, [(3, 0), (2, 1)], self.num_qubits)

        circuit.rz(np.pi / 16, 0)
        circuit.rz(np.pi / 4, 1)
        circuit.rz(np.pi / 8, 3)

        self.add_hard_cycle(circuit, [(3, 1)], self.num_qubits)

        circuit.rz(-np.pi / 8, 1)

        self.add_hard_cycle(circuit, [(3, 1)], self.num_qubits)

        circuit.rz(np.pi / 8, 1)
        circuit.rz(np.pi / 4, 3)

        self.add_hard_cycle(circuit, [(3, 2)], self.num_qubits)

        circuit.rz(-np.pi / 4, 2)

        self.add_hard_cycle(circuit, [(3, 2)], self.num_qubits)

        circuit.rz(np.pi / 4, 2)

        self.add_hard_cycle(circuit, [(3, 0), (2, 1)], self.num_qubits)
        self.add_hard_cycle(circuit, [(0, 3), (1, 2)], self.num_qubits)
        self.add_hard_cycle(circuit, [(3, 0), (2, 1)], self.num_qubits)

        circuit.measure_all()

        return circuit
