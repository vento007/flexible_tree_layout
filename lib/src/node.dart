import 'package:flutter/widgets.dart';

/// Each node in the graph is represented by this class. use the default constructor if you don't want to pass any configuration, if you have need custom configuration, use the Node.config() constructor.
class Node {
  String name;

  int modx = 0;
  int mody = 0;
  double x = 0;
  double y = 0;
  int depth = 0;
  int topology = 0;
  int insertorder = 0;

  Offset rightCenter = Offset.zero;
  Offset leftCenter = Offset.zero;
  Offset topCenter =  Offset.zero;
  Offset bottomCenter = Offset.zero;

  List<Node> parents = [];
  List<Node> children = [];

  int childrenCount = 0;

  final Map<String, dynamic>? configuration;

  /// use this constructor if you don't want to pass in a configuration.
  Node(this.name) : configuration = null;

  /// use this constructor if you have custom configuration. format of the configuration is Map<String, dynamic>
  Node.config({required this.name, this.configuration = const {}});


  // copywith with all
  Node copyWith({
    String? name,
    int? modx,
    int? mody,
    double? x,
    double? y,
    List<Node>? parents,   
    List<Node>? children,  
    int? depth,
    int? topology,
    int? insertorder,
    Offset? rightCenter,
    Offset? leftCenter,
    Offset? topCenter,
    Offset? bottomCenter,
    int? childrenCount,
    Map<String, dynamic>? configuration,
  }) {
    return Node.config(
      name: name ?? this.name,
      configuration: configuration ?? this.configuration,
    )
      ..modx = modx ?? this.modx
      ..mody = mody ?? this.mody
      ..x = x ?? this.x
      ..y = y ?? this.y
      ..parents = parents ?? this.parents
      ..children = children ?? this.children
      ..depth = depth ?? this.depth
      ..topology = topology ?? this.topology
      ..insertorder = insertorder ?? this.insertorder
      ..rightCenter = rightCenter ?? this.rightCenter
      ..leftCenter = leftCenter ?? this.leftCenter
      ..topCenter = topCenter ?? this.topCenter
      ..bottomCenter = bottomCenter ?? this.bottomCenter
      ..childrenCount = childrenCount ?? this.childrenCount;
  }
 


  @override
  String toString() {
    return 'Node{name: $name, configuration: $configuration} ';
  }
}
