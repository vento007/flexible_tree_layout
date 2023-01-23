import 'package:flexible_tree_layout/src/node.dart';

/// Edge class. This class is used to create edges between nodes. It is used in [FlexibleTreeLayout] class. Each edge has a [from] and [to] node. It also has a [configuration] map which can be used to store any data.
class Edge {
  final Node from;
  final Node to;

  Map<String, dynamic>? configuration = {};

  /// use this constructor if you don't want to pass in a configuration.
  Edge(this.from, this.to) {
    configuration = {};
  }

  /// use this constructor if you have custom configuration. format of the configuration is Map<String, dynamic>
  Edge.config(this.from, this.to, {required this.configuration});

   @override
  String toString() {
    return 'Edge{from: $from, to: $to, configuration: $configuration}';
  }
}
