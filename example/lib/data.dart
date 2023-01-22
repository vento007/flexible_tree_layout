import 'package:flexible_tree_layout/flexible_tree_layout.dart';
import 'package:flutter/material.dart';

Node node0 = Node('0');
Node nodez = Node.config(name: 'z', configuration: {
  'style': 'sometext',
});
Node node1 = Node('1');
Node node2 = Node('2');
Node node10 = Node('10');
Node node11 = Node.config(name: '11', configuration: {
  'style': 'flutterlogo',
  'someCustomKey': 'someCustomValue',
  'color': Colors.black
});
Node node12 = Node('12');
Node nodde112 = Node('112');
Node node20 = Node('20');
Node node21 = Node('21');
Node node22 = Node('22');
Node nodeA = Node('A');
Node nodeB = Node('B');
Node node10A = Node('10A');

Edge edge0 = Edge(node0, node1);
Edge node0toz = Edge(node0, nodez);
Edge edge1 = Edge(node1, node2);
Edge edge1to10 = Edge(node1, node10);
Edge edge1to11 = Edge(node1, node11);
Edge edge1to12 = Edge(node1, node12);
Edge edge12to112 = Edge.config(node11, nodde112, configuration: {
  'color': Colors.green,
  'someCustomKey': 'righToTop',
});
Edge edge20to22 = Edge(node20, node22);
Edge edge10to10A = Edge(node10, node10A);
Edge edge2to20 = Edge(node2, node20);
Edge edge20to21 = Edge(node10A, node21);
Edge edge0toA = Edge(node0, nodeA);
Edge edgeAtoB = Edge(nodeA, nodeB);
Edge edgeBto21 = Edge(nodeB, nodde112);


List<Node> myNodes =[
          node0,
          nodez,
          node1,
          node2,
          node10,
          node11,
          node12,
          node20,
          node21,
          node22,
          nodeA,
          nodeB,
          nodde112,
          node10A,
        ];

List<Edge> myEdges = [
          edge0,
          node0toz,
          edge1,
          edge1to10,
          edge1to11,
          edge1to12,
          edge12to112,
          edge20to22,
          edge10to10A,
          edge2to20,
          edge20to21,
          edge0toA,
          edgeAtoB,
          edgeBto21,
        ];