import 'dart:math';

import 'package:flutter/material.dart';

class RandomNames extends StatelessWidget {
  const RandomNames({super.key});

  @override
  Widget build(BuildContext context) {
    // generate random icon from the cupertino set
final dogNames = ["Bella", "Max", "Charlie", "Rocky", "Luna", "Daisy", "Cooper", "Bailey", "Sadie", "Duke"];

    // random icon
    int random = Random().nextInt(dogNames.length);
    String name = dogNames[random];


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
      Colors.black,
      Colors.black,
    ];

    // random color
    int r = Random().nextInt(colors.length);
    Color color = colors[r];

    return Container(
      child: Text(
        name,
        style: TextStyle(
          color: color,
          fontSize: 15,
        )
      ),
    );
  }
}
