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


class GateCuttingBenchmark(qiskit_benchmark.QiskitBenchmark):
    def __init__(self) -> None:
        num_qubits = 4
        qc = qiskit.circuit.library.EfficientSU2(
            num_qubits, entanglement="linear", reps=4
        ).decompose()

        qc.assign_parameters([0.1] * len(qc.parameters), inplace=True)

        observable = qiskit.quantum_info.SparsePauliOp(["ZZII", "IZZI", "-IIZZ"])

        partitioned_problem = partition_problem(
            circuit=qc,
            partition_labels="AABB",
            observables=observable.paulis,
        )

        subcircuits = partitioned_problem.subcircuits
        subobservables = partitioned_problem.subobservables

        subexperiments, _ = generate_cutting_experiments(
            circuits=subcircuits,
            observables=subobservables,
            num_samples=np.inf,
        )

        self.top_circuits = subexperiments["A"]
        self.bottom_circuits = subexperiments["B"]

        num_circuits = len(self.top_circuits) + len(self.bottom_circuits)
        super().__init__(num_circuits, "Gate Cutting")

    def _get_circuit(self, index: int) -> qiskit.QuantumCircuit:
        return (
            self.top_circuits[index // 2]
            if index % 2 == 0
            else self.bottom_circuits[index // 2]
        )
