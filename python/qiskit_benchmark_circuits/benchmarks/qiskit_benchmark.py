import abc

import qiskit


class QiskitBenchmark(abc.ABC):
    def __init__(self, num_circuits: int, benchmark_name: str) -> None:
        self.num_circuits = num_circuits
        self.name = benchmark_name

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        raise NotImplementedError("Use a subclass of QiskitBenchmark!")

    def __len__(self) -> int:
        return self.num_circuits

    def __iter__(self):
        for circuit_index in range(self.num_circuits):
            yield self._get_circuit(circuit_index)
