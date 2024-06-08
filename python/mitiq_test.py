from functools import partial

import cirq
import numpy as np
from mitiq import MeasurementResult, Observable, PauliString
from mitiq.ddd import insert_ddd_sequences, rules
from mitiq.interface.mitiq_cirq import compute_density_matrix
from mitiq import zne, cdr


def idle_qubits(circuit, qubits, idle_steps):
    for step in range(idle_steps):
        circuit.append(cirq.I(q) for q in qubits)

    return circuit


def ghz(num_qubits, idle_steps=0):
    qubits = cirq.LineQubit.range(num_qubits)
    circuit = cirq.Circuit()

    for i in range(num_qubits):
        if i == 0: 
            circuit.append(cirq.H(qubits[0]))
        else:
            circuit.append(cirq.CNOT(qubits[0], qubits[i]))

            other_qubits = qubits[1:i] + qubits[i+1:]
            circuit = idle_qubits(circuit, other_qubits, idle_steps)
    
    return circuit


def simulate(circuit: cirq.Circuit) -> np.ndarray:
    return compute_density_matrix(circuit, noise_level=(0.0,))


def execute(
        circuit: cirq.Circuit, rz_noise: float = 0.02,
        depolar_noise: float = 0.005) -> MeasurementResult:
    circuit = circuit.with_noise(cirq.rz(rz_noise))
    circuit = circuit.with_noise(cirq.bit_flip(depolar_noise))
    circuit += cirq.measure(*sorted(circuit.all_qubits()), key="m")

    simulator = cirq.DensityMatrixSimulator()
    result = simulator.run(circuit, repetitions=1000)
    bitstrings = result.measurements["m"]

    return MeasurementResult(bitstrings)


num_qubits = 6
obs = Observable(PauliString("X" * num_qubits))

circuit = ghz(num_qubits, idle_steps=3)

rule = rules.yy
ddd_circuit = insert_ddd_sequences(circuit, rule)

zne_executor = zne.mitigate_executor(
    execute, observable=obs,
    scale_noise=zne.scaling.folding.fold_global
)

cdr_plus_zne_executor = cdr.mitigate_executor(
    zne_executor, observable=obs, simulator=simulate,
    num_training_circuits=10
)

ideal = obs.expectation(circuit, partial(execute, rz_noise=0.0, depolar_noise=0.0))
noisy = obs.expectation(circuit, execute)
noisy_ddd = obs.expectation(ddd_circuit, execute)
noisy_ddd_zne = zne_executor(ddd_circuit)
noisy_ddd_zne_cdr = cdr_plus_zne_executor(ddd_circuit)

print("Ideal:", "{:.5f}".format(ideal.real))
print("Unmitigated:", "{:.5f}".format(noisy.real))
print("DDD:", "{:.5f}".format(noisy_ddd.real))
print("DDD + ZNE:", "{:.5f}".format(noisy_ddd_zne))
print("DDD + ZNE + CDR:", "{:.5f}".format(noisy_ddd_zne_cdr))
