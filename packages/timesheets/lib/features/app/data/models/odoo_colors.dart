import 'package:flutter/material.dart';

enum OdooColors {
  noColor(color: Color(0xFFFFFFFF), colorLabel: 'No color', colorIndex: 0),
  red(color: Color(0xFFF06050), colorLabel: 'Red', colorIndex: 1),
  orange(color: Color(0xFFF4A460), colorLabel: 'Orange', colorIndex: 2),
  yellow(color: Color(0xFFF7CD1F), colorLabel: 'Yellow', colorIndex: 3),
  cyan(color: Color(0xFF6CC1ED), colorLabel: 'Cyan', colorIndex: 4),
  purple(color: Color(0xFF814968), colorLabel: 'Purple', colorIndex: 5),
  almond(color: Color(0xFFEB7E7F), colorLabel: 'Almond', colorIndex: 6),
  teal(color: Color(0xFF2C8397), colorLabel: 'Teal', colorIndex: 7),
  blue(color: Color(0xFF475577), colorLabel: 'Blue', colorIndex: 8),
  raspberry(color: Color(0xFFD6145F), colorLabel: 'Raspberry', colorIndex: 9),
  green(color: Color(0xFF30C381), colorLabel: 'Green', colorIndex: 10),
  violet(color: Color(0xFF9365B8), colorLabel: 'Violet', colorIndex: 11);

  final Color color;
  final String colorLabel;
  final int colorIndex;

  const OdooColors({
    required this.color,
    required this.colorLabel,
    required this.colorIndex,
  });

  static OdooColors fromIndex(int index) => OdooColors.values.firstWhere(
        (color) => color.colorIndex == index,
        orElse: () => OdooColors.noColor,
      );
}
