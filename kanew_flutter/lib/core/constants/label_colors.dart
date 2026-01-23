import 'package:flutter/material.dart';

class LabelColorOption {
  final String name;
  final String hex;
  final Color color;

  const LabelColorOption._({
    required this.name,
    required this.hex,
    required this.color,
  });

  static LabelColorOption fromHex(String name, String hex) {
    final hexCode = hex.replaceAll('#', '');
    final color = Color(int.parse('FF$hexCode', radix: 16));
    return LabelColorOption._(name: name, hex: hex, color: color);
  }
}

class LabelColors {
  LabelColors._();

  static final List<LabelColorOption> options = [
    LabelColorOption.fromHex('Red', '#F44336'),
    LabelColorOption.fromHex('Pink', '#E91E63'),
    LabelColorOption.fromHex('Purple', '#9C27B0'),
    LabelColorOption.fromHex('Indigo', '#3F51B5'),
    LabelColorOption.fromHex('Blue', '#2196F3'),
    LabelColorOption.fromHex('Teal', '#009688'),
    LabelColorOption.fromHex('Green', '#4CAF50'),
    LabelColorOption.fromHex('Yellow', '#FFEB3B'),
    LabelColorOption.fromHex('Orange', '#FF9800'),
    LabelColorOption.fromHex('Grey', '#9E9E9E'),
  ];

  static Color parseHex(String hex) {
    final hexCode = hex.replaceAll('#', '');
    if (hexCode.length == 6) {
      return Color(int.parse('FF$hexCode', radix: 16));
    }
    return Color(int.parse(hexCode, radix: 16));
  }
}
