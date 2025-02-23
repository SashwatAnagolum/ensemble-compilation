import numpy as np
import qiskit

from read_identify_and_peel import read_identify_peel

circuit = qiskit.QuantumCircuit(2, 2)
circuit_2 = qiskit.QuantumCircuit(2, 2)
circuit_3 = qiskit.QuantumCircuit(2, 2)
circuit_4 = qiskit.QuantumCircuit(2, 2)
circuit_5 = qiskit.QuantumCircuit(2, 2)

for circ in [circuit, circuit_2, circuit_3, circuit_4, circuit_5]:
    if np.random.sample() > 0.5:
        circ.rx(np.random.sample(), 0)
    else:
        circ.ry(np.random.sample(), 0)

    circ.cx(0, 1)

    if np.random.sample() > 0.5:
        circ.rz(np.random.sample(), 1)
    else:
        circ.ry(np.random.sample(), 1)

    circ.cx(1, 0)

for circ in [circuit_3, circuit_4]:
    if np.random.sample() > 0.5:
        circ.rz(np.random.sample(), 0)
    else:
        circ.ry(np.random.sample(), 0)

for circ in [circuit_5]:
    circ.rx(0.3, 1)

rip = read_identify_peel.ReadIdentifyPeel()

(
    templates,
    params,
    circuit_groups,
) = rip.get_templates_and_peeled_parameters(
    [
        circuit,
        circuit_2,
        circuit_3,
        circuit_4,
        circuit_5,
    ]
)

print(circuit_groups)

for template in templates:
    print(template)

print(params)
