<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->



<img src="https://github.com/vento007/flexible_tree_layout/blob/master/doc/images/ftl.png" width="540" >

## Flexible Tree Layout

A class that offers a simple way to create a flexible tree layout in your flutter app or webapp. You need to configure the Nodes and Edges, and in the render widget, you can customize it however you like. 

The class will calculate all coordinates used for positioning the boxes and draw the lines. You can use either a Stack or a CustomPainter widget to render the graph itself. The lines will usually be rendered by a CustomPainter. 

The look and feel is completely up to you, as the core function of this package is to do the math. the core of this package uses a BFS type algoritm to calculate depts and on top of that a number of functions to calculate all the positioning used. 

## Features

- Fully customizable, use Stack or CustomPainter for the rendering itself.
- not opionated, but very flexible
- pass in custom key/values for total control of the rendering.

## What this not is

If you are looking for complex diagrams, such as nodes with edges to grandchildren, this package is not suitable. It renders graphs similar to illustrations. If your dataset is not very similar to the illustrations, you might want to look for a Buchheim Walker algorithm-style solution.



## Getting started

Clone the project, and then run the example code

## Additional information

This is a work in progress. If you find any issues, please open a GitHub issue. Pull requests are welcome, and if there is enough interest, I will extend it with additional functionality