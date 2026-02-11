import sys
import os

file_path = "kanew_flutter/lib/core/widgets/rich_text_editor/rich_text_editor_super.dart"

with open(file_path, "rb") as f:
    content = f.read().decode('utf-8').replace('\r\n', '\n')

# Replace _buildStylesheet signature and body start
old_stylesheet = """  Stylesheet _buildStylesheet(
    ColorScheme colorScheme, {
    required bool isEmptyDoc,
  }) {
    final minHeight = widget.config.minHeight ?? 0;
    final extraBottomPadding =
        isEmptyDoc ? math.max(0, minHeight - 24) : 0;
    return Stylesheet(
      rules: [
        // Base style for all blocks
        StyleRule(
          BlockSelector.all,
          (doc, docNode) {
            return {
              Styles.padding: CascadingPadding.only(
                top: 4,
                bottom: 4 + extraBottomPadding.toDouble(),
              ),
              Styles.textStyle: TextStyle("""

new_stylesheet = """  Stylesheet _buildStylesheet(ColorScheme colorScheme) {
    return Stylesheet(
      rules: [
        // Base style for all blocks
        StyleRule(
          BlockSelector.all,
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(
                top: 4,
                bottom: 4,
              ),
              Styles.textStyle: TextStyle("""

if old_stylesheet not in content:
    print("Could not find old_stylesheet block")
    # Debug
    start_match = "Stylesheet _buildStylesheet"
    idx = content.find(start_match)
    if idx != -1:
        print("Found nearby content:")
        print(repr(content[idx:idx+200]))
    sys.exit(1)

content = content.replace(old_stylesheet, new_stylesheet)

# Replace build method body
old_build_start = """    // Return SuperEditor directly. It produces a RenderSliver.
    // Needs to be placed inside a CustomScrollView.
    final isEmptyDoc = _isDocumentEmpty(editorState.document);

    return SuperEditor(
      scrollController: _scrollController,
      editor: editorState.editor,
      selectionLayerLinks: _selectionLinks,
      stylesheet: _buildStylesheet(colorScheme, isEmptyDoc: isEmptyDoc),
      componentBuilders: _buildComponentBuilders(),
      selectionStyle: SelectionStyles(
        selectionColor: colorScheme.primary.withValues(alpha: 0.3),
      ),
      documentOverlayBuilders: [
        // Filtrar para evitar duplicação do caret
        ...defaultSuperEditorDocumentOverlayBuilders.where(
          (builder) => builder is! DefaultCaretOverlayBuilder,
        ),
        // Caret customizado
        DefaultCaretOverlayBuilder(
          caretStyle: CaretStyle(
            color: colorScheme.primary,
            width: 2.0,
          ),
        ),
      ],
      // Enable keyboard shortcuts (Cmd+B, etc) and markdown input handlers
      keyboardActions: [
        if (_slashMenuPlugin != null)
          ({
            required SuperEditorContext editContext,
            required KeyEvent keyEvent,
          }) =>
              _slashMenuPlugin!.onKeyEvent(editContext, keyEvent),
        _copyRichTextWhenAvailable,
        _pasteRichTextWhenAvailable,
        ...defaultKeyboardActions,
      ],
    );"""

new_build_start = """    // Determine if we should show placeholder
    final isEmptyDoc = _isDocumentEmpty(editorState.document);
    final showPlaceholder = isEmptyDoc &&
        widget.config.placeholder.isNotEmpty &&
        !widget.config.readOnly;

    return SliverToBoxAdapter(
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: widget.config.minHeight ?? 0,
            ),
            child: SuperEditor(
              scrollController: _scrollController,
              editor: editorState.editor,
              selectionLayerLinks: _selectionLinks,
              stylesheet: _buildStylesheet(colorScheme),
              componentBuilders: _buildComponentBuilders(),
              selectionStyle: SelectionStyles(
                selectionColor: colorScheme.primary.withValues(alpha: 0.3),
              ),
              documentOverlayBuilders: [
                // Filtrar para evitar duplicação do caret
                ...defaultSuperEditorDocumentOverlayBuilders.where(
                  (builder) => builder is! DefaultCaretOverlayBuilder,
                ),
                // Caret customizado
                DefaultCaretOverlayBuilder(
                  caretStyle: CaretStyle(
                    color: colorScheme.primary,
                    width: 2.0,
                  ),
                ),
              ],
              // Enable keyboard shortcuts (Cmd+B, etc) and markdown input handlers
              keyboardActions: [
                if (_slashMenuPlugin != null)
                  ({
                    required SuperEditorContext editContext,
                    required KeyEvent keyEvent,
                  }) =>
                      _slashMenuPlugin!.onKeyEvent(editContext, keyEvent),
                _copyRichTextWhenAvailable,
                _pasteRichTextWhenAvailable,
                ...defaultKeyboardActions,
              ],
            ),
          ),
          if (showPlaceholder)
            Positioned(
              left: 0,
              top: 4, // Aligns with paragraph padding top
              child: IgnorePointer(
                child: Text(
                  widget.config.placeholder,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
            ),
        ],
      ),
    );"""

if old_build_start not in content:
    print("Could not find old_build_start block")
    idx = content.find("isEmptyDoc = _isDocumentEmpty")
    if idx != -1:
        print("Found context around isEmptyDoc:")
        print(repr(content[idx:idx+200]))
    sys.exit(1)

content = content.replace(old_build_start, new_build_start)

with open(file_path, "w", encoding='utf-8') as f:
    f.write(content)

print("Success")
