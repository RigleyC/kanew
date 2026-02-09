/// Interface abstrata para conversão de documentos
/// Permite trocar entre diferentes implementações de editor
abstract class DocumentConverter<T> {
  /// Converte JSON/Markdown string para estrutura do editor
  T fromJson(String json);

  /// Converte estrutura do editor para JSON/Markdown string
  String toJson(T editorState);

  /// Normaliza conteúdo legado (texto simples → JSON/Markdown)
  String normalize(String? content);

  /// Retorna EditorState vazio
  T emptyEditorState();

  /// Extrai texto plano do documento (para preview/search)
  String toPlainText(T editorState);
}
