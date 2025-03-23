import collections

import qiskit
import numpy as np
import qiskit_ibm_runtime

from qiskit_benchmark_circuits.benchmarks import qiskit_benchmark
from qiskit_benchmark_circuits import circuit_construction_utils

from qiskit_addon_cutting import (
    partition_problem,
    generate_cutting_experiments,
)

from qiskit_addon_cutting.instructions import Move


class WireCuttingBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        num_qubits = 9

        beta = np.random.sample((1,))
        gamma = np.random.sample((1,))

        circuit = qiskit.QuantumCircuit(num_qubits * 2)

        for qubit in [*range(9), *range(14, 18)]:
            circuit.h(qubit)

        for qubit in range(4):
            circuit.rzz(2 * beta[0], qubit, qubit + 1)

        for qubit in range(4):
            for other_qubit in range(5, 9):
                circuit.rzz(2 * beta[0], qubit, other_qubit)

        for qubit in range(4):
            circuit.rx(2 * gamma[0], qubit)

        for qubit in range(4, 9):
            circuit.append(Move(), [qubit, qubit + 5])

        for qubit in range(14, 18):
            for other_qubit in range(9, 14):
                circuit.rzz(2 * beta[0], qubit, other_qubit)

        for qubit in range(14, 17):
            circuit.rzz(2 * beta[0], qubit, qubit + 1)

        for qubit in range(9, 18):
            circuit.rx(2 * gamma[0], qubit)

        observable_expanded = qiskit.quantum_info.SparsePauliOp(["ZZZZIIIIIZZZZZZZZZ"])
        partitioned_problem = partition_problem(
            circuit=circuit,
            partition_labels="AAAAAAAAABBBBBBBBB",
            observables=observable_expanded.paulis,
        )

        subcircuits = partitioned_problem.subcircuits
        subobservables = partitioned_problem.subobservables

        subexperiments, _ = generate_cutting_experiments(
            circuits=subcircuits, observables=subobservables, num_samples=np.inf
        )

        self.top_circuits = subexperiments["A"]
        self.bottom_circuits = subexperiments["B"]

        num_circuits = len(self.top_circuits) + len(self.bottom_circuits)
        super().__init__(num_circuits, "Wire Cutting")

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        return (
            self.top_circuits[index // 2]
            if index % 2 == 0
            else self.bottom_circuits[index // 2]
        )
