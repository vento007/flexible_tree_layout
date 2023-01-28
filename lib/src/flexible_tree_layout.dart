import 'dart:collection';

import 'package:flexible_tree_layout/src/edge.dart';
import 'package:flexible_tree_layout/src/node.dart';
import 'package:flutter/widgets.dart';

/// This class is the core of the flexible tree layout package. you need to pass in [nodeSize], [_yOffSet], [_xOffSet], [nodes] and [edges]
/// when creating an instance of this class.
///
///
/// [nodes] a List<Node> of all the nodes in the graph.
/// [edges] a List<Edge> of all the edges in the graph.
/// [_yOffSet] is the offset between each level.
/// [_yOffSet] is the offset between each level.
/// [nodeSize] is the size of each node.
///
class FlexibleTreeLayout {
  List<Node> nodes = [];
  List<Edge> edges = [];

  int _maxDepth = 0;

  double _yOffSet = 75;
  double _xOffSet = 75;
  double offset = 0;

  Size nodeSize;
  bool centerLayout;
  bool flipY;

  bool vertical = false;

  FlexibleTreeLayout(
      {required this.nodeSize,
      // required this.yOffSet,
      // required this.xOffSet,
      this.centerLayout = true,
      required this.offset,
      required this.nodes,
      this.flipY = false,
      required this.vertical,
      required this.edges})
      : assert(nodes.isNotEmpty,
            'Graph must have atleast one node, please add atleast one node'),
        //  assert that offset is greater than nodeSize
        assert(offset > nodeSize.width,
            'Offset must be greater than nodeSize.width'),
        assert(edges.isNotEmpty,
            'Graph must have atleast one edge, please add atleast one edge') {
    _yOffSet = offset;
    _xOffSet = offset;

    _main();
  }

// getter graphsize
  Size get graphSize => Size(totalWidth, totalHeight);

  void updateInsertOrder() {
    var i = 0;

    for (Node n in nodes) {
      n.insertorder = i;
      i++;
    }
  }

  // get node
  Node getNode(String name) {
    for (Node n in nodes) {
      if (n.name == name) {
        return n;
      }
    }
    return Node('');
  }

  bool nodeExist(Node node) {
    for (Node n in nodes) {
      if (n.name == node.name) {
        return true;
      }
    }
    return false;
  }

  bool edgeExist(Edge edge) {
    for (Edge e in edges) {
      if (e.from.name == edge.from.name && e.to.name == edge.to.name) {
        return true;
      }
    }
    return false;
  }

  void addNode(Node node) {
    var l = nodes.length;

    Node newNode = node.copyWith(insertorder: l);
    if (nodeExist(newNode)) {
      return;
    }
    nodes.add(newNode);
  }

  void addEdge(Node from, Node to) {
    Edge newEdge = Edge(from, to);
    if (edgeExist(newEdge)) {
      return;
    }
    edges.add(newEdge);
  }

  double get totalWidth {
    double totalWidth = 0;

    for (var node in nodes) {
      if (node.x > totalWidth) {
        totalWidth = node.x;
      }
    }

    totalWidth += nodeSize.width;

    return totalWidth;
  }

  double get totalHeight {
    double totalHeight = 0;

    for (var node in nodes) {
      if (node.y > totalHeight) {
        totalHeight = node.y;
      }
    }

    totalHeight += nodeSize.height;
    return totalHeight;
  }

  void _main() {
    // calculate
    _bfs();

    // set x position modifier
    _setModx();

    // calculate coordinates
    _calculateCordinates();

    // flip the graph upside down
    if (flipY) {
      _calculateCordinatesFlipY();
    }

    // position nodes
    positionNodes(nodes, _maxDepth, totalWidth);

    // calculate edge border points
    _calculateEdgeBorderPoints();

    if (flipY) {
      _flipEdgeBorderPoints();
    }
  }

  int findMaxDepth() {
    int maxDepth = 0;
    for (var node in nodes) {
      if (node.depth > maxDepth) {
        maxDepth = node.depth;
      }
    }
    _maxDepth = maxDepth;
    return maxDepth;
  }

  void _calculateCordinatesFlipY() {
    for (var node in nodes) {
      node.y = totalHeight - node.y;
    }

    nodes[0].y += // height
        nodeSize.height / 1;
  }

  void positionNodes(List<Node> nodes, int maxDepth, double totalWidth) {
    if (centerLayout == false) return;

    for (int depth = 0; depth <= maxDepth; depth++) {
      // filter out nodes that don't have the desired depth
      List<Node> filteredNodes =
          nodes.where((node) => node.depth == depth).toList();

      int nodeCount = filteredNodes.length;
      double nodeWidth = totalWidth / (nodeCount + 1);

      for (int i = 0; i < nodeCount; i++) {
        filteredNodes[i].x = (i + 1) * nodeWidth;
      }
    }

    // shift everything left so that the leftmost node is at x = 0
    double minX = double.infinity;
    for (var node in nodes) {
      if (node.x < minX) {
        minX = node.x;
      }
    }

    for (var node in nodes) {
      node.x -= minX;
    }

    // shift everything so the topmost node is at y = 0
    double minY = double.infinity;
    for (var node in nodes) {
      if (node.y < minY) {
        minY = node.y;
      }
    }

    for (var node in nodes) {
      node.y -= minY;
    }
  }

  void _setModx() {
    for (var depth = 0; depth <= _maxDepth; depth++) {
      int modx = 0;
      for (var node in nodes) {
        if (node.depth == depth) {
          node.modx = modx;
          modx++;
        }
      }
    }
  }

  void _bfs() {
    for (var node in nodes) {
      node.depth = 0;
      node.topology = 0;
    }

    int topologyCounter = 0;
    Queue<Node> queue = Queue<Node>();
    queue.add(nodes[0]);

    while (queue.isNotEmpty) {
      Node current = queue.removeFirst();
      current.topology = topologyCounter++;
      for (Edge edge in edges) {
        if (edge.from == current) {
          edge.to.depth = current.depth + 1;
          queue.add(edge.to);
        }
      }
    }
    // Sort nodes by depth and topology
    nodes.sort((a, b) {
      if (a.depth == b.depth) {
        return a.topology.compareTo(b.topology);
      }
      return a.depth.compareTo(b.depth);
    });

    findMaxDepth();
  }

  void _calculateCordinates() {
    for (var node in nodes) {
      node.x = ((node.modx) * _xOffSet);
      node.y = node.depth * _yOffSet;
    }
  }

  void _calculateEdgeBorderPoints() {
    for (var node in nodes) {
      var centerRightx = node.x + nodeSize.width;
      var centerRightY = node.y + nodeSize.height / 2;
      node.rightCenter = Offset(centerRightx, centerRightY);

      var centerLeftx = node.x;
      var centerLeftY = node.y + nodeSize.height / 2;
      node.leftCenter = Offset(centerLeftx, centerLeftY);

      var centerTopx = node.x + nodeSize.width / 2;
      var centerTopY = node.y;
      node.topCenter = Offset(centerTopx, centerTopY);

      var centerBottomx = node.x + nodeSize.width / 2;
      var centerBottomY = node.y + nodeSize.height;
      node.bottomCenter = Offset(centerBottomx, centerBottomY);
    }
  }

  // flipy Centerpoints
  void _flipEdgeBorderPoints() {
    // flip bottom and top
    for (var node in nodes) {
      var tmp = node.topCenter;
      node.topCenter = node.bottomCenter;
      node.bottomCenter = tmp;
    }
  }
}
