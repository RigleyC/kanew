/// Tipos de blocos disponíveis no editor
enum EditorBlockType {
  paragraph,
  heading1,
  heading2,
  heading3,
  bulletedList,
  numberedList,
  todoList,
  quote, // Futuro
  codeBlock, // Futuro
  divider, // Futuro
  image, // Futuro
}

/// Configuração imutável do editor rich text
/// Permite adicionar novos blocos/comportamentos sem modificar o widget principal
class RichTextEditorConfig {
  final Set<EditorBlockType> enabledBlocks;
  final bool showToolbar;
  final bool enableSlashCommands;
  final Duration autoSaveDebounce;
  final int maxDocumentSizeBytes;
  final String placeholder;
  final bool readOnly;
  final double? minHeight;
  final double? maxHeight;

  const RichTextEditorConfig({
    this.enabledBlocks = const {
      EditorBlockType.paragraph,
      EditorBlockType.heading1,
      EditorBlockType.heading2,
      EditorBlockType.heading3,
      EditorBlockType.bulletedList,
      EditorBlockType.numberedList,
      EditorBlockType.todoList,
    },
    this.showToolbar = false,
    this.enableSlashCommands = true,
    this.autoSaveDebounce = const Duration(milliseconds: 500),
    this.maxDocumentSizeBytes = 50 * 1024, // 50KB
    this.placeholder = 'Digite "/" para comandos...',
    this.readOnly = false,
    this.minHeight = 150,
    this.maxHeight = 400,
  });

  /// Preset para descrição de Card
  factory RichTextEditorConfig.cardDescription({bool readOnly = false}) {
    return RichTextEditorConfig(
      readOnly: readOnly,
      placeholder: 'Adicione uma descrição. Use "/" para formatação...',
    );
  }

  /// Preset para comentários (futuro)
  factory RichTextEditorConfig.comment({bool readOnly = false}) {
    return RichTextEditorConfig(
      enabledBlocks: const {
        EditorBlockType.paragraph,
        EditorBlockType.bulletedList,
      },
      readOnly: readOnly,
      placeholder: 'Adicione um comentário...',
    );
  }

  /// Copia a configuração com modificações
  RichTextEditorConfig copyWith({
    Set<EditorBlockType>? enabledBlocks,
    bool? showToolbar,
    bool? enableSlashCommands,
    Duration? autoSaveDebounce,
    int? maxDocumentSizeBytes,
    String? placeholder,
    bool? readOnly,
    double? minHeight,
    double? maxHeight,
  }) {
    return RichTextEditorConfig(
      enabledBlocks: enabledBlocks ?? this.enabledBlocks,
      showToolbar: showToolbar ?? this.showToolbar,
      enableSlashCommands: enableSlashCommands ?? this.enableSlashCommands,
      autoSaveDebounce: autoSaveDebounce ?? this.autoSaveDebounce,
      maxDocumentSizeBytes: maxDocumentSizeBytes ?? this.maxDocumentSizeBytes,
      placeholder: placeholder ?? this.placeholder,
      readOnly: readOnly ?? this.readOnly,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
    );
  }
}
