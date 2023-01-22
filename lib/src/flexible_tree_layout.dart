import 'dart:collection';
import 'dart:math';

import 'package:flexible_tree_layout/src/edge.dart';
import 'package:flexible_tree_layout/src/node.dart';
import 'package:flutter/widgets.dart';

/// This class is the core of the flexible tree layout package. you need to pass in [nodeSize], [yOffSet], [xOffSet], [nodes] and [edges]
/// when creating an instance of this class.
///
///
/// [nodes] a List<Node> of all the nodes in the graph.
/// [edges] a List<Edge> of all the edges in the graph.
/// [yOffSet] is the offset between each level.
/// [yOffSet] is the offset between each level.
/// [nodeSize] is the size of each node.
///
class FlexibleTreeLayout {
  List<Node> nodes = [];
  List<Edge> edges = [];

  int maxDepth = 0;

  double yOffSet = 75;
  double xOffSet = 75;

  Size nodeSize;

  FlexibleTreeLayout(
      {required this.nodeSize,
      required this.yOffSet,
      required this.xOffSet,
      required this.nodes,
      required this.edges})
      : assert(nodes.isNotEmpty,
            'Graph must have atleast one node, please add atleast one node'),
        assert(edges.isNotEmpty,
            'Graph must have atleast one edge, please add atleast one edge') {
    setDepthOfGraph();
  }

  void addNode(Node node) {
    nodes.add(node);
  }

  void addEdge(Node from, Node to) {
    edges.add(Edge(from, to));
  }

  double get totalWidth {
    double totalWidth = 0;

    for (var node in nodes) {
      if (node.x > totalWidth) {
        totalWidth = node.x;
      }
    }

    totalWidth += xOffSet;

    return totalWidth;
  }

  double get totalHeight {
    double totalHeight = 0;

    for (var node in nodes) {
      if (node.y > totalHeight) {
        totalHeight = node.y;
      }
    }

    totalHeight += yOffSet;
    return totalHeight;
  }

  void setDepthOfGraph() {
    bfs();
    int maxDepth = 0;
    for (var node in nodes) {
      if (node.depth > maxDepth) {
        maxDepth = node.depth;
      }
    }
    this.maxDepth = maxDepth;

    sortByToplogy();
    calcXY();
  }

  void bfs() {
    int topologyCounter = 0;
    int mody = 0;
    for (var node in nodes) {
      node.depth = 0;
      node.topology = 0;
    }
    Node prevNode = Node('');
    Queue<Node> queue = Queue<Node>();
    queue.add(nodes[0]);
    while (queue.isNotEmpty) {
      Node current = queue.removeFirst();
      current.topology = topologyCounter++;
      if (current.depth == prevNode.depth) {
        mody++;
      } else {
        mody = 1;
      }
      current.mody = mody;
      prevNode = current;
      for (Edge edge in edges) {
        if (edge.from == current) {
          edge.to.depth = current.depth + 1;
          queue.add(edge.to);
        }
      }
    }
  }

  void sortByToplogy() {
    nodes.sort((a, b) => a.topology.compareTo(b.topology));
  }

  void calcXY() {
    maxDepth = nodes.map((node) => node.depth).reduce(max);
    for (var node in nodes) {
      node.x = node.depth * xOffSet;
      int count = nodes.where((n2) => n2.depth == node.depth).length;
      var offset = ((maxDepth + 0) / (count + 0));
      node.y = offset * yOffSet + ((node.mody * yOffSet) + node.mody);
    }

    final double totalY = nodes
        .where((node) => node.depth == maxDepth)
        .map((node) => node.y)
        .reduce((value, element) => value + element);
    final int count = nodes.where((node) => node.depth == maxDepth).length;
    nodes[0].y = totalY / count;

    final double minY = nodes.map((node) => node.y).reduce(min);
    for (var node in nodes) {
      node.y -= minY;
    }
  }
}
