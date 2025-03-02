import numpy as np
import qiskit
import qiskit.qasm3
import time
import matplotlib.pyplot as plt
import pickle as pkl
import json
import tqdm
import os

from qiskit_ibm_runtime import QiskitRuntimeService

from read_identify_and_peel import read_identify_peel
from qiskit_benchmark_circuits.benchmarks import (
    CDRBenchmark,
    ZNEBenchmark,
    RandomizedCompilationBenchmark,
    PECBenchmark,
    CBBenchmark,
    ACESBenchmark,
    RCSBenchmark,
    ShadowQPTBenchmark,
    EntanglementEntropyBenchmark,
    FidelityEstimationBenchmark,
    CharacterizingTopologicalOrderBenchmark,
    CLOPSHBenchmark,
    VNCDRBenchmark,
    EnergyEstimationBenchmark,
    EnergyEstimationWithZNEAndRCBenchmark,
    RobustShadowEstimationBenchmark,
    GateCuttingBenchmark,
    WireCuttingBenchmark,
)

backend_name = "ibm_kyiv"
backend = QiskitRuntimeService(
    channel="ibm_quantum",
    token="c0ed0f977fc96d511605341385f656a6f645fad36841935e8607da73c66b88d94fc4f0039f31fcb5deb38050ed690e95d6bdef43a2601351aff0d547a0da5af8",
).backend(backend_name)

for benchmark in [
    CDRBenchmark(),
    ZNEBenchmark(),
    RandomizedCompilationBenchmark(),
    PECBenchmark(),
    CBBenchmark(),
    RCSBenchmark(backend),
    ShadowQPTBenchmark(),
    EntanglementEntropyBenchmark(),
    FidelityEstimationBenchmark(),
    CharacterizingTopologicalOrderBenchmark(),
    VNCDRBenchmark(),
    EnergyEstimationBenchmark(),
    GateCuttingBenchmark(),
    WireCuttingBenchmark(),
    CLOPSHBenchmark(backend),
    RobustShadowEstimationBenchmark(),
    # ACESBenchmark(backend),
    # EnergyEstimationWithZNEAndRCBenchmark(),
]:
    print(f"Benchmark: {benchmark.name}\n")

    circuits = [
        circ
        for circ in tqdm.tqdm(
            benchmark,
            desc="Creating circuits",
        )
    ]

    rip = read_identify_peel.ReadIdentifyPeel()

    start = time.time()
    nativized_circuits = [
        rip.convert_1q_gates_to_zxzxz(circuit)
        for circuit in tqdm.tqdm(
            circuits,
            desc="Nativizing circuits",
        )
    ]

    natization_time = time.time() - start

    naive_circuits_binary = pkl.dumps(
        [
            qiskit.qasm3.dumps(circuit)
            for circuit in tqdm.tqdm(
                nativized_circuits,
                desc="Binarizing naive circuits",
            )
        ]
    )

    start = time.time()
    circuit_templates, peeled_params, circuit_groups = (
        rip.get_templates_and_peeled_parameters(nativized_circuits, True)
    )

    binarized_params = pkl.dumps([p.astype(np.float32) for p in peeled_params])
    binarized_circuits = pkl.dumps(
        [qiskit.qasm3.dumps(circuit) for circuit in circuit_templates]
    )
    binarized_circuit_groups = pkl.dumps(circuit_groups)

    total_binary_size = (
        len(binarized_params) + len(binarized_circuits) + len(binarized_circuit_groups)
    )

    rip_time = time.time() - start

    print(
        f"Nativization time: {natization_time} | RIP time: {rip_time} | Storage size (naive): {len(naive_circuits_binary)} | Storage size (RIP): {total_binary_size}"
    )

    print(
        f"% of memory used by:\nParameters: {100 * len(binarized_params) / total_binary_size}% | Circuit templates: {100 * len(binarized_circuits) / total_binary_size} | Circuit grouping information: {100 * len(binarized_circuit_groups) / total_binary_size}\nCircuit groups: {len(circuit_groups)}"
    )

    print("\n\n")

    save_folder = os.path.join(
        "./eval_results/circuits",
        benchmark.name.replace(" ", "_"),
    )

    if not os.path.exists(save_folder):
        os.makedirs(save_folder)

    pkl.dump(
        nativized_circuits,
        open(
            os.path.join(save_folder, "qiskit_nativized_circuits.pkl"),
            "wb",
        ),
    )

    pkl.dump(
        circuit_templates,
        open(
            os.path.join(save_folder, "rip_circuit_templates.pkl"),
            "wb",
        ),
    )

    pkl.dump(
        [p.astype(np.float32) for p in peeled_params],
        open(
            os.path.join(save_folder, "rip_parameters.pkl"),
            "wb",
        ),
    )

    pkl.dump(
        circuit_groups,
        open(
            os.path.join(save_folder, "rip_circuit_groups.pkl"),
            "wb",
        ),
    )
