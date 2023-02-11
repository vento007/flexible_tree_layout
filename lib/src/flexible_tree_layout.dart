import 'dart:collection';

import 'package:flexible_tree_layout/flexible_tree_layout.dart';
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
class FlexibleTreeLayout extends ChangeNotifier {
  List<Node> nodes = [];
  List<Edge> edges = [];

  List<Node> nodesReset = [];
  List<Edge> edgesReset = [];

  int _maxDepth = 0;
  Offset offset = (Offset.zero);
  bool centerLayout;
  ftlOrientation orientation;
  List<List<Node>> predefinedPaths = [];

  FlexibleTreeLayout(
      {this.centerLayout = true,
      this.orientation = ftlOrientation.vertical,
      required this.offset,
      this.predefinedPaths = const [],
      required this.nodes,
      required this.edges}) {
    _main();
  }

  void updateInsertOrder() {
    var i = 0;
    for (Node n in nodes) {
      n.insertorder = i;
      i++;
    }
  }

  // get node
  Node? getNodeByName(String name) {
    for (Node n in nodes) {
      if (n.name == name) {
        return n;
      }
    }
    return null;
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
    nodes += [node];
  }

  void addEdge(Node from, Node to) {
    edges += [Edge(from, to)];
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

    for (int depth = 0; depth <= _maxDepth; depth++) {
      // filter out nodes that don't have the desired depth

      List<Node> nodesAtDepth =
          nodes.where((node) => node.mody == depth).toList(growable: false);

      var thisRowHeight = 0.0;
      var lastHeights = 0.0;
      for (var node in nodesAtDepth) {
        if (node.y > thisRowHeight) {
          thisRowHeight = node.y;
        }
        lastHeights = node.size.height;
        // if last
        if (node == nodesAtDepth.last) {
          thisRowHeight += lastHeights;
        }
      }

      if (thisRowHeight > totalHeight) {
        totalHeight = thisRowHeight;
      }
    }

    return totalHeight + offset.dy;
  }

  void _main() {
    if (nodes.isEmpty || edges.isEmpty) {
      return;
    }
    calculate();
  }

  void calculate() {
    for (Node n in nodes) {
      n.x = 0;
      n.y = 0;
    }

    updateInsertOrder();
    _bfs();
    _setModx();
    _calculateCordinates();
    _calculateEdgeBorderPoints();

    notifyListeners();
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

  void filter(List<List<Node>> paths) {
    // copy to reset
    nodesReset = nodes;
    edgesReset = edges;

    List<Node> nodesTmp = [];
    List<Edge> edgesTmp = [];

    for (List<Node> path in paths) {
      for (Node node in path) {
        if (nodeExist(node) && !nodesTmp.contains(node)) {
          nodesTmp.add(node);
        }
      }
      for (Edge edge in edges) {
        // remove all edges that are not have both nodes in the tmp list
        if (nodesTmp.contains(edge.from) && nodesTmp.contains(edge.to)) {
          edgesTmp.add(edge);
        }
      }
    }

    nodes = nodesTmp;
    edges = edgesTmp;

    updateInsertOrder();
    calculate();

    notifyListeners();
  }

  void resetFilter() {
    nodes = nodesReset;
    edges = edgesReset;
    calculate();
    notifyListeners();
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

    for (var node in nodes) {
      var newDepth = node.modx;
      var newModx = node.depth;
      node.depth = newDepth;
      node.modx = newModx;
    }
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

  List<List<Node>> findAllPathsOneWay(Node from, Node to) {
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
    for (var node in nodes) {
      // use nodeSide + offset

      double th = 0;
      // reduce totalHeight from all nodes with depth < node.depth
      nodes
          .where((element) =>
              (element.depth < node.depth) && (element.modx == node.modx))
          .forEach((element) {
        th += element.size.height;
      });

      node.x = ((node.modx) * (node.size.width + offset.dx));
      node.y = th + (node.depth * (offset.dy));

      // if orientation is vertical
      if (orientation == ftlOrientation.vertical) {
        node.x = th + (node.depth * (offset.dx));
        node.y = ((node.modx) * (node.size.width + offset.dy));
      }
    }

    // calculate height of each depth

    if (centerLayout && orientation == ftlOrientation.horizontal) {
      for (int depth = 0; depth <= _maxDepth; depth++) {
        // filter out nodes that don't have the desired depth

        List<Node> nodesAtDepth =
            nodes.where((node) => node.mody == depth).toList(growable: false);

        var thisRowHeight = 0.0;
        var lastHeights = 0.0;
        for (var node in nodesAtDepth) {
          if (node.y > thisRowHeight) {
            thisRowHeight = node.y;
          }
          lastHeights = node.size.height;
          // if last
          if (node == nodesAtDepth.last) {
            thisRowHeight += lastHeights;

            if (thisRowHeight < totalHeight) {
              var diff = totalHeight - thisRowHeight;
              // add diff
              for (var node in nodesAtDepth) {
                // add half of diff to each node
                node.y += diff / 2;
              }
            }
          }
        }
      }
    }

    if (centerLayout && orientation == ftlOrientation.vertical) {
      for (int depth = 0; depth <= _maxDepth; depth++) {
        // filter out nodes that don't have the desired depth

        List<Node> nodesAtDepth =
            nodes.where((node) => node.mody == depth).toList(growable: false);

        var thisRowWidth = 0.0;
        var lastHeights = 0.0;
        for (var node in nodesAtDepth) {
          if (node.x > thisRowWidth) {
            thisRowWidth = node.x;
          }
          lastHeights = node.size.width;
          // if last
          if (node == nodesAtDepth.last) {
            thisRowWidth += lastHeights;

            if (thisRowWidth < totalWidth) {
              var diff = totalWidth - thisRowWidth;
              // add diff
              for (var node in nodesAtDepth) {
                // add half of diff to each node
                node.x += diff / 2;
              }
            }
          }
        }
      }
    }
  }

  void _calculateEdgeBorderPoints() {
    if (orientation == ftlOrientation.horizontal) {
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

    if (orientation == ftlOrientation.vertical) {
      for (var node in nodes) {
        var centerRightx = node.x + node.size.height;
        var centerRightY = node.y + node.size.width / 2;
        node.rightCenter = Offset(centerRightx, centerRightY);

        var centerLeftx = node.x;
        var centerLeftY = node.y + node.size.width / 2;
        node.leftCenter = Offset(centerLeftx, centerLeftY);

        var centerTopx = node.x + node.size.width / 2;
        var centerTopY = node.y;
        node.topCenter = Offset(centerTopx, centerTopY);

        var centerBottomx = node.x + node.size.width / 2;
        var centerBottomY = node.y + node.size.height;
        node.bottomCenter = Offset(centerBottomx, centerBottomY);
      }
    }
  }
}
