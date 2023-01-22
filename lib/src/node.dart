
/// Each node in the graph is represented by this class. use the default constructor if you don't want to pass any configuration, if you have need custom configuration, use the Node.config() constructor.
class Node {
  String name;

  int modx = 0;
  int mody = 0;
  double x = 0;
  double y = 0;
  int depth = 0;
  int topology = 0;

  final Map<String, dynamic>? configuration;

  /// use this constructor if you don't want to pass in a configuration.  
  Node(this.name) : configuration = null;

  /// use this constructor if you have custom configuration. format of the configuration is Map<String, dynamic>
  Node.config({required this.name, this.configuration = const {}});
}
