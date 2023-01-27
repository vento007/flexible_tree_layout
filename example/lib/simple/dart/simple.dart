import 'package:flutter/widgets.dart';

import 'package:flexible_tree_layout/flexible_tree_layout.dart';

void main() {
  Node node1 = Node('1');
  Node node2 = Node('2');

  Edge edge1 = Edge(node1, node2);

  FlexibleTreeLayout(nodes: [node1, node2], edges: [edge1], nodeSize: const Size(50, 50), offset: 100, centerLayout: true, flipY: false, vertical: false);
}
