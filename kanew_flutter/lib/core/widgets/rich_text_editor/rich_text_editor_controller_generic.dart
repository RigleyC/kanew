import 'dart:async';
import 'package:flutter/foundation.dart';
import 'converters/document_converter_base.dart';
import 'converters/super_editor_document_converter.dart';

/// Controller genérico do editor com auto-save
class RichTextEditorController<T> extends ChangeNotifier {
  final DocumentConverter<T> _converter;
  final Duration _debounce;
  final Future<void> Function(String content)? _onSave;
  final int _maxSizeBytes;

  T? _editorState;
  Timer? _debounceTimer;
  String? _lastSavedContent;
  bool _isDirty = false;

  bool _isSaving = false;
  String? _lastSaveError;
  void Function(dynamic)? _documentListener;
  bool _isDisposed = false;
  bool _pendingSave = false;

  RichTextEditorController({
    required DocumentConverter<T> converter,
    required Duration debounce,
    Future<void> Function(String content)? onSave,
    int maxSizeBytes = 50 * 1024,
  })  : _converter = converter,
        _debounce = debounce,
        _onSave = onSave,
        _maxSizeBytes = maxSizeBytes;

  T? get editorState => _editorState;
  bool get isDirty => _isDirty;
  bool get isSaving => _isSaving;
  String? get lastSaveError => _lastSaveError;

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
      _documentListener = (_) => _onContentChanged();
      editorState.document.addListener(_documentListener!);
    }
  }

  void _onContentChanged() {
    final wasDirty = _isDirty;
    _isDirty = true;
    if (!wasDirty) {
      _safeNotify();
    }

    // Cancelar timer anterior
    _debounceTimer?.cancel();

    // Agendar novo save
    _debounceTimer = Timer(_debounce, _save);
  }

  Future<void> _save() async {
    final state = _editorState;
    if (state == null || _onSave == null) return;

    if (_isSaving) {
      _pendingSave = true;
      return;
    }

    final content = _converter.toJson(state);

    if (content.length > _maxSizeBytes) {
      _lastSaveError = 'Documento excede o limite de ${(_maxSizeBytes / 1024).round()}KB.';
      _safeNotify();
      return;
    }

    // Evitar saves desnecessários
    if (content == _lastSavedContent) {
      final wasDirty = _isDirty;
      _isDirty = false;
      if (wasDirty) {
        _safeNotify();
      }
      return;
    }

    _isSaving = true;
    _lastSaveError = null;
    _safeNotify();

    try {
      await _onSave(content);
      _isDirty = false;
      _lastSavedContent = content;
    } catch (e) {
      _lastSaveError = 'Falha ao salvar: ${e.toString()}';
    } finally {
      _isSaving = false;
      _safeNotify();
      if (_pendingSave) {
        _pendingSave = false;
        unawaited(_save());
      }
    }
  }

  /// Força save imediato (para quando sair da tela)
  Future<void> saveNow() async {
    _debounceTimer?.cancel();
    await _save();
  }

  /// Best-effort save meant to be called right before disposal.
  ///
  /// This method captures the current serialized content synchronously and then
  /// performs the save without emitting state notifications. This avoids async
  /// work trying to read editor state after disposal.
  Future<void> saveNowBestEffort() async {
    final state = _editorState;
    if (state == null || _onSave == null) return;

    _debounceTimer?.cancel();

    final content = _converter.toJson(state);

    if (content.length > _maxSizeBytes) {
      return;
    }

    if (content == _lastSavedContent) {
      return;
    }

    try {
      await _onSave(content);
      _lastSavedContent = content;
      _isDirty = false;
    } catch (_) {
      // Ignore errors on best-effort save.
    }
  }

  /// Retorna texto plano para preview
  String toPlainText() {
    final state = _editorState;
    if (state == null) return '';
    return _converter.toPlainText(state);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();

    if (_editorState is EditorState) {
      final state = _editorState as EditorState;
      if (_documentListener != null) {
        state.document.removeListener(_documentListener!);
      }
      state.dispose();
    }

    super.dispose();
  }

  void _safeNotify() {
    if (_isDisposed) return;
    notifyListeners();
  }
}
