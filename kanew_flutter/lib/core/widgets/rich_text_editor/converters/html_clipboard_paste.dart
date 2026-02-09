import 'package:html2md/html2md.dart' as html2md;
import 'package:super_editor/super_editor.dart';

String convertHtmlToMarkdownWithHeadingFix(String html) {
  final markdown = html2md.convert(html);
  return _normalizeSetextHeadingsToAtx(markdown);
}

MutableDocument convertHtmlToDocumentWithHeadingFix(String html) {
  final markdown = convertHtmlToMarkdownWithHeadingFix(html);
  return deserializeMarkdownToDocument(markdown);
}

void pasteHtmlIntoEditorWithHeadingFix(Editor editor, String html) {
  final contentToPaste = convertHtmlToDocumentWithHeadingFix(html);

  final composer = editor.composer;
  final selection = composer.selection;
  if (selection == null) {
    return;
  }

  DocumentPosition? pastePosition = selection.extent;

  // Delete all currently selected content.
  if (!selection.isCollapsed) {
    pastePosition = CommonEditorOperations.getDocumentPositionAfterExpandedDeletion(
      document: editor.document,
      selection: selection,
    );

    if (pastePosition == null) {
      // There are no deletable nodes in the selection. Do nothing.
      return;
    }

    editor.execute([
      DeleteContentRequest(documentRange: selection),
      ChangeSelectionRequest(
        DocumentSelection.collapsed(position: pastePosition),
        SelectionChangeType.deleteContent,
        SelectionReason.userInteraction,
      ),
    ]);
  }

  editor.execute([
    PasteStructuredContentEditorRequest(
      content: contentToPaste,
      pastePosition: pastePosition,
    ),
  ]);
}

String _normalizeSetextHeadingsToAtx(String markdown) {
  final lines = markdown.split(RegExp(r'\r?\n'));
  final normalized = <String>[];

  for (var i = 0; i < lines.length; i++) {
    if (i + 1 < lines.length) {
      final title = lines[i].trimRight();
      final underline = lines[i + 1].trim();

      if (title.isNotEmpty && _isRunOf(underline, '=')) {
        normalized.add('# $title');
        i++; // Skip underline
        continue;
      }

      if (title.isNotEmpty && _isRunOf(underline, '-')) {
        normalized.add('## $title');
        i++; // Skip underline
        continue;
      }
    }

    normalized.add(lines[i]);
  }

  return normalized.join('\n');
}

bool _isRunOf(String value, String char) {
  if (value.isEmpty) return false;
  final codeUnit = char.codeUnitAt(0);
  for (final unit in value.codeUnits) {
    if (unit != codeUnit) return false;
  }
  return true;
}

