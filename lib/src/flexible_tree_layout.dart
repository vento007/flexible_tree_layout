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
  int _maxDepth = 0;
  Offset offset = (Offset.zero);
  bool centerLayout;
  ftlOrientation orientation;

  // FlexibleTreeLayout(
  //     {this.centerLayout = true,
  //     this.orientation = ftlOrientation.vertical,
  //     required this.offset,
  //     required this.nodes,
  //     required this.edges})
  //     : assert(nodes.isNotEmpty,
  //           'Graph must have atleast one node, please add atleast one node'),
  //       assert(edges.isNotEmpty,
  //           'Graph must have atleast one edge, please add atleast one edge') {
  //   _main();
  // }

  FlexibleTreeLayout(
      {this.centerLayout = true,
      this.orientation = ftlOrientation.vertical,
      required this.offset,
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
    // double totalHeight = 0;
    // double lastHeight = 0;

    // for (var node in nodes) {
    //   if (node.y > totalHeight) {

    //     totalHeight = node.y;
    //     lastHeight = node.size.height;

    //   }
    // add last
    // }

    // add offset

    // return totalHeight + lastHeight + 100;

    double totalHeight = 0;
    double lastHeight = 0;

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

    // TODO fix total height calculation, sometimes a few pixels are missing
    return totalHeight + offset.dy;
  }

  void _main() {
    _bfs();

    // set x position modifier
    _setModx();

    // shiftDepths(5);

    // iterate all and set modx to the modx value
    for (var node in nodes) {
      node.modx += node.modxShift;
    }

    _calculateCordinates();
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

    for (var node in nodes) {
      var newDepth = node.modx;
      var newModx = node.depth;
      node.depth = newDepth;
      node.modx = newModx;
    }
  }

  bool isCyclic() {
    Set<Node> visited = <Node>{};
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

  List<List<Node>> findAllPathsOneWay(Node from, Node to) {
    List<List<Node>> paths = [];
    List<Node> path = [];
    findAllPathsHelperOld(from, to, path, paths);
    return paths;
  }

  void findAllPathsHelperOld(
      Node current, Node to, List<Node> path, List<List<Node>> paths) {
    if (current == to) {
      path.add(to);
      paths.add(path.toList());
      path.removeLast();
      return;
    }
    path.add(current);
    for (Node child in current.children) {
      findAllPathsHelperOld(child, to, path, paths);
    }
    path.removeLast();
  }

  List<List<Node>> findAllPaths(Node node) {
    List<List<Node>> paths = [];
    List<Node> currentPath = [];
    findPathsHelper(node, paths, currentPath);
    return paths;
  }

  void findPathsHelper(
      Node node, List<List<Node>> paths, List<Node> currentPath) {
    currentPath.add(node);
    if (!node.hasChildren) {
      paths.add(List.from(currentPath));
    } else {
      for (Node child in node.children) {
        findPathsHelper(child, paths, currentPath);
      }
    }
    currentPath.removeLast();
  }

  void shiftDepths(int modx) {
    int maxDepth = findMaxDepth();
    Map<int, List<Node>> nodesByDepth = {};

    for (var node in nodes) {
      if (!nodesByDepth.containsKey(node.depth)) {
        nodesByDepth[node.depth] = [node];
      } else {
        nodesByDepth[node.depth]!.add(node);
      }
    }

    for (var i = 0; i <= maxDepth; i++) {
      List<Node> nodesAtDepth = nodesByDepth[i]!;
      int modxShift = (nodesAtDepth.length / modx).ceil();
      for (var j = 0; j < nodesAtDepth.length; j++) {
        Node node = nodesAtDepth[j];
        node.depth += (j / modx).ceil() * modxShift;
      }
    }
  }

  // void _bfs() {
  //   for (var node in nodes) {
  //     node.depth = -1;
  //     node.topology = 0;
  //   }
  //   int topologyCounter = 0;
  //   Queue<Node> queue = Queue<Node>();
  //   queue.add(nodes[0]);
  //   nodes[0].depth = 0;
  //   while (queue.isNotEmpty) {
  //     Node current = queue.removeFirst();
  //     current.topology = topologyCounter++;
  //     for (Edge edge in edges) {
  //       if (edge.from == current) {
  //         if (edge.to.depth == -1) {
  //           edge.to.depth = current.depth + 1;
  //           if (!current.children.contains(edge.to)) {
  //             current.children.add(edge.to);
  //           }
  //           edge.to.parents.add(current);
  //           queue.add(edge.to);
  //         }
  //       } else if (edge.to == current) {
  //         if (!current.parents.contains(edge.from)) {
  //           current.parents.add(edge.from);
  //         }
  //         if (!edge.from.children.contains(current)) {
  //           edge.from.children.add(current);
  //         }
  //       }
  //     }
  //   }
  //   // Sort nodes by depth and topology
  //   nodes.sort((a, b) {
  //     if (a.depth == b.depth) {
  //       return a.topology.compareTo(b.topology);
  //     }
  //     return a.depth.compareTo(b.depth);
  //   });

  //   findMaxDepth();

  //   Map<int, List<Node>> nodesByDepth = {
  //     for (var node in nodes) node.depth: [node]
  //   };

  //   int nodeCounter = 0;
  //   for (var i = 0; i <= _maxDepth; i++) {
  //     List<Node> nodesAtDepth = nodesByDepth[i]!;
  //     double currentDepthX = 0;
  //     double shift = 0;

  //     if (nodesAtDepth.length > 5) {
  //       nodeCounter = 0;
  //       shift = (nodesAtDepth.length / 5).floor() * nodes[i].size.height;
  //     }

  //     double currentY = 0;

  //     for (var j = 0; j < nodesAtDepth.length; j++) {
  //       Node node = nodesAtDepth[j];

  //       if (nodeCounter % 5 == 0 && nodeCounter > 0) {
  //         currentDepthX = 0;
  //       }

  //       node.x = currentDepthX;
  //       node.y = currentY + shift;

  //       currentDepthX += node.size.width + offset.dx;
  //       nodeCounter++;
  //     }

  //     currentY += nodes[i].size.height + offset.dy;
  //   }
  // }

// shifted not completed
  // void _bfsCustomX() {
  //   for (var node in nodes) {
  //     node.depth = -1;
  //     node.topology = 0;
  //   }
  //   int topologyCounter = 0;
  //   Queue<Node> queue = Queue<Node>();
  //   queue.add(nodes[0]);
  //   nodes[0].depth = 0;
  //   int nodeCount = 0;

  //   int icounter = 1;
  //   Map<int, int> nodeCountMap = {};
  //   while (queue.isNotEmpty) {
  //     Node current = queue.removeFirst();
  //     current.topology = topologyCounter++;
  //     nodeCount++;

  //     // store nodeCount in the nodeCountMap
  //     if (nodeCountMap.containsKey(nodeCount)) {
  //       nodeCountMap[nodeCount] = nodeCountMap[nodeCount]! + 1;
  //     } else {
  //       nodeCountMap[nodeCount] = 0;
  //     }

  //     if (nodeCount != 1) {
  //       current.depth += nodeCountMap[nodeCount]!;
  //     } else {}

  //     if (nodeCount > 4) {
  //       nodeCount = 0;
  //       icounter++;
  //     }

  //     // store nodeCount in a Map<int, int> with that are nodecount and how many times they occur

  //     for (Edge edge in edges) {
  //       if (edge.from == current) {
  //         if (edge.to.depth == -1) {
  //           edge.to.depth = current.depth + 1;
  //           if (!current.children.contains(edge.to)) {
  //             current.children.add(edge.to);
  //           }
  //           edge.to.parents.add(current);
  //           queue.add(edge.to);
  //         }
  //       } else if (edge.to == current) {
  //         if (!current.parents.contains(edge.from)) {
  //           current.parents.add(edge.from);
  //         }
  //         if (!edge.from.children.contains(current)) {
  //           edge.from.children.add(current);
  //         }
  //       }
  //     }
  //   }
  //   // Sort nodes by depth and topology
  //   nodes.sort((a, b) {
  //     if (a.depth == b.depth) {
  //       return a.topology.compareTo(b.topology);
  //     }
  //     return a.depth.compareTo(b.depth);
  //   });

  //   findMaxDepth();
  // }

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
