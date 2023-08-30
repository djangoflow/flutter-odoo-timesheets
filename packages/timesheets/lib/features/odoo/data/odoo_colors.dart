import 'package:flutter/material.dart';

enum OdooColors {
  white(color: Colors.white, colorLabel: 'White'),
  green(
    color: Color(0xFF4CAF50),
    colorLabel: 'Green',
  ),
  red(
    color: Color(0xFFE53935),
    colorLabel: 'Red',
  ),
  yellow(
    color: Color(0xFFFFEB3B),
    colorLabel: 'Yellow',
  ),
  orange(
    color: Color(0xFFFF9800),
    colorLabel: 'Orange',
  ),
  lightBlue(
    color: Color(0xFF03A9F4),
    colorLabel: 'Light Blue',
  ),
  mediumBlue(
    color: Color(0xFF2962FF),
    colorLabel: 'Medium Blue',
  ),
  darkBlue(
    color: Color(0xFF0D47A1),
    colorLabel: 'Dark Blue',
  ),
  purple(
    color: Color(0xFF9C27B0),
    colorLabel: 'Purple',
  ),
  darkPurple(
    color: Color(0xFF311B92),
    colorLabel: 'Dark Purple',
  ),
  fushia(
    color: Color(0xFFE91E63),
    colorLabel: 'Fushia',
  ),
  salmonPink(
    color: Color(0xFFE57373),
    colorLabel: 'Salmon Pink',
  );

  final Color color;
  final String colorLabel;
  const OdooColors({required this.color, required this.colorLabel});
}
