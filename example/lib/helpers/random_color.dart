import 'dart:math';

import 'package:flutter/material.dart';

class ColorModel {
  final Color color;
  final Color textColor;

  ColorModel(this.color, this.textColor);
}

ColorModel randomColor() {
  List<ColorModel> colors = [
    ColorModel(const Color(0xff227c9d), const Color.fromARGB(255, 0, 0, 0)),
    ColorModel(const Color(0xff17c3b2), const Color.fromARGB(255, 0, 0, 0)),
    ColorModel(const Color(0xffffcb77), const Color.fromARGB(255, 0, 0, 0)),
    ColorModel(const Color(0xfffef9ef), const Color.fromARGB(255, 0, 0, 0)),
    ColorModel(const Color(0xfff36d73), const Color.fromARGB(255, 0, 0, 0)),
    ColorModel(
        const Color(0xff264653), const Color.fromARGB(255, 255, 255, 255)),
    ColorModel(
        const Color(0xff264653), const Color.fromARGB(255, 255, 255, 255)),
    ColorModel(
        const Color(0xff264653), const Color.fromARGB(255, 255, 255, 255)),
    ColorModel(
        const Color(0xff264653), const Color.fromARGB(255, 255, 255, 255)),
    ColorModel(Colors.blue, const Color.fromARGB(33, 150, 243, 255)),
    ColorModel(Colors.green, const Color.fromARGB(76, 175, 80, 255)),
    ColorModel(Colors.red, const Color.fromARGB(244, 67, 54, 255)),
  ];

// random color
  int random = Random().nextInt(colors.length);
  ColorModel color = colors[random];
  return color;
}
