import 'package:example/data.dart';
import 'package:flexible_tree_layout/flexible_tree_layout.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  FlexibleTreeLayout graph = FlexibleTreeLayout(
      nodeSize: const Size(75, 75), // the size of each nodes
      yOffSet: 125, // offset between each level
      xOffSet: 150, // offset between each node
      nodes: myNodes,
      edges: myEdges);

  @override
  Widget build(BuildContext context) {
    // can be used for positioning
    double totalWidth = graph.totalWidth; // total width of the graph
    double totalHeight = graph.totalHeight; // total height of the graph

    // various debug print for easier understanding
    // -------------------------------------------
    // for (var node in graph.nodes) {
    //   print('node: ${node.name} x: ${node.x} y: ${node.y}');
    //   if (node.configuration != null) print(node.configuration);
    // }

    // for (var edge in graph.edges) {
    //   print('edge: ${edge.from.name} -> ${edge.to.name}');
    //   // print configuration
    //   if (edge.configuration != null) print(edge.configuration);
    // }

    // print(graph.nodeSize);

    return MaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(200),
            child: Center(
                child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  // an easy way to iterate over the calculated positioned and place the widgets in a stack
                  // with positioned() and the x,y from the graph
                  ...graph.nodes.map((node) {
                    return Builder(builder: (context) {
                      if (node.configuration != null &&
                          node.configuration!['style'] == 'flutterlogo') {
                        return Positioned(
                          left: node.x,
                          top: node.y,
                          child: FlutterLogo(
                            size: graph.nodeSize.width,
                          ),
                        );
                      }

                      // checking if this specific node have a custom configuration and do
                      // some special case rendering.. in this case, it renders either a circle or
                      // the flutter logo

                      if (node.configuration != null &&
                          node.configuration!['style'] == 'sometext') {
                        return Positioned(
                            left: node.x,
                            top: node.y,
                            child: Container(
                              width: graph.nodeSize.width,
                              height: graph.nodeSize.width,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0, color: Colors.black),
                                  left: BorderSide(
                                      width: 1.0, color: Colors.black),
                                  right: BorderSide(
                                      width: 1.0, color: Colors.black),
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.black),
                                ),
                              ),
                            ));
                      }

                      var colors = {
                        '0': Colors.red,
                        '1': Colors.blue,
                        'A': Colors.green,
                        '2': Colors.blue,
                        '20': Colors.blue,
                        '22': Colors.blue,
                        '10': Colors.blue,
                        '10A': Colors.blue,
                        '12': Colors.green,
                        'B': Colors.black,
                        '112': Colors.black,
                        'z': Colors.white,
                      };

                      // no configuration found, just render the default box
                      // -----------------------------------------------

                      return Positioned(
                        left: node.x,
                        top: node.y,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: colors[node.name] ?? Colors.black45,
                          ),
                          width: graph.nodeSize.width,
                          height: graph.nodeSize.height,
                          child: Center(
                            child: Text(
                              node.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    });
                  }).toList(),
                  Positioned(
                    // note: the position of the custom painter that draw the lines
                    // needs to be the same as the box rendering of the nodes above
                    // there are other ways to do this, but this is an easy way to get started
                    left: 0,
                    top: 0,
                    child: CustomPaint(
                      painter: MyPainter(g: graph),
                    ),
                  ),
                ],
              ),
            )),
          );
        }),
      ),
    );
  }
}

// example painter that paints the line between nodes
// you can use configuration map<String, dynamic> to add custom data to nodes and edges
// which in return can be customized in the painte based on the configuration
// look in the example data. the green line is a custom line defined in the configuration

class MyPainter extends CustomPainter {
  FlexibleTreeLayout g;

  MyPainter({required this.g});
  @override
  void paint(Canvas canvas, Size size) {
    final p2 = Paint()
      ..color = Colors.black45
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (var edge in g.edges) {
      double fromX = edge.from.x + g.nodeSize.width;
      double fromY = edge.from.y + g.nodeSize.height / 2;
      double toX = edge.to.x + 0;
      double toY = edge.to.y + g.nodeSize.height / 2;

      if (edge.configuration != null) {
        if (edge.configuration!['someCustomKey'] == 'righToTop') {
          fromX = edge.from.x + g.nodeSize.width;
          fromY = edge.from.y + g.nodeSize.height / 2;
          toX = edge.to.x + g.nodeSize.width / 2;
          toY = edge.to.y + g.nodeSize.height - g.nodeSize.height;

          final p3 = Paint()
            ..color = edge.configuration!['color']
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke;

          canvas.drawLine(Offset(fromX, fromY), Offset(toX, fromY), p3);
          canvas.drawLine(Offset(toX, fromY), Offset(toX, toY), p3);
        } else {
          canvas.drawPath(
              Path()
                ..moveTo(fromX, fromY)
                ..cubicTo(fromX + 40, fromY, toX - 40, toY, toX, toY),
              p2);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
