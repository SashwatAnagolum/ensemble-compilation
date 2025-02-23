import qiskit
import networkx as nx
import numpy as np
import qiskit.circuit
import pickle as pkl

from read_identify_and_peel import union_find


class ReadIdentifyPeel:
    def __init__(self):
        self.circuits = []
        self.circuit_graphs = []
        self.parameters = []

    def get_u3_parameters_for_gate(
        self,
        gate_unitary: np.ndarray,
    ) -> tuple[float, float, float]:
        # diagonal gate, only lambda is nonzero
        if gate_unitary[0, 1] == 0.0 and gate_unitary[1, 0] == 0.0:
            return (
                0.0,
                0.0,
                (-1 * 1j * np.log(gate_unitary[1, 1] / gate_unitary[0, 0])).real.item(),
            )

        cos_theta_by_two = gate_unitary[0, 0].real
        sin_theta_by_two = np.abs(gate_unitary[0, 1]).real

        theta_by_two = np.arctan2([sin_theta_by_two], [cos_theta_by_two])[0]
        theta = theta_by_two * 2

        exp_i_lambda = -1 * gate_unitary[0, 1] / sin_theta_by_two
        lambda_angle = -1 * 1j * np.log(exp_i_lambda)

        exp_i_phi = gate_unitary[1, 0] / sin_theta_by_two
        phi_angle = -1 * 1j * np.log(exp_i_phi)

        return theta.real.item(), phi_angle.real.item(), lambda_angle.real.item()

    def convert_1q_gates_to_zxzxz(
        self,
        circuit: qiskit.QuantumCircuit,
    ) -> qiskit.QuantumCircuit:
        new_circuit = qiskit.QuantumCircuit(
            circuit.num_qubits,
            circuit.num_clbits,
        )

        for op, qargs, cargs in circuit.data:
            if (len(qargs) == 1) and len(cargs) == 0:
                (
                    theta_angle,
                    phi_angle,
                    lambda_angle,
                ) = self.get_u3_parameters_for_gate(op.to_matrix())

                new_circuit.append(
                    qiskit.circuit.library.PhaseGate(theta_angle - np.pi / 2),
                    qargs,
                )

                new_circuit.append(qiskit.circuit.library.SXGate(), qargs)

                new_circuit.append(
                    qiskit.circuit.library.PhaseGate(np.pi - phi_angle),
                    qargs,
                )

                new_circuit.append(qiskit.circuit.library.SXGate(), qargs)

                new_circuit.append(
                    qiskit.circuit.library.PhaseGate(lambda_angle - np.pi / 2),
                    qargs,
                )
            else:
                new_circuit.append(op, qargs, cargs)

        return new_circuit

    def convert_circuit_to_graph(
        self, circuit: qiskit.QuantumCircuit
    ) -> tuple[nx.DiGraph, dict[int, float]]:
        circuit_graph = nx.DiGraph()
        node_index = 0
        last_nodes_for_qubit = dict()
        circuit_parameters = []

        for qubit in range(circuit.num_qubits):
            circuit_graph.add_node(qubit)
            last_nodes_for_qubit[qubit] = node_index
            node_index += 1

        for op, qargs, _ in circuit.data:
            circuit_graph.add_node(
                node_index,
                gate_name=op.name,
                targets=[qarg._index for qarg in qargs],
            )

            for qarg in qargs:
                circuit_graph.add_edge(
                    last_nodes_for_qubit[qarg._index],
                    node_index,
                )

                last_nodes_for_qubit[qarg._index] = node_index

            circuit_parameters.extend(op.params)
            node_index += 1

        return circuit_graph, circuit_parameters

    def construct_circuit_graphs(
        self,
        circuits: list[qiskit.QuantumCircuit],
    ) -> tuple[list[nx.DiGraph], list[list[float]]]:
        circuit_graphs = []
        circuit_param_lists = []

        for circuit in circuits:
            circuit_graph, circuit_params = self.convert_circuit_to_graph(
                circuit,
            )

            circuit_graphs.append(circuit_graph)
            circuit_param_lists.append(circuit_params)

        return circuit_graphs, circuit_param_lists

    def identify_unique_circuits(
        self,
        circuit_graphs: list[nx.DiGraph],
        circuit_parameters: list[list[float]],
    ) -> tuple[list[list[int]], list[np.ndarray]]:
        uf = union_find.UnionFind(len(circuit_graphs))
        circuit_groups = []
        parameter_groups = []

        for circuit_graph_index, circuit_graph in enumerate(circuit_graphs):
            for other_graph_index, other_graph in enumerate(
                circuit_graphs[:circuit_graph_index]
            ):
                if nx.utils.misc.graphs_equal(
                    circuit_graph,
                    other_graph,
                ):
                    uf.connect(circuit_graph_index, other_graph_index)

        clusters = uf.get_clusters()

        for cluster_template_index in clusters:
            cluster = clusters[cluster_template_index].copy()
            cluster.pop(cluster.index(cluster_template_index))
            circuit_groups.append([cluster_template_index] + cluster)

            cluster_parameters = []

            for circuit_index in circuit_groups[-1]:
                cluster_parameters.append(circuit_parameters[circuit_index])

            parameter_groups.append(cluster_parameters)

        return circuit_groups, parameter_groups

    def peel_parameters_from_circuits(
        self,
        circuit_groups: list[list[int]],
        circuits: list[qiskit.QuantumCircuit],
        parameter_groups: list[list[float]],
    ) -> tuple[list[qiskit.QuantumCircuit], list[list[dict]]]:
        circuit_templates = []
        parameter_group_dicts = []

        for group_index, circuit_group in enumerate(circuit_groups):
            unique_circuit = circuits[circuit_group[0]]
            group_param_dicts = []

            param_index = 0
            new_circuit = qiskit.QuantumCircuit(
                unique_circuit.num_qubits,
                unique_circuit.num_clbits,
            )

            for op, qargs, cargs in unique_circuit.data:
                # this is the only case where we replace params with symbolic vars
                # i.e. when we know that it is a phase gate / Z rotation
                if len(qargs) == 1 and len(op.params) == 1:
                    gate_param = qiskit.circuit.Parameter(f"param_{param_index}")
                    new_circuit.append(
                        qiskit.circuit.library.PhaseGate(gate_param),
                        qargs,
                        cargs,
                    )

                    param_index += 1
                else:
                    new_circuit.append(
                        op,
                        qargs,
                        cargs,
                    )

            circuit_templates.append(new_circuit)
            parameter_group_dicts.append(
                [
                    {
                        f"param_{param_index}": params[param_index]
                        for param_index in range(len(params))
                    }
                    for params in parameter_groups[group_index]
                ]
            )

        return circuit_templates, parameter_group_dicts

    def get_templates_and_peeled_parameters(
        self,
        circuits: list[qiskit.QuantumCircuit],
    ) -> tuple[list[qiskit.QuantumCircuit], list[list[dict]], list[list[int]]]:
        circuits = [self.convert_1q_gates_to_zxzxz(circuit) for circuit in circuits]
        circuit_graphs, circuit_params = self.construct_circuit_graphs(circuits)

        (
            circuit_groups,
            parameter_groups,
        ) = self.identify_unique_circuits(
            circuit_graphs,
            circuit_params,
        )

        (
            circuit_templates,
            peeled_params,
        ) = self.peel_parameters_from_circuits(
            circuit_groups,
            circuits,
            parameter_groups,
        )

        return circuit_templates, peeled_params, circuit_groups

    def get_ripped_and_binarized_circuits(
        self, circuits: list[qiskit.QuantumCircuit]
    ) -> bytes:
        (
            templates,
            params,
            circuit_groups,
        ) = self.get_templates_and_peeled_parameters(circuits)

        return pkl.dumps((templates, params, circuit_groups))
