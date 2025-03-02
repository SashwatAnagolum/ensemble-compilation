import qiskit
import numpy as np

from typing import Generator

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark


class CBBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        num_circuits = 1920
        super().__init__(num_circuits, "Cycle Benchmarking")

        self.pauli_cycle = [0, 1, 0, 1, 0, 1]
        self.num_qubits = 6
        self.num_pauli_randomizations = 64
        self.num_circuits_per_initial_state = 30
        self.cycle_repetitions = [4, 8, 12]

        x = qiskit.circuit.library.XGate()
        y = qiskit.circuit.library.YGate()
        z = qiskit.circuit.library.ZGate()

        self.pauli_gates = [x, y, z]
        self.edge_randomization_gates = [[y, y, x], [x, x, y], [x, y, z]]
        self.state_prep_gate_indices = None

    def _get_circuit(self, index):
        circuit_cycle_repetitions = self.cycle_repetitions[
            index % len(self.cycle_repetitions)
        ]

        if not (index % self.num_circuits_per_initial_state):
            self.state_prep_gate_indices = np.random.randint(0, 3, (self.num_qubits,))

        frame_randomization_gate_indices = np.random.randint(
            0, 3, (circuit_cycle_repetitions + 1, self.num_qubits)
        )

        circuit = qiskit.QuantumCircuit(self.num_qubits)

        for qubit in range(self.num_qubits):
            circuit.append(
                self.edge_randomization_gates[self.state_prep_gate_indices[qubit]][
                    frame_randomization_gate_indices[0][qubit]
                ],
                [qubit],
            )

        for rep_index in range(1, circuit_cycle_repetitions):
            for qubit in range(self.num_qubits):
                circuit.append(self.pauli_gates[self.pauli_cycle[qubit]], [qubit])
                circuit.append(
                    self.pauli_gates[
                        frame_randomization_gate_indices[rep_index][qubit]
                    ],
                    [qubit],
                )

        for qubit in range(self.num_qubits):
            circuit.append(self.pauli_gates[self.pauli_cycle[qubit]], [qubit])
            circuit.append(
                self.edge_randomization_gates[self.state_prep_gate_indices[qubit]][
                    frame_randomization_gate_indices[circuit_cycle_repetitions][qubit]
                ],
                [qubit],
            )

        circuit.measure_all()

        return circuit
