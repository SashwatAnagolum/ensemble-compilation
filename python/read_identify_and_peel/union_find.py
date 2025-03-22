import numpy as np
import collections


class UnionFind:
    def __init__(self, num_circuits: int) -> None:
        self.parents = -1 * np.ones((num_circuits,), dtype=int)
        self.depths = np.zeros((num_circuits,), dtype=int)

    def get_parent(self, node: int) -> int:
        parent = node

        while self.parents[parent] != -1:
            parent = self.parents[parent]

        if parent != node:
            self.parents[node] = parent

        return parent

    def connect(self, node_1: int, node_2: int) -> None:
        parent_1 = self.get_parent(node_1)
        parent_2 = self.get_parent(node_2)

        if parent_1 == parent_2:
            return

        depth_1 = self.depths[parent_1]
        depth_2 = self.depths[parent_2]

        if depth_1 > depth_2:
            self.parents[parent_2] = parent_1
        else:
            self.parents[parent_1] = parent_2
            self.depths[parent_2] += self.depths[parent_1] == self.depths[parent_2]

    def get_clusters(self) -> collections.defaultdict:
        clusters = collections.defaultdict(list)

        for node in range(self.parents.shape[0]):
            parent = self.get_parent(node)
            clusters[parent].append(node)

        return clusters
