import qiskit
import numpy as np


def get_cnot_layer_indices(
    connectivity: dict[list[int]],
    qubits: list[int],
    max_cnots: int,
) -> np.ndarray:
    selected_cnot_indices = []
    visited = set()

    qubits_shuffled = np.random.permutation(qubits)
    qubits_set = set(qubits)

    for qubit in qubits_shuffled:
        if qubit in visited:
            continue

        for adj_qubit in connectivity[qubit]:
            if (adj_qubit not in visited) and (adj_qubit in qubits_set):
                visited.add(adj_qubit)
                selected_cnot_indices.append([qubit, adj_qubit])
                break

        visited.add(qubit)

        if len(selected_cnot_indices) == max_cnots:
            break

    return np.array(selected_cnot_indices).reshape(-1, 2)


def add_local_pauli_measurements(
    circuit: qiskit.QuantumCircuit,
    qubits: list[int],
    chosen_pauli_measurement_bases: np.ndarray = None,
) -> qiskit.QuantumCircuit:
    pauli_measurement_basis_shifts = [
        [qiskit.circuit.library.IGate(), qiskit.circuit.library.IGate()],
        [qiskit.circuit.library.HGate(), qiskit.circuit.library.IGate()],
        [qiskit.circuit.library.SdgGate(), qiskit.circuit.library.HGate()],
    ]

    num_qubits = len(qubits)

    if chosen_pauli_measurement_bases is None:
        chosen_pauli_measurement_bases = np.random.randint(0, 3, (num_qubits))

    for qubit_index, qubit in enumerate(qubits):
        circuit.append(
            pauli_measurement_basis_shifts[chosen_pauli_measurement_bases[qubit_index]][
                0
            ],
            [qubit],
        )
        circuit.append(
            pauli_measurement_basis_shifts[chosen_pauli_measurement_bases[qubit_index]][
                1
            ],
            [qubit],
        )

        circuit.measure(qubit, qubit_index)

    return circuit
