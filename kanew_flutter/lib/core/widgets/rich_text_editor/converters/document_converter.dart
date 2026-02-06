import 'package:appflowy_editor/appflowy_editor.dart';

/// Interface abstrata para conversão de documentos
/// Permite trocar AppFlowy por outro formato no futuro
abstract class DocumentConverter {
  /// Converte JSON string para estrutura do editor
  EditorState fromJson(String json);

  /// Converte estrutura do editor para JSON string
  String toJson(EditorState editorState);

  /// Normaliza conteúdo legado (texto simples → JSON)
  String normalize(String? content);

  /// Retorna EditorState vazio
  EditorState emptyEditorState();

  /// Extrai texto plano do documento (para preview/search)
  String toPlainText(EditorState editorState);
}
