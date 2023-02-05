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
            size: const Size(140, 100.0 + 0),
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
          offset: const Offset(100, 100), // the offset between each level
          nodes: myNodes,
          // flipAxis: true,
          // vertical: false,
          orientation: ftlOrientation.vertical,
          centerLayout: true,
          edges: myEdges);

      // debug
      for (var node in graph!.nodes) {
        print(
            "name ${node.name} modx ${node.modx}  modxShift: ${node.modxShift}     mody ${node.mody} parent ${node.parents.map((e) => e.name)} children ${node.children.map((e) => e.name)}");
      }

      // debug
      // for (var node in graph!.nodes) {
      //   print(
      //       "name ${node.name} parent ${node.parents.map((e) => e.name)} children ${node.children.map((e) => e.name)}");
      // }

      // Node destNode = graph!.nodes[graph!.nodes.length - 1];
      // print("destnode is ${destNode.name}");

      // var findPath = graph!.findAllPathsOneWay(graph!.nodes[0], destNode);
      // for (var e in findPath) {
      //   print("path ${e.map((e) => e.name)}");
      // }

      // var isCyclic = graph!.isCyclic();
      // print("isCyclic $isCyclic");

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

    //   Node node1 = Node("1", size: Size(100, 90.0 + 0));
    //   Node node2 = Node("pol", size: Size(100, 50.0  ));
    //   Node node3 = Node("auth", size: Size(100, 50.0 ));
    //   Node node4 = Node("access", size: Size(100, 50.0 ));

    //   Edge edge1 = Edge(node1, node2);
    //   Edge edge2 = Edge(node1, node3);
    //   Edge edge3 = Edge(node1, node4);

    //   // node pol -> p1, p2, p3, p4, p5
    //   // node auth -> u1, u2, u3, u4, u5
    //   // node access -> a1, a2, a3, a4, a5

    //   Node pol1 = Node("p1", size: Size(100, 50.0 + 0));
    //   Node pol2 = Node("p2", size: Size(100, 50.0 + 0));
    //   Node pol3 = Node("p3", size: Size(100, 50.0 + 0));
    //   Node pol4 = Node("p4", size: Size(100, 50.0 + 0));
    //   Node pol5 = Node("p5", size: Size(100, 50.0 + 0));
    //   Node pol6 = Node("p6", size: Size(100, 50.0 + 0));

    //   Edge polToPol1 = Edge(node2, pol1);
    //   Edge polToPol2 = Edge(node2, pol2);
    //   Edge polToPol3 = Edge(node2, pol3);
    //   Edge polToPol4 = Edge(node2, pol4);
    //   Edge polToPol5 = Edge(node2, pol5);
    //   Edge polToPol6 = Edge(node2, pol6);

    //  Node aol1 = Node("a1", size: Size(100, 50.0 + 0));
    //   Node aol2 = Node("a2", size: Size(100, 50.0 + 0));
    //   Node aol3 = Node("a3", size: Size(100, 50.0 + 0));
    //   Node aol4 = Node("a4", size: Size(100, 50.0 + 0));
    //   Node aol5 = Node("a5", size: Size(100, 50.0 + 0));
    //   Node aol6 = Node("a6", size: Size(100, 50.0 + 0));

    //   Edge aolToPol1 = Edge(node3, aol1);
    //   Edge aolToPol2 = Edge(node3, aol2);
    //   Edge aolToPol3 = Edge(node3, aol3);
    //   Edge aolToPol4 = Edge(node3, aol4);
    //   Edge aolToPol5 = Edge(node3, aol5);
    //   Edge aolToPol6 = Edge(node3, aol6);

    //      Node uol1 = Node("a1", size: Size(100, 50.0 + 0));
    //   Node uol2 = Node("a2", size: Size(100, 50.0 + 0));
    //   Node uol3 = Node("a3", size: Size(100, 50.0 + 0));
    //   Node uol4 = Node("a4", size: Size(100, 50.0 + 0));
    //   Node uol5 = Node("a5", size: Size(100, 50.0 + 0));
    //   Node uol6 = Node("a6", size: Size(100, 50.0 + 0));

    //   Edge uolToPol1 = Edge(node4, uol1);
    //   Edge uolToPol2 = Edge(node4, uol2);
    //   Edge uolToPol3 = Edge(node4, uol3);
    //   Edge uolToPol4 = Edge(node4, uol4);
    //   Edge uolToPol5 = Edge(node4, uol5);
    //   Edge uolToPol6 = Edge(node4, uol6);

    //   List<Node> myNodes = [

    //     node1,
    //     node2,
    //     node3,
    //     node4,
    //     pol1,
    //     pol2,
    //     pol3,
    //     pol4,
    //     pol5,
    //     pol6,
    //     aol1,
    //     aol2,
    //     aol3,
    //     aol4,
    //     aol5,
    //     aol6,
    //     uol1,
    //     uol2,
    //     uol3,
    //     uol4,
    //     uol5,
    //     uol6,

    //   ];
    //   List<Edge> myEdges = [
    //     edge1,
    //     edge2,
    //     edge3,
    //     polToPol1,
    //     polToPol2,
    //     polToPol3,
    //     polToPol4,
    //     polToPol5,
    //     polToPol6,
    //     aolToPol1,
    //     aolToPol2,
    //     aolToPol3,
    //     aolToPol4,
    //     aolToPol5,
    //     aolToPol6,
    //     uolToPol1,
    //     uolToPol2,
    //     uolToPol3,
    //     uolToPol4,
    //     uolToPol5,
    //     uolToPol6,

    //   ];

    //   graph = FlexibleTreeLayout(
    //     // nodeSize:
    //     //     Size(120,60), // the size of each nodes
    //     offset: const Offset(70, 30), // the offset between each level
    //     nodes: myNodes,

    //     // flipAxis: true,
    //     // vertical: false,

    //     centerLayout: true,
    //     orientation: ftlOrientation.vertical,
    //     edges: myEdges,
    //   );

    // print(
    //     "total height ${graph!.totalHeight} total width ${graph!.totalWidth}");

    return Center(
      child: Container(
        width: graph!.totalWidth,
        height: graph!.totalHeight,
        color: Colors.transparent,
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
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
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
      int lineRandom = Random().nextInt(44);

    for (var edge in g.edges) {
      // random double between 1-3
      double r = Random().nextDouble() * 3 + 1;

      // lineRandom 0-100

      final p2 = Paint()
        ..color = Colors.black
        ..strokeWidth = r
        ..style = PaintingStyle.stroke;

      Node fromNode = edge.from;
      Node toNode = edge.to;
      if (lineRandom >= 30) {

  Path path = Path();
      path.moveTo(fromNode.bottomCenter.dx + 0, fromNode.bottomCenter.dy);
      path.cubicTo(
          fromNode.bottomCenter.dx,
          fromNode.bottomCenter.dy + 100,
          toNode.topCenter.dx,
          toNode.topCenter.dy - 100,
          toNode.topCenter.dx,
          toNode.topCenter.dy);
      canvas.drawPath(path, p2);


      }
    

    if (lineRandom >= 5 && lineRandom < 30) {

 
      // 1. find diff between both nodes
      double diffX = toNode.topCenter.dx - fromNode.bottomCenter.dx;
      double diffY = toNode.topCenter.dy - fromNode.bottomCenter.dy;

      // draw line to the middle of the node

      var p = Path();
      p.moveTo(fromNode.bottomCenter.dx, fromNode.bottomCenter.dy);
      p.lineTo(fromNode.bottomCenter.dx ,
          fromNode.bottomCenter.dy + diffY / 2);


 p.lineTo(toNode.topCenter.dx,
          toNode.topCenter.dy - diffY / 2);

      p.lineTo(toNode.topCenter.dx, toNode.topCenter.dy);


      canvas.drawPath(p, p2);

      // draw line from the middle of the node to the other node


      
    

       
      }




      if (lineRandom < 5) {
        double distance = 80;
        int numOfSegments = (distance / 4).floor();
        double deltaX =
            (toNode.topCenter.dx - fromNode.bottomCenter.dx) / numOfSegments;
        double deltaY =
            (toNode.topCenter.dy - fromNode.bottomCenter.dy) / numOfSegments;

        for (int i = 0; i < numOfSegments; i++) {
          if (i % 2 == 0) {
            canvas.drawLine(
                Offset(fromNode.bottomCenter.dx + deltaX * i,
                    fromNode.bottomCenter.dy + deltaY * i),
                Offset(fromNode.bottomCenter.dx + deltaX * (i + 1),
                    fromNode.bottomCenter.dy + deltaY * (i + 1)),
                p2);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
