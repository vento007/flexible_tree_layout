import 'dart:async';
import 'dart:math';

import 'package:flexible_tree_layout/flexible_tree_layout.dart';
import 'package:flutter/material.dart';
import './helpers/random_color.dart';
import './helpers/randomicon.dart';
import './helpers/randomname.dart';

void main() {
  runApp(const Loader());
}

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Scaffold(body: GenerateRandomTrees()));
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

  @override
  void initState() {
    // every second
    // Timer.periodic(const Duration(milliseconds: 800), (timer) {
    setState(() {
      // i > 20 ? i =20 : i++;

      // random i between 5 and 15
      i = Random().nextInt(10) + 15;

      // random double 100-150

      i++;
      List<Node> myNodes = List.generate(i, (index) {
        // randomDouble between 0 and 100
        var randomDouble = Random().nextDouble() * 100;

        // random color
        ColorModel color = randomColor();

        return Node.config(
            name: (index + 1).toString(),
            size: Size(200, 100.0 + randomDouble),
            configuration: {
              'color': color.color,
            });
      });

      int flipYrandom = Random().nextInt(2);
      bool flipY = flipYrandom == 0 ? true : false;

      // centerLayout based on random
      flipYrandom = Random().nextInt(2);
      bool centerLayout = flipYrandom == 0 ? true : false;

      List<Edge> myEdges = [];

      for (var i = 0; i < myNodes.length; i++) {
        if (i == 0) {
          continue;
        }

        int random = Random().nextInt(i);

        myEdges.add(Edge(myNodes[random], myNodes[i]));
      }

      // random double 125 to 200

      var randomOffset = Random().nextDouble() * 100;

      graph = FlexibleTreeLayout(
          // nodeSize:
          //     Size(120,60), // the size of each nodes
          offset: Offset(50, 50), // the offset between each level
          nodes: myNodes,
          // flipAxis: true,
          // vertical: false,

          centerLayout: true,
          edges: myEdges);

      // debug
      for (var node in graph!.nodes) {
        print(
            "name ${node.name} parent ${node.parents.map((e) => e.name)} children ${node.children.map((e) => e.name)}");
      }

      Node destNode = graph!.nodes[graph!.nodes.length - 1];
      print("destnode is ${destNode.name}");

      var findPath = graph!.findAllPathsOneWay(graph!.nodes[0], destNode);
      for (var e in findPath) {
        print("path ${e.map((e) => e.name)}");
      }

      var isCyclic = graph!.isCyclic();
      print("isCyclic $isCyclic");

      // });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (graph == null) {
      return const Center(child: CircularProgressIndicator());
    }

    var externalRandom = Random().nextInt(100);

    print(
        "total height ${graph!.totalHeight} total width ${graph!.totalWidth}");

    return Center(
      child: Container(
        width: graph!.totalWidth,
        height: graph!.totalHeight,

        // decoration
        // rounded corners
        // border
        // shadow
        // color
        // padding

        child: Stack(
          children: [
            Positioned(
              // note: the position of the custom painter that draw the lines
              // needs to be the same as the box rendering of the nodes above
              // there are other ways to do this, but this is an easy way to get started
              left: 0,
              top: 0,
              child: CustomPaint(
                painter: MyPainter(g: graph!),
              ),
            ),
            // an easy way to iterate over the calculated positioned and place the widgets in a stack
            // with positioned() and the x,y from the graph
            ...graph!.nodes.map((node) {
              return Builder(builder: (context) {
                // checking if this specific node have a custom configuration and do
                // some special case rendering.. in this case, it renders either a circle or
                // the flutter logo

                // generate random number between 0 and 1
                // if 0, render circle
                // if 1, render flutter logo

                // if (externalRandom < 35) {
                //   return Positioned(
                //     left: node.x,
                //     top: node.y,
                //     child: SizedBox(
                //       width: graph!.nodeSize.width,
                //       height: graph!.nodeSize.height,
                //       child: const Center(
                //         child: RandomIcon(),
                //       ),
                //     ),
                //   );
                // }

                // if (externalRandom > 35 && externalRandom < 70) {
                //   return Positioned(
                //     left: node.x,
                //     top: node.y,
                //     child: SizedBox(
                //       width: graph!.nodeSize.width,
                //       height: graph!.nodeSize.height,
                //       child: const Center(
                //         child: RandomNames(),
                //       ),
                //     ),
                //   );
                // }

                int random = Random().nextInt(105);

                List<Color> colors = [
                  const Color(0xff227c9d),
                  const Color(0xff17c3b2),
                  const Color(0xffffcb77),
                  const Color(0xfff36d73),
                  const Color(0xff264653),
                  const Color(0xff264653),
                  const Color(0xff264653),
                  const Color(0xff264653),
                  Colors.black,
                  Colors.white,
                  Colors.white,
                ];

                int rl = Random().nextInt(colors.length);
                Color c = colors[rl];

                return Positioned(
                  left: node.x,
                  top: node.y,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),

                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.black),
                    //   color: c,
                    // ),
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
    bool r = Random().nextBool();

    final p2 = Paint()
      ..color = Colors.black
      ..strokeWidth = (r) ? 0.5 : 1.5
      ..style = PaintingStyle.stroke;

    // random number of 100
    int random = Random().nextInt(100);
    for (var edge in g.edges) {
      Node fromNode = edge.from;
      Node toNode = edge.to;

      //  = (g.offset - g.nodeSize.height) / 2;

      var p = Path();

      canvas.drawLine(fromNode.rightCenter, toNode.leftCenter, p2);

      // if (random < 50) {
      //   // if flipped
      //   if (1 == 2) {
      //     // if (g.flipY) {
      //     p = Path();
      //     p.moveTo(fromNode.bottomCenter.dx, fromNode.bottomCenter.dy);
      //     p.lineTo(fromNode.bottomCenter.dx,
      //         fromNode.bottomCenter.dy - betweenBoxesOffset.dx);
      //     p.lineTo(
      //         toNode.topCenter.dx, fromNode.bottomCenter.dy - betweenBoxesOffset.dx);
      //     p.lineTo(toNode.topCenter.dx, toNode.topCenter.dy);
      //     canvas.drawPath(p, p2);
      //   } else {
      //     p.moveTo(fromNode.bottomCenter.dx, fromNode.bottomCenter.dy);
      //     p.lineTo(fromNode.bottomCenter.dx,
      //         fromNode.bottomCenter.dy + betweenBoxesOffset.dx);
      //     p.lineTo(
      //         toNode.topCenter.dx, fromNode.bottomCenter.dy + betweenBoxesOffset.dx);
      //     p.lineTo(toNode.topCenter.dx, toNode.topCenter.dy);
      //     canvas.drawPath(p, p2);
      //   }
      // } else {
      //   p.moveTo(fromNode.bottomCenter.dx, fromNode.bottomCenter.dy);

      //   // Control point for the first curve
      //   var cp1x = fromNode.bottomCenter.dx;
      //   var cp1y = fromNode.bottomCenter.dy + betweenBoxesOffset.dx;

      //   // Control point for the second curve
      //   var cp2x = toNode.topCenter.dx;
      //   var cp2y = fromNode.bottomCenter.dy + betweenBoxesOffset.dx;

      //   // End point of the curve
      //   var endx = toNode.topCenter.dx;
      //   var endy = toNode.topCenter.dy;

      //   // if flipy, change control points, instead ad adding, subtract
      //   if (1 == 2) {
      //     // if (g.flipY) {
      //     cp1y = fromNode.bottomCenter.dy - betweenBoxesOffset.dx;
      //     cp2y = fromNode.bottomCenter.dy - betweenBoxesOffset.dx;
      //   }

      //   // Draw cubic bezier curve
      //   p.cubicTo(cp1x, cp1y, cp2x, cp2y, endx, endy);

      //   canvas.drawPath(p, p2);
      // }

      // }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
