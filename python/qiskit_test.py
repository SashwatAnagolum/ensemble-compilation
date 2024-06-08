import qiskit

circuit = qiskit.QuantumCircuit(2)

circuit.h(0)

with circuit.for_loop(range(4)) as i:
    circuit.cx(0, 1)

print(circuit)

transpiled_circuit = qiskit.transpile(circuit, optimization_level=3)

print(transpiled_circuit)

# circ_dag = qiskit.converters.circuit_to_dag(circuit)

# for node in circ_dag.op_nodes(qiskit.circuit.ForLoopOp):
#     print(node.op.params)