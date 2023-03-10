import 'package:flutter/widgets.dart';

/// Each node in the graph is represented by this class. use the default constructor if you don't want to pass any configuration, if you have need custom configuration, use the Node.config() constructor.
class Node<T> {
  String name;

  int modx = 0;
  int mody = 0;
  double x = 0;
  double y = 0;

  int depth = 0;
  int topology = 0;
  int insertorder = 0;
  Size size;
  T? object;
  int modxShift;

  Offset rightCenter = Offset.zero;
  Offset leftCenter = Offset.zero;
  Offset topCenter = Offset.zero;
  Offset bottomCenter = Offset.zero;

  List<Node> parents = [];
  List<Node> children = [];

  int childrenCount = 0;

  final Map<String, dynamic>? configuration;

  /// use this constructor if you don't want to pass in a configuration.
  Node(this.name, {this.size = Size.zero, this.modxShift = 0})
      : configuration = null;

  /// use this constructor if you have custom configuration. format of the configuration is Map<String, dynamic>
  Node.config(
      {required this.name,
      this.modxShift = 0,
      this.size = Size.zero,
      this.object,
      this.configuration = const {}});

  
    Node.empty() : configuration = null, name = '', size = Size.zero, modxShift = 0;



   void setConfiguration(Map<String, dynamic> configuration) {
     this
        .configuration!
        .removeWhere((key, value) => configuration.containsKey(key));
    this.configuration!.addAll(configuration);
  }


@override
bool operator ==(Object other) {
  if (identical(this, other)) return true;
  return other is Node && name == other.name;
}

@override
int get hashCode => Object.hashAll([name]);



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
    Size? size,
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
      ..size = size ?? this.size
      ..topology = topology ?? this.topology
      ..insertorder = insertorder ?? this.insertorder
      ..rightCenter = rightCenter ?? this.rightCenter
      ..leftCenter = leftCenter ?? this.leftCenter
      ..topCenter = topCenter ?? this.topCenter
      ..bottomCenter = bottomCenter ?? this.bottomCenter
      ..childrenCount = childrenCount ?? this.childrenCount;
  }

  bool get hasChildren => children.isNotEmpty;
  bool get hasParents => parents.isNotEmpty;

  @override
  String toString() {
    return 'Node{name: $name, configuration: $configuration} ';
  }
}
