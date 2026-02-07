import 'package:super_editor/super_editor.dart';
import 'document_converter_base.dart';

/// Implementação do conversor para Super Editor
/// Usa Markdown como formato de serialização
class SuperEditorDocumentConverter implements DocumentConverter<EditorState> {
  @override
  EditorState fromJson(String json) {
    // Para Super Editor, vamos tratar o "JSON" como Markdown
    // Isso permite migração gradual e simplicidade
    return _createEditorStateFromMarkdown(json);
  }

  @override
  String toJson(EditorState editorState) {
    // Serializa o documento para Markdown
    final doc = editorState.document;
    return serializeDocumentToMarkdown(doc);
  }

  @override
  String normalize(String? content) {
    if (content == null || content.isEmpty) {
      // Retorna documento vazio em Markdown
      return '';
    }

    // Se já parece ser Markdown ou texto plano, retorna como está
    return content;
  }

  @override
  EditorState emptyEditorState() {
    // Cria um documento vazio com um parágrafo
    final doc = MutableDocument(
      nodes: [
        ParagraphNode(
          id: Editor.createNodeId(),
          text: AttributedText(),
        ),
      ],
    );

    final composer = MutableDocumentComposer();
    final editor = createDefaultDocumentEditor(
      document: doc,
      composer: composer,
    );

    return EditorState(
      document: doc,
      composer: composer,
      editor: editor,
    );
  }

  @override
  String toPlainText(EditorState editorState) {
    final doc = editorState.document;
    final buffer = StringBuffer();

    // Itera sobre os nós do documento
    for (final node in doc) {
      if (node is TextNode) {
        buffer.writeln(node.text.toPlainText());
      }
    }

    return buffer.toString().trim();
  }

  /// Cria um EditorState a partir de Markdown
  EditorState _createEditorStateFromMarkdown(String markdown) {
    if (markdown.isEmpty) {
      return emptyEditorState();
    }

    try {
      // Deserializa Markdown para Document
      final doc = deserializeMarkdownToDocument(markdown);
      
      // Se o documento está vazio, retorna estado vazio
      if (doc.isEmpty) {
        return emptyEditorState();
      }

      final composer = MutableDocumentComposer();
      final editor = createDefaultDocumentEditor(
        document: doc,
        composer: composer,
      );

      return EditorState(
        document: doc,
        composer: composer,
        editor: editor,
      );
    } catch (e) {
      print('[SuperEditorConverter] Error parsing markdown: $e');
      // Em caso de erro, trata como texto plano
      return _createEditorStateFromPlainText(markdown);
    }
  }

  /// Cria um EditorState a partir de texto plano
  EditorState _createEditorStateFromPlainText(String text) {
    final lines = text.split('\n');
    final nodes = <DocumentNode>[];

    for (final line in lines) {
      nodes.add(
        ParagraphNode(
          id: Editor.createNodeId(),
          text: AttributedText(line),
        ),
      );
    }

    // Se não houver linhas, criar um parágrafo vazio
    if (nodes.isEmpty) {
      nodes.add(
        ParagraphNode(
          id: Editor.createNodeId(),
          text: AttributedText(),
        ),
      );
    }

    final doc = MutableDocument(nodes: nodes);
    final composer = MutableDocumentComposer();
    final editor = createDefaultDocumentEditor(
      document: doc,
      composer: composer,
    );

    return EditorState(
      document: doc,
      composer: composer,
      editor: editor,
    );
  }
}

/// Estado do editor Super Editor
/// Agrupa Document, Composer e Editor
class EditorState {
  final MutableDocument document;
  final MutableDocumentComposer composer;
  final Editor editor;

  EditorState({
    required this.document,
    required this.composer,
    required this.editor,
  });

  void dispose() {
    composer.dispose();
    // Document e Editor não precisam de dispose explícito
  }
}
