import 'package:flutter_test/flutter_test.dart';
import 'package:super_editor/super_editor.dart';

import 'package:kanew_flutter/core/widgets/rich_text_editor/converters/html_clipboard_paste.dart';

void main() {
  test('pastes HTML as formatted document content', () {
    final document = MutableDocument(nodes: [
      ParagraphNode(
        id: Editor.createNodeId(),
        text: AttributedText(''),
      ),
    ]);
    final composer = MutableDocumentComposer();
    composer.setSelectionWithReason(
      DocumentSelection.collapsed(
        position: DocumentPosition(
          nodeId: document.firstOrNull!.id,
          nodePosition: const TextNodePosition(offset: 0),
        ),
      ),
    );

    final editor = createDefaultDocumentEditor(
      document: document,
      composer: composer,
    );

    pasteHtmlIntoEditorWithHeadingFix(editor, '<p>Hello <strong>world</strong></p>');

    final node = document.firstOrNull as ParagraphNode;
    final text = node.text;
    expect(text.toPlainText(), 'Hello world');

    final spans = text.getAttributionSpans({boldAttribution});
    expect(spans, isNotEmpty);

    // Ensure at least part of the string is bold (best-effort, exact ranges depend on html2md).
    final boldSpanCoversWorld = spans.any((span) {
      // `AttributionSpan` uses inclusive `end`.
      final boldText = text.toPlainText().substring(span.start, span.end + 1);
      return boldText.contains('world');
    });
    expect(boldSpanCoversWorld, isTrue);
  });

  test('pastes HTML headings as header blocks', () {
    final document = MutableDocument(nodes: [
      ParagraphNode(
        id: Editor.createNodeId(),
        text: AttributedText(''),
      ),
    ]);
    final composer = MutableDocumentComposer();
    composer.setSelectionWithReason(
      DocumentSelection.collapsed(
        position: DocumentPosition(
          nodeId: document.firstOrNull!.id,
          nodePosition: const TextNodePosition(offset: 0),
        ),
      ),
    );

    final editor = createDefaultDocumentEditor(
      document: document,
      composer: composer,
    );

    pasteHtmlIntoEditorWithHeadingFix(editor, '<h1>Title</h1><h2>Subtitle</h2>');

    final paragraphs = document.whereType<ParagraphNode>().toList();

    final header1 = paragraphs.where((node) {
      return node.getMetadataValue(NodeMetadata.blockType) == header1Attribution &&
          node.text.toPlainText() == 'Title';
    });
    expect(header1, isNotEmpty);

    final header2 = paragraphs.where((node) {
      return node.getMetadataValue(NodeMetadata.blockType) == header2Attribution &&
          node.text.toPlainText() == 'Subtitle';
    });
    expect(header2, isNotEmpty);
  });
}
