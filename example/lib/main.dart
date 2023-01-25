import 'dart:async';
import 'dart:math';

import 'package:example/helpers/random_color.dart';
import 'package:example/helpers/randomicon.dart';
import 'package:example/helpers/randomname.dart';
import 'package:flexible_tree_layout/flexible_tree_layout.dart';
import 'package:flutter/material.dart';

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
    Timer.periodic(const Duration(milliseconds: 800), (timer) {
      setState(() {
        // i > 20 ? i =20 : i++;

        // random i between 5 and 15
        i = Random().nextInt(10) + 5;
        i++;
        List<Node> myNodes = List.generate(i, (index) {
          // random color
          ColorModel color = randomColor();

          return Node.config(name: (index + 1).toString(), configuration: {
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

        var randomOffset = Random().nextDouble() * 25 + 125;

        graph = FlexibleTreeLayout(
            nodeSize:
                Size(110, randomOffset - 75.toInt()), // the size of each nodes
            offset: randomOffset, // the offset between each level
            nodes: myNodes,
            vertical: true,
            centerLayout: centerLayout,
            flipY: flipY,
            edges: myEdges);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (graph == null) {
      return const Center(child: CircularProgressIndicator());
    }

    var externalRandom = Random().nextInt(100);

    return Center(
      child: Container(
        color: Colors.transparent,
        width: graph!.totalWidth,
        height: graph!.totalHeight,
        child: Stack(
          children: [
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

                if (externalRandom < 35) {
                  return Positioned(
                    left: node.x,
                    top: node.y,
                    child: SizedBox(
                      width: graph!.nodeSize.width,
                      height: graph!.nodeSize.height,
                      child: const Center(
                        child: RandomIcon(),
                      ),
                    ),
                  );
                }

                if (externalRandom > 35 && externalRandom < 70) {
                  return Positioned(
                    left: node.x,
                    top: node.y,
                    child: SizedBox(
                      width: graph!.nodeSize.width,
                      height: graph!.nodeSize.height,
                      child: const Center(
                        child: RandomNames(),
                      ),
                    ),
                  );
                }

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
                      border: Border.all(color: Colors.black),
                      color: c,
                    ),
                    width: graph!.nodeSize.width,
                    height: graph!.nodeSize.height,
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

      var betweenBoxes = (g.offset - g.nodeSize.height) / 2;

      var p = Path();

      if (random < 50) {
        // if flipped
        if (g.flipY) {
          p = Path();
          p.moveTo(fromNode.bottomCenter.dx, fromNode.bottomCenter.dy);
          p.lineTo(fromNode.bottomCenter.dx,
              fromNode.bottomCenter.dy - betweenBoxes);
          p.lineTo(
              toNode.topCenter.dx, fromNode.bottomCenter.dy - betweenBoxes);
          p.lineTo(toNode.topCenter.dx, toNode.topCenter.dy);
          canvas.drawPath(p, p2);
        } else {
          p.moveTo(fromNode.bottomCenter.dx, fromNode.bottomCenter.dy);
          p.lineTo(fromNode.bottomCenter.dx,
              fromNode.bottomCenter.dy + betweenBoxes);
          p.lineTo(
              toNode.topCenter.dx, fromNode.bottomCenter.dy + betweenBoxes);
          p.lineTo(toNode.topCenter.dx, toNode.topCenter.dy);
          canvas.drawPath(p, p2);
        }
      } else {
        p.moveTo(fromNode.bottomCenter.dx, fromNode.bottomCenter.dy);

        // Control point for the first curve
        var cp1x = fromNode.bottomCenter.dx;
        var cp1y = fromNode.bottomCenter.dy + betweenBoxes;

        // Control point for the second curve
        var cp2x = toNode.topCenter.dx;
        var cp2y = fromNode.bottomCenter.dy + betweenBoxes;

        // End point of the curve
        var endx = toNode.topCenter.dx;
        var endy = toNode.topCenter.dy;

        // if flipy, change control points, instead ad adding, subtract
        if (g.flipY) {
          cp1y = fromNode.bottomCenter.dy - betweenBoxes;
          cp2y = fromNode.bottomCenter.dy - betweenBoxes;
        }

        // Draw cubic bezier curve
        p.cubicTo(cp1x, cp1y, cp2x, cp2y, endx, endy);

        canvas.drawPath(p, p2);
      }

      // }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
