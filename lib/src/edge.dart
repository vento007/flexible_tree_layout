import 'package:flexible_tree_layout/src/node.dart';

/// Edge class. This class is used to create edges between nodes. It is used in [FlexibleTreeLayout] class. Each edge has a [from] and [to] node. It also has a [configuration] map which can be used to store any data.
class Edge {
  Node from;
  Node to;

  Map<String, dynamic>? configuration = {};

  Edge(this.from, this.to) {
    configuration = {};
  }

  Edge.config(this.from, this.to, {required this.configuration});
}