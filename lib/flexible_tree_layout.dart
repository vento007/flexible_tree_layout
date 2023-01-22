library flexible_tree_layout;

/// FlexibleTreeLayout class. This class is the core of the flexible tree layout package. you need to pass in   [nodeSize], [yOffSet], [xOffSet], [nodes] and [edges] to the constructor. [nodeSize] is the size of each node, [yOffSet] is the offset between each level, [xOffSet] is the offset between each node, [nodes] is the list of nodes and [edges] is the list of edges. You can also add nodes and edges using [addNode] and [addEdge] methods. You can also use [totalWidth] and [totalHeight] to get the total width and height of the graph.

export 'src/flexible_tree_layout.dart';
export 'src/edge.dart';
export 'src/node.dart';


