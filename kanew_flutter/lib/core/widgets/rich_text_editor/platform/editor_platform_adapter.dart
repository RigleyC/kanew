import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Interface para adaptação de plataforma
/// Permite comportamento diferente em Web vs Mobile
abstract class EditorPlatformAdapter {
  /// Configurações específicas de scroll
  ScrollPhysics get scrollPhysics;

  /// Padding adicional para keyboard em mobile
  EdgeInsets get keyboardPadding;

  /// Se deve mostrar toolbar floating em mobile
  bool get useFloatingToolbar;

  /// Altura mínima do editor
  double get minHeight;

  /// Factory para obter adapter correto
  factory EditorPlatformAdapter.current() {
    if (kIsWeb) {
      return WebEditorAdapter();
    }
    // Futuro: MobileEditorAdapter()
    return WebEditorAdapter(); // Fallback para web por enquanto
  }
}

/// Implementação Web
class WebEditorAdapter implements EditorPlatformAdapter {
  @override
  ScrollPhysics get scrollPhysics => const ClampingScrollPhysics();

  @override
  EdgeInsets get keyboardPadding => EdgeInsets.zero;

  @override
  bool get useFloatingToolbar => false;

  @override
  double get minHeight => 120;
}

// Implementação Mobile (futuro)
// class MobileEditorAdapter implements EditorPlatformAdapter {
//   @override
//   ScrollPhysics get scrollPhysics => const BouncingScrollPhysics();
//
//   @override
//   EdgeInsets get keyboardPadding => const EdgeInsets.only(bottom: 300);
//
//   @override
//   bool get useFloatingToolbar => true;
//
//   @override
//   double get minHeight => 200;
// }
