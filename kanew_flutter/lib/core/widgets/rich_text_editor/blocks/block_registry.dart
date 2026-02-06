import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import '../rich_text_editor_config.dart';

/// Registro de blocos disponíveis
/// Facilita adicionar novos blocos no futuro
class BlockRegistry {
  /// Constrói mapa de builders baseado na config
  static Map<String, BlockComponentBuilder> buildFromConfig(
    RichTextEditorConfig config,
  ) {
    final builders = <String, BlockComponentBuilder>{};

    builders['page'] = PageBlockComponentBuilder();

    for (final blockType in config.enabledBlocks) {
      final entry = _blockBuilders[blockType];
      if (entry != null) {
        builders[entry.key] = entry.builder;
      }
    }

    return builders;
  }

  static final Map<EditorBlockType, _BlockEntry> _blockBuilders = {
    EditorBlockType.paragraph: _BlockEntry(
      key: ParagraphBlockKeys.type,
      builder: ParagraphBlockComponentBuilder(
        configuration: BlockComponentConfiguration(
          placeholderText: (_) => '',
        ),
      ),
    ),
    EditorBlockType.heading1: _BlockEntry(
      key: HeadingBlockKeys.type,
      builder: HeadingBlockComponentBuilder(),
    ),
    EditorBlockType.heading2: _BlockEntry(
      key: HeadingBlockKeys.type,
      builder: HeadingBlockComponentBuilder(),
    ),
    EditorBlockType.heading3: _BlockEntry(
      key: HeadingBlockKeys.type,
      builder: HeadingBlockComponentBuilder(),
    ),
    EditorBlockType.bulletedList: _BlockEntry(
      key: BulletedListBlockKeys.type,
      builder: BulletedListBlockComponentBuilder(
        configuration: BlockComponentConfiguration(
          padding: (_) => EdgeInsets.zero,
          textStyle: (node, {textSpan}) => const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: Color(0xFF37352F),
            height: 1.3,
          ),
        ),
      ),
    ),
    EditorBlockType.numberedList: _BlockEntry(
      key: NumberedListBlockKeys.type,
      builder: NumberedListBlockComponentBuilder(),
    ),
    EditorBlockType.todoList: _BlockEntry(
      key: TodoListBlockKeys.type,
      builder: TodoListBlockComponentBuilder(),
    ),
    // Futuros blocos:
    // EditorBlockType.quote: _BlockEntry(
    //   key: QuoteBlockKeys.type,
    //   builder: QuoteBlockComponentBuilder(),
    // ),
    // EditorBlockType.codeBlock: _BlockEntry(
    //   key: CodeBlockKeys.type,
    //   builder: CodeBlockComponentBuilder(),
    // ),
  };
}

class _BlockEntry {
  final String key;
  final BlockComponentBuilder builder;

  const _BlockEntry({required this.key, required this.builder});
}
