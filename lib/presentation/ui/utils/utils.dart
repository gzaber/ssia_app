import 'dart:math';

import 'package:flutter/cupertino.dart';

class Utils {
  static const String defaultIcon = 'assets/images/default.png';

  static const List<String> iconsList = [
    'assets/images/default.png',
    'assets/images/building1.png',
    'assets/images/building2.png',
    'assets/images/building3.png',
    'assets/images/building4.png',
    'assets/images/building5.png',
    'assets/images/building6.png',
    'assets/images/building7.png',
    'assets/images/system1.png',
    'assets/images/system2.png',
    'assets/images/system3.png',
    'assets/images/system4.png',
    'assets/images/line1.png',
    'assets/images/line2.png',
    'assets/images/unit1.png',
    'assets/images/unit2.png',
    'assets/images/unit3.png',
    'assets/images/keypad1.png',
    'assets/images/keypad2.png',
    'assets/images/keypad3.png',
    'assets/images/hardware1.png',
    'assets/images/door1.png',
    'assets/images/sensor1.png',
    'assets/images/light1.png',
    'assets/images/speaker1.png',
    'assets/images/input1.png',
    'assets/images/eth1.png',
    'assets/images/phone1.png',
  ];

  static Random random = new Random();
  static Color getRandomColor() {
    return Color.fromARGB(
        255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }
}
