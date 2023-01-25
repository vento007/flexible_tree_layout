import 'dart:math';

import 'package:flutter/material.dart';

class ColorModel {
  final Color color;
  final Color textColor;

  ColorModel(this.color, this.textColor);
}

ColorModel randomColor() {
  List<Map<int, ColorModel>> colors = [
    {
      1: ColorModel(
          const Color(0xff227c9d), const Color.fromARGB(255, 0, 0, 0)),
      2: ColorModel(
          const Color(0xff17c3b2), const Color.fromARGB(255, 0, 0, 0)),
      3: ColorModel(
          const Color(0xffffcb77), const Color.fromARGB(255, 0, 0, 0)),
      4: ColorModel(
          const Color(0xfffef9ef), const Color.fromARGB(255, 0, 0, 0)),
      5: ColorModel(
          const Color(0xfff36d73), const Color.fromARGB(255, 0, 0, 0)),
      6: ColorModel(
          const Color(0xff264653), const Color.fromARGB(255, 255, 255, 255)),
      7: ColorModel(
          const Color(0xff264653), const Color.fromARGB(255, 255, 255, 255)),
      8: ColorModel(
          const Color(0xff264653), const Color.fromARGB(255, 255, 255, 255)),
      9: ColorModel(
          const Color(0xff264653), const Color.fromARGB(255, 255, 255, 255)),
      10: ColorModel(Colors.black, const Color.fromARGB(255, 255, 255, 255)),
      11: ColorModel(Colors.black, const Color.fromARGB(255, 255, 255, 255)),
      12: ColorModel(Colors.black, const Color.fromARGB(255, 255, 255, 255)),
    }
  ];

// random color
  int random = Random().nextInt(colors.length);
  ColorModel color = colors[random].values.first;

  return color;
}
