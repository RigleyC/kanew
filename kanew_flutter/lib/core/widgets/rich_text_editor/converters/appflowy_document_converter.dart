import 'dart:convert';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'document_converter.dart';

/// Implementação específica do AppFlowy Editor
/// Converte entre JSON e estruturas do AppFlowy Editor
class AppFlowyDocumentConverter implements DocumentConverter {
  @override
  EditorState fromJson(String json) {
    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      final document = Document.fromJson(data);
      return EditorState(document: document);
    } catch (e) {
      // Fallback: trata como texto simples
      return _createParagraphEditorState(json);
    }
  }

  @override
  String toJson(EditorState editorState) {
    final documentJson = editorState.document.toJson();
    return jsonEncode(documentJson);
  }

  @override
  String normalize(String? content) {
    if (content == null || content.isEmpty) {
      return toJson(emptyEditorState());
    }

    // Tenta parsear como JSON
    try {
      jsonDecode(content);
      return content; // Já é JSON válido
    } catch (_) {
      // É texto simples, converter para formato AppFlowy
      return toJson(_createParagraphEditorState(content));
    }
  }

  @override
  EditorState emptyEditorState() {
    return EditorState(document: Document.blank());
  }

  @override
  String toPlainText(EditorState editorState) {
    final buffer = StringBuffer();
    for (final node in editorState.document.root.children) {
      final text = _nodeToText(node);
      if (text.isNotEmpty) {
        buffer.writeln(text);
      }
    }
    return buffer.toString().trim();
  }

  /// Cria um EditorState com parágrafos a partir de texto simples
  EditorState _createParagraphEditorState(String text) {
    final lines = text.split('\n');
    final nodes = <Node>[];

    for (final line in lines) {
      if (line.trim().isNotEmpty) {
        nodes.add(paragraphNode(text: line));
      }
    }

    // Se não houver linhas, criar um parágrafo vazio
    if (nodes.isEmpty) {
      nodes.add(paragraphNode(text: ''));
    }

    final document = Document(
      root: pageNode(children: nodes),
    );

    return EditorState(document: document);
  }

  /// Extrai texto de um nó recursivamente
  String _nodeToText(Node node) {
    final buffer = StringBuffer();

    // Se o nó tem delta (texto formatado)
    if (node.delta != null) {
      buffer.write(node.delta!.toPlainText());
    }

    // Processar filhos recursivamente
    for (final child in node.children) {
      final childText = _nodeToText(child);
      if (childText.isNotEmpty) {
        buffer.write(childText);
      }
    }

    return buffer.toString();
  }
}
