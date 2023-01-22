import 'package:flexible_tree_layout/src/node.dart';

class Edge {
  Node from;
  Node to;

  Map<String, dynamic>? configuration = {};

  Edge(this.from, this.to) {
    configuration = {};
  }

  Edge.config(this.from, this.to, {required this.configuration});
}