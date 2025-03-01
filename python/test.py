import numpy as np
import qiskit
import qiskit.qasm3
import time
import matplotlib.pyplot as plt
import pickle as pkl
import json

from read_identify_and_peel import read_identify_peel
from qiskit_benchmark_circuits.benchmarks import (
    CDRBenchmark,
    ZNEBenchmark,
    RandomizedCompilationBenchmark,
    PECBenchmark,
    CBBenchmark,
)

circuits = [circ for circ in CBBenchmark()]

rip = read_identify_peel.ReadIdentifyPeel()

start = time.time()
nativized_circuits = [rip.convert_1q_gates_to_zxzxz(circuit) for circuit in circuits]
natization_time = time.time() - start

naive_circuits_binary = pkl.dumps(
    [qiskit.qasm3.dumps(circuit) for circuit in nativized_circuits]
)

start = time.time()
circuit_templates, peeled_params, circuit_groups = (
    rip.get_templates_and_peeled_parameters(nativized_circuits, True)
)

binarized_ripped_circuits = pkl.dumps(
    (
        [qiskit.qasm3.dumps(circuit) for circuit in circuit_templates],
        [p.astype(np.float32) for p in peeled_params],
        circuit_groups,
    )
)

rip_time = time.time() - start

print(circuit_groups)

print([p.shape for p in peeled_params])

print(len(pkl.dumps([qiskit.qasm3.dumps(circuit) for circuit in circuit_templates])))
print(len(pkl.dumps([p.astype(np.float32) for p in peeled_params])))
print(len(pkl.dumps(circuit_groups)))

# print([len(qiskit.qasm3.dumps(circuit)) for circuit in nativized_circuits])
# print([len(qiskit.qasm3.dumps(circuit)) for circuit in circuit_templates])

# print(qiskit.qasm3.dumps(circuit_templates[0]))

print(
    f"Nativization time: {natization_time} | RIP time: {rip_time} | Storage size (naive): {len(naive_circuits_binary)} | Storage size (RIP): {len(binarized_ripped_circuits)}"
)
