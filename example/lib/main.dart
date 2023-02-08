import 'dart:async';
import 'dart:math';

import 'package:flexible_tree_layout/flexible_tree_layout.dart';
import 'package:flutter/material.dart';
import './helpers/random_color.dart';

void main() {
  runApp(const Loader());
}

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: GenerateRandomTrees());
  }
}

class GenerateRandomTrees extends StatefulWidget {
  const GenerateRandomTrees({super.key});

  @override
  State<GenerateRandomTrees> createState() => _GenerateRandomTreesState();
}

class _GenerateRandomTreesState extends State<GenerateRandomTrees> {
  FlexibleTreeLayout? graph;

  var i = 10;
  int nexnum = 100;
  ValueNotifier<int> graphlength = ValueNotifier(0);

  @override
  void initState() {
    // every second
    // random i between 5 and 15
    i = Random().nextInt(10) + 15;

    // random double 100-150

    i++;
    List<Node> myNodes = List.generate(i, (index) {
      // randomDouble between 0 and 100

      // random color
      ColorModel color = randomColor();

      return Node.config(
          name: (index + 1).toString(),
          size: const Size(50, 50.0),
          configuration: {
            'color': color.color,
          }).copyWith(backgroundColor: color.color);
    });

    List<Edge> myEdges = [];

    for (var i = 0; i < myNodes.length; i++) {
      if (i == 0) {
        continue;
      }

      int random = Random().nextInt(i);

      myEdges.add(
          Edge(myNodes[random], myNodes[i], lineColor: randomColor().color));
    }

    // random double 125 to 200

    var randomOffset = Random().nextDouble() * 100;
    graph = FlexibleTreeLayout(
        // nodeSize:
        //     Size(120,60), // the size of each nodes
        offset: const Offset(30, 60), // the offset between each level
        nodes: myNodes,
        // flipAxis: true,
        // vertical: false,
        orientation: ftlOrientation.vertical,
        centerLayout: true,
        edges: myEdges);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        Node n1 = graph!.nodes.firstWhere((element) => element.name == "1");
        Node n3 = graph!.nodes.firstWhere((element) => element.name == "3");
        Node n14 = graph!.nodes.firstWhere((element) => element.name == "11");

        var p = graph!.findAllPathsOneWay(n1, n3);
        var p1 = graph!.findAllPathsOneWay(n1, n14);

        graph!.filter(p + p1);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    graph!.addListener(() {
      setState(() {
        graph!.edges.forEach((element) {
          print("from to ${element.from.name} to ${element.to.name}");
        });

        graphlength.value = graph!.nodes.length;
      });
    });

    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   setState(() {
      //     Node target = graph!.nodes[// random int between 0 and 10
      //         Random().nextInt(graph!.nodes.length - 1)];

      //     // Node n1 = Node.config(name: '2a', size: const Size(50, 50));
      //     // graph!.addNode(n1);
      //     // graph!.edges += [Edge(target, n1)];
      //     // graph!.calculate();

      //     Node n1 = graph!.nodes.firstWhere((element) => element.name == "1");
      //     Node n3 = graph!.nodes.firstWhere((element) => element.name == "3");
      //     Node n14 = graph!.nodes.firstWhere((element) => element.name == "11");

      //     var p = graph!.findAllPathsOneWay(n1, n3);
      //     var p1 = graph!.findAllPathsOneWay(n1, n14);

      //     graph!.filter(p + p1);
      //   });
      // }),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Stack(
              children: [
                Positioned(
                  // note: the position of the custom painter that draw the lines
                  // needs to be the same as the box rendering of the nodes above
                  // there are other ways to do this, but this is an easy way to get started
                  left: 0,
                  top: 0,
                  child: Builder(builder: (context) {
                    print(graphlength.value);

                    return CustomPaint(
                      key: const ValueKey('custompaint'),
                      painter: MyPainter(
                          g: graph!,
                          edges: graph!.edges,
                          graphlength: graphlength),
                    );
                  }),
                ),
                // an easy way to iterate over the calculated positioned and place the widgets in a stack
                // with positioned() and the x,y from the graph
                ...graph!.nodes.map((node) {
                  return Builder(builder: (context) {
                    return Positioned(
                      left: node.x,
                      top: node.y,
                      child: Container(
                        decoration: BoxDecoration(
                          color: node.backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        width: node.size.width,
                        height: node.size.height,
                        child: Builder(builder: (context) {
                          // random bool to decide if the text should be rendered or not
                          // this is just to show how to use the configuration map

                          return Center(
                            child: Text(
                              node.name,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }),
                      ),
                    );
                  });
                }).toList(),
              ],
            ),
          ],
        ),
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
  List<Edge> edges;
  Key? key;
  Listenable? repaint;
  MyPainter(
      {required this.g,
      this.key,
      required this.edges,
      required ValueNotifier<int> graphlength})
      : super(repaint: graphlength);
  @override
  void paint(Canvas canvas, Size size) {
    for (var edge in edges) {
      // random double between 1-3

      double r = Random().nextDouble() * 3 + 1;

      // lineRandom 0-100

      final p2 = Paint()
        ..color = edge.lineColor
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      Node fromNode = edge.from;
      Node toNode = edge.to;
      // if (lineRandom >= 30) {
      Path path = Path();
      path.moveTo(fromNode.bottomCenter.dx + 0, fromNode.bottomCenter.dy);
      path.cubicTo(
          fromNode.bottomCenter.dx,
          fromNode.bottomCenter.dy + 22,
          toNode.topCenter.dx,
          toNode.topCenter.dy - 22,
          toNode.topCenter.dx,
          toNode.topCenter.dy);
      canvas.drawPath(path, p2);
      // }

      // if (lineRandom >= 5 && lineRandom < 30) {
      //   // 1. find diff between both nodes
      //   double diffX = toNode.topCenter.dx - fromNode.bottomCenter.dx;
      //   double diffY = toNode.topCenter.dy - fromNode.bottomCenter.dy;

      //   // draw line to the middle of the node

      //   var p = Path();
      //   p.moveTo(fromNode.bottomCenter.dx, fromNode.bottomCenter.dy);
      //   p.lineTo(
      //       fromNode.bottomCenter.dx, fromNode.bottomCenter.dy + diffY / 2);

      //   p.lineTo(toNode.topCenter.dx, toNode.topCenter.dy - diffY / 2);

      //   p.lineTo(toNode.topCenter.dx, toNode.topCenter.dy);

      //   canvas.drawPath(p, p2);

      // draw line from the middle of the node to the other node
      // }

      // if (lineRandom < 5) {
      //   double distance = 80;
      //   int numOfSegments = (distance / 4).floor();
      //   double deltaX =
      //       (toNode.topCenter.dx - fromNode.bottomCenter.dx) / numOfSegments;
      //   double deltaY =
      //       (toNode.topCenter.dy - fromNode.bottomCenter.dy) / numOfSegments;

      //   for (int i = 0; i < numOfSegments; i++) {
      //     if (i % 2 == 0) {
      //       canvas.drawLine(
      //           Offset(fromNode.bottomCenter.dx + deltaX * i,
      //               fromNode.bottomCenter.dy + deltaY * i),
      //           Offset(fromNode.bottomCenter.dx + deltaX * (i + 1),
      //               fromNode.bottomCenter.dy + deltaY * (i + 1)),
      //           p2);
      //     }
      //   }
      // }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
