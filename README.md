![example reel](https://github.com/vento007/flexible_tree_layout/blob/master/doc/images/examples.gif)

## Flexible Tree Layout

A class that offers a simple way to create a flexible tree layout in your flutter app or web app. 

## How it works
The class will calculate all coordinates used for positioning the boxes and draw the lines. You can use either a Stack or a CustomPainter widget to render the graph itself. The lines will usually be rendered by a CustomPainter.
The look and feel is completely up to you, as the core function of this package is to do the math. the core of this package uses a BFS-type algorithm to calculate depts and on top of that, several functions to calculate all the positioning used.

 <img src="https://github.com/vento007/flexible_tree_layout/blob/master/doc/images/ftl.png"  >

## Features
Fully customizable, use Stack or CustomPainter for the rendering itself.
not opinionated, but a very flexible soloution that let you customize however you like.
Supports optional key/value configuration per node for even more flexible rendering options.

## What this is not
If you are looking for complex diagrams, such as nodes with edges to grandchildren, this package is not suitable. It renders graphs similar to illustrations. If your dataset is not very similar to the illustrations, you might want to look for a Buchheim Walker algorithm-style solution.

Also, while you can find random generated examples in the example/main.dart, this is not supposed to deliver a fininshed render. its main purpose is to calculate cordinates and render box positions which you can then render in flutter.

### Getting started
Clone the project, and then run the example code. Depending on your target platform, you might need to run
'flutter create .' before you can run the main.dart in example/

### Additional information
This is a work in progress. If you find any issues, please open a GitHub issue. Pull requests are welcome, and if there is enough interest, I will extend it with additional functionality