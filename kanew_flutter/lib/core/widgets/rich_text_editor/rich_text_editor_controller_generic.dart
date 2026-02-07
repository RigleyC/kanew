import 'dart:async';
import 'package:flutter/foundation.dart';
import 'converters/document_converter_base.dart';
import 'converters/super_editor_document_converter.dart';

/// Controller genérico do editor com auto-save
class RichTextEditorController<T> extends ChangeNotifier {
  final DocumentConverter<T> _converter;
  final Duration _debounce;
  final void Function(String json)? _onSave;

  T? _editorState;
  Timer? _debounceTimer;
  String? _lastSavedContent;
  bool _isDirty = false;

  RichTextEditorController({
    required DocumentConverter<T> converter,
    required Duration debounce,
    void Function(String json)? onSave,
  })  : _converter = converter,
        _debounce = debounce,
        _onSave = onSave;

  T? get editorState => _editorState;
  bool get isDirty => _isDirty;
  bool get isSaving => _debounceTimer?.isActive ?? false;

  /// Inicializa com conteúdo
  void initialize(String? content) {
    final normalizedJson = _converter.normalize(content);
    _editorState = _converter.fromJson(normalizedJson);
    _lastSavedContent = normalizedJson;

    // Para Super Editor, precisamos observar mudanças no documento
    _setupChangeListener();

    notifyListeners();
  }

  /// Setup do listener de mudanças
  /// Para SuperEditor, usamos o document listener
  void _setupChangeListener() {
    if (_editorState is EditorState) {
      final editorState = _editorState as EditorState;
      editorState.document.addListener((_) {
        _onContentChanged();
      });
    }
  }

  void _onContentChanged() {
    _isDirty = true;
    notifyListeners();

    // Cancelar timer anterior
    _debounceTimer?.cancel();

    // Agendar novo save
    _debounceTimer = Timer(_debounce, _save);
  }

  void _save() {
    final state = _editorState;
    if (state == null || _onSave == null) return;

    final json = _converter.toJson(state);

    // Evitar saves desnecessários
    if (json == _lastSavedContent) {
      _isDirty = false;
      notifyListeners();
      return;
    }

    _lastSavedContent = json;
    _onSave(json);
    _isDirty = false;
    notifyListeners();
  }

  /// Força save imediato (para quando sair da tela)
  void saveNow() {
    _debounceTimer?.cancel();
    _save();
  }

  /// Retorna texto plano para preview
  String toPlainText() {
    final state = _editorState;
    if (state == null) return '';
    return _converter.toPlainText(state);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    
    // Dispose do editor state se necessário
    if (_editorState is EditorState) {
      (_editorState as EditorState).dispose();
    }
    
    super.dispose();
  }
}
