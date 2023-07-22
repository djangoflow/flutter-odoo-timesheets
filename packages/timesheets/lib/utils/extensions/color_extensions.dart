import 'package:flutter/material.dart';

extension ProjectColorExtensions on int? {
  Color get toColorFromColorIndex {
    switch (this) {
      case 1:
        return Colors.white;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.lightBlue;
      case 5:
        return Colors.purple;
      case 6:
        return Colors.pink;
      case 7:
        return Colors.blue;
      case 8:
        return Colors.deepPurple;
      case 9:
        return Colors.pink;
      case 10:
        return Colors.green;
      case 11:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
