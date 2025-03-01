import abc

import qiskit


class QiskitBenchmark(abc.ABC):
    def __init__(self, num_circuits: int) -> None:
        self.num_circuits = num_circuits

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        raise NotImplementedError("Use a subclass of QiskitBenchmark!")

    def __iter__(self):
        for circuit_index in range(self.num_circuits):
            yield self._get_circuit(circuit_index)
