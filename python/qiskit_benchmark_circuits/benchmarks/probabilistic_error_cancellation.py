import qiskit
import numpy as np

from typing import Generator

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark


class PECBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        num_circuits = 250
        super().__init__(num_circuits, "PEC")

        self.num_qubits = 8
        self.num_layers = 8

        self.beta_values = [0.21, 0.24, 0.13, 0.1, 0.8, 0.1, 0.23, 0.5]
        self.gamma_values = [0.1, 0.2, 0.1, 0.13, 0.5, 0.6, 0.3, 0.5]

        self.sx_gate_probs = [0.97, 0.01, 0.01, 0.01]
        self.sx_gate_choices = [
            [(qiskit.circuit.library.SXGate(), [0])],
            [(qiskit.circuit.library.XGate(), [0])],
            [(qiskit.circuit.library.ZGate(), [0])],
            [(qiskit.circuit.library.YGate(), [0])],
        ]

        self.cnot_gate_probs = [0.96, 0.02, 0.02]
        self.cnot_gate_choices = [
            [(qiskit.circuit.library.CXGate(), [0, 1])],
            [
                (qiskit.circuit.library.CXGate(), [0, 1]),
                (qiskit.circuit.library.ZGate(), [0]),
            ],
            [
                (qiskit.circuit.library.CXGate(), [0, 1]),
                (qiskit.circuit.library.ZGate(), [0]),
            ],
        ]

    def sample_and_append_operation(
        self,
        circuit: qiskit.QuantumCircuit,
        gate_choices: list[tuple[qiskit.circuit.singleton.SingletonGate, list[int]]],
        gate_probs: list[float],
        targets: list[int],
    ):
        sampled_operation = gate_choices[
            np.random.choice(len(gate_choices), p=gate_probs)
        ]

        for op in sampled_operation:
            circuit.append(
                op[0],
                [targets[target_index] for target_index in op[1]],
            )

        return circuit

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        circuit = qiskit.QuantumCircuit(self.num_qubits)

        circuit.h(range(self.num_qubits))

        for layer in range(self.num_layers):
            for qubit in range(self.num_qubits):
                circuit.s(qubit)
                self.sample_and_append_operation(
                    circuit, self.sx_gate_choices, self.sx_gate_probs, [qubit]
                )

                circuit.rz(self.beta_values[layer], qubit)
                self.sample_and_append_operation(
                    circuit, self.sx_gate_choices, self.sx_gate_probs, [qubit]
                )

                circuit.s(qubit)

            for qubit in range(self.num_qubits - 1):
                self.sample_and_append_operation(
                    circuit,
                    self.cnot_gate_choices,
                    self.cnot_gate_probs,
                    [qubit, qubit + 1],
                )

                circuit.rz(self.gamma_values[layer], qubit + 1)
                self.sample_and_append_operation(
                    circuit,
                    self.cnot_gate_choices,
                    self.cnot_gate_probs,
                    [qubit, qubit + 1],
                )

        circuit.measure_all()

        return circuit
