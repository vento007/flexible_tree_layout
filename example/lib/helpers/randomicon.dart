import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RandomIcon extends StatelessWidget {
  const RandomIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // generate random icon from the cupertino set
    List<IconData> icons = [
      CupertinoIcons.add,
      CupertinoIcons.add_circled,
      CupertinoIcons.add_circled_solid,
      CupertinoIcons.back,
      CupertinoIcons.calendar,
      CupertinoIcons.decrease_indent,
      CupertinoIcons.delete_left_fill,
      CupertinoIcons.waveform,
      CupertinoIcons.alarm,
      CupertinoIcons.alarm_fill,
    ];

    // random icon
    int random = Random().nextInt(icons.length);
    IconData icon = icons[random];

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
 
    return Container(
      child: Icon(
        icon,
        size: 32,
        color: colors[r],
      ),
    );
  }
}
