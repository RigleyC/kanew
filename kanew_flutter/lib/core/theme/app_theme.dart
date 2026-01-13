import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// App theme configuration using forui
class AppTheme {
  /// Dark theme (primary for Kanew)
  static FThemeData get dark => FThemes.zinc.dark;

  /// Light theme
  static FThemeData get light => FThemes.zinc.light;

  /// Custom accent color (cyan)
  static const accentColor = Color(0xFF00d9ff);

  /// Gradient for auth screens
  static const authGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1a1a2e),
      Color(0xFF16213e),
      Color(0xFF0f3460),
    ],
  );
}
