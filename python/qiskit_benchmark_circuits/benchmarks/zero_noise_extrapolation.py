import qiskit

from typing import Generator

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark


class ZNEBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        num_circuits = 9
        self.num_qubits = 21

        super().__init__(num_circuits, "ZNE")

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        circuit = qiskit.QuantumCircuit(self.num_qubits)

        circuit.h(range(self.num_qubits))

        for _ in range(index):
            circuit.h(range(self.num_qubits))
            circuit.h(range(self.num_qubits))

        for qubit in range(self.num_qubits - 1):
            circuit.cx(qubit, qubit + 1)

            for _ in range(index):
                circuit.cx(qubit, qubit + 1)
                circuit.cx(qubit, qubit + 1)

        circuit.measure_all()

        return circuit
