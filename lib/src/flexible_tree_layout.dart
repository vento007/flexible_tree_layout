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

  // double _yOffSet = 75;
  // double _xOffSet = 75;
  Offset offset = (Offset.zero);

  bool centerLayout;
  // bool flipY;

  // bool vertical = false;

  FlexibleTreeLayout(
      {
      // required this.yOffSet,
      // required this.xOffSet,
      this.centerLayout = true,
      required this.offset,
      required this.nodes,
      // this.flipY = false,
      // required this.vertical,
      required this.edges})
      : assert(nodes.isNotEmpty,
            'Graph must have atleast one node, please add atleast one node'),
        assert(edges.isNotEmpty,
            'Graph must have atleast one edge, please add atleast one edge') {
    _main();
  }

// // getter graphsize
//   Size get graphSize => const Size(200, 200);

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
    double lastWidth = 0;

    for (var node in nodes) {
      if (node.x > totalWidth) {
        totalWidth = node.x;
        lastWidth = node.size.width;
      }
    }

    return totalWidth + lastWidth;

   }

  double get totalHeight {
    double totalHeight = 0;
    double lastHeight = 0;

    for (var node in nodes) {
      // totalHeight += offset.dy;

      if (node.y > totalHeight) {
        totalHeight = node.y;
        lastHeight = node.size.height;
      }
    }
 
    return totalHeight + lastHeight;
   }

  void _main() {
    // calculate
    _bfs();

    // set x position modifier
    _setModx();

    for (var node in nodes) {
      var newDepth = node.modx;
      var newModx = node.depth;

      node.depth = newDepth;
      node.modx = newModx;
    }

    // iterate and print all modx, mody
    // for (var node in nodes) {
    //   print(
    //       'node: ${node.name} depth: ${node.depth}     modx: ${node.modx} mody: ${node.mody}');
    // }

    // if (flipAxis) {
    //   // change depth with modx
    //   for (var node in nodes) {
    //     var newDepth = node.modx;
    //     var newModx = node.depth;

    //     node.depth = newDepth;
    //     node.modx = newModx;
    //   }
    // }

    // calculate coordinates
    _calculateCordinates();

    // positionNodes(nodes, _maxDepth, totalWidth);

    // calculate edge border points
    _calculateEdgeBorderPoints();
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
          node.mody = depth;
        }
      }
    }
  }

  bool isCyclic() {
    Set<Node> visited = new Set<Node>();
    for (var node in nodes) {
      if (isCyclicHelper(node, visited)) {
        return true;
      }
    }
    return false;
  }

  bool isCyclicHelper(Node current, Set<Node> visited) {
    if (visited.contains(current)) {
      return true;
    }
    visited.add(current);
    for (Node child in current.children) {
      if (isCyclicHelper(child, visited)) {
        return true;
      }
    }
    return false;
  }

// find path between two nodes
  List<Node> findPath(Node from, Node to) {
    List<Node> path = [];
    Node current = to;
    while (current != from) {
      path.add(current);
      current = current.parents[0];
    }
    path.add(from);
    path = path.reversed.toList();
    return path;
  }

  List<List<Node>> findAllPaths(Node from, Node to) {
    List<List<Node>> paths = [];
    List<Node> path = [];
    findAllPathsHelper(from, to, path, paths);
    return paths;
  }

  void findAllPathsHelper(
      Node current, Node to, List<Node> path, List<List<Node>> paths) {
    if (current == to) {
      path.add(to);
      paths.add(path.toList());
      path.removeLast();
      return;
    }
    path.add(current);
    for (Node child in current.children) {
      findAllPathsHelper(child, to, path, paths);
    }
    path.removeLast();
  }

  void _bfs() {
    for (var node in nodes) {
      node.depth = -1;
      node.topology = 0;
    }
    int topologyCounter = 0;
    Queue<Node> queue = Queue<Node>();
    queue.add(nodes[0]);
    nodes[0].depth = 0;
    while (queue.isNotEmpty) {
      Node current = queue.removeFirst();
      current.topology = topologyCounter++;
      for (Edge edge in edges) {
        if (edge.from == current) {
          if (edge.to.depth == -1) {
            edge.to.depth = current.depth + 1;
            if (!current.children.contains(edge.to)) {
              current.children.add(edge.to);
            }
            edge.to.parents.add(current);
            queue.add(edge.to);
          }
        } else if (edge.to == current) {
          if (!current.parents.contains(edge.from)) {
            current.parents.add(edge.from);
          }
          if (!edge.from.children.contains(current)) {
            edge.from.children.add(current);
          }
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
    // sort nodes by depth
    nodes.sort((a, b) => a.depth.compareTo(b.depth));

    for (var node in nodes) {
      // use nodeSide + offset

      double th = 0;
      // reduce totalHeight from all nodes with depth < node.depth
      nodes
          .where((element) =>
              (element.depth < node.depth) && (element.modx == node.modx))
          .forEach((element) {
        th += element.size.height;
        // ignore: avoid_print
        print("---  depth: ${element.depth} total height $totalHeight");
      });

      node.x = ((node.modx) * (node.size.width + offset.dx));
      node.y = th + (node.depth * (offset.dy));

      // node.x = ((node.modx) * offset);
      // node.y = node.depth * offset;
    }
  }

  void _calculateEdgeBorderPoints() {
    for (var node in nodes) {
      var centerRightx = node.x + node.size.width;
      var centerRightY = node.y + node.size.height / 2;
      node.rightCenter = Offset(centerRightx, centerRightY);

      var centerLeftx = node.x;
      var centerLeftY = node.y + node.size.height / 2;
      node.leftCenter = Offset(centerLeftx, centerLeftY);

      var centerTopx = node.x + node.size.height / 2;
      var centerTopY = node.y;
      node.topCenter = Offset(centerTopx, centerTopY);

      var centerBottomx = node.x + node.size.width / 2;
      var centerBottomY = node.y + node.size.height;
      node.bottomCenter = Offset(centerBottomx, centerBottomY);
    }
  }
}
