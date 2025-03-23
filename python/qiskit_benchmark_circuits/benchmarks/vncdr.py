import collections

import qiskit
import numpy as np
import qiskit_ibm_runtime

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark
from qiskit_benchmark_circuits import circuit_construction_utils


class VNCDRBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        num_circuits = 500
        super().__init__(num_circuits, "vnCDR")

        self.zne_repetitions = [0, 1, 2, 3, 4]
        self.num_repetitions = len(self.zne_repetitions)
        self.num_clifford_circuits_per_repetition = 100
        self.num_qubits = 8
        self.num_layers = 4

        self.phase_gate_options = [
            qiskit.circuit.library.SGate(),
            qiskit.circuit.library.ZGate(),
            qiskit.circuit.library.SdgGate(),
            qiskit.circuit.library.IGate(),
        ]

        self.phase_gate_inverse_options = [
            qiskit.circuit.library.SdgGate(),
            qiskit.circuit.library.ZGate(),
            qiskit.circuit.library.SGate(),
            qiskit.circuit.library.IGate(),
        ]

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        circuit = qiskit.QuantumCircuit(self.num_qubits, self.num_qubits)

        circuit_num_repetitions = self.zne_repetitions[
            index // self.num_clifford_circuits_per_repetition
        ]

        phase_gate_powers = np.random.randint(
            0, 4, (2 * self.num_layers, self.num_qubits)
        )
        circuit.h(range(self.num_qubits))

        for repetition in range(circuit_num_repetitions):
            circuit.h(range(self.num_qubits))
            circuit.h(range(self.num_qubits))

        for layer_index in range(self.num_layers):
            for qubit in range(self.num_qubits - 1):
                circuit.cx(qubit, qubit + 1)

                for repetition in range(circuit_num_repetitions):
                    circuit.cx(qubit, qubit + 1)
                    circuit.cx(qubit, qubit + 1)

                circuit.append(
                    self.phase_gate_options[
                        phase_gate_powers[2 * layer_index, qubit + 1]
                    ],
                    [qubit + 1],
                )

                for repetition in range(circuit_num_repetitions):
                    circuit.append(
                        self.phase_gate_options[
                            phase_gate_powers[2 * layer_index, qubit + 1]
                        ],
                        [qubit + 1],
                    )

                    circuit.append(
                        self.phase_gate_inverse_options[
                            phase_gate_powers[2 * layer_index, qubit + 1]
                        ],
                        [qubit + 1],
                    )

                circuit.cx(qubit, qubit + 1)

                for repetition in range(circuit_num_repetitions):
                    circuit.cx(qubit, qubit + 1)
                    circuit.cx(qubit, qubit + 1)

            for qubit in range(self.num_qubits):
                circuit.s(qubit)

                for repetition in range(circuit_num_repetitions):
                    circuit.s(qubit)
                    circuit.sdg(qubit)

                circuit.sx(qubit)

                for repetition in range(circuit_num_repetitions):
                    circuit.sx(qubit)
                    circuit.sxdg(qubit)

                circuit.append(
                    self.phase_gate_options[
                        phase_gate_powers[2 * layer_index + 1, qubit]
                    ],
                    [qubit],
                )

                for repetition in range(circuit_num_repetitions):
                    circuit.append(
                        self.phase_gate_options[
                            phase_gate_powers[2 * layer_index + 1, qubit]
                        ],
                        [qubit],
                    )

                    circuit.append(
                        self.phase_gate_inverse_options[
                            phase_gate_powers[2 * layer_index + 1, qubit]
                        ],
                        [qubit],
                    )

                circuit.sx(qubit)

                for repetition in range(circuit_num_repetitions):
                    circuit.sx(qubit)
                    circuit.sxdg(qubit)

                circuit.s(qubit)

                for repetition in range(circuit_num_repetitions):
                    circuit.s(qubit)
                    circuit.sdg(qubit)

        return circuit
