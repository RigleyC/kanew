import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanew_flutter/core/widgets/rich_text_editor/rich_text_editor_config.dart';
import 'package:kanew_flutter/core/widgets/rich_text_editor/rich_text_editor_super.dart';
import 'package:super_editor/super_editor.dart';

void main() {
  testWidgets('shows placeholder when document is empty', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              RichTextEditorSuper(
                key: const ValueKey('editor'),
                initialContent: '',
                config: RichTextEditorConfig.cardDescription(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Adicione uma descrição. Use "/" para formatação...'),
      findsOneWidget,
    );
  });

  testWidgets('keeps a stable minHeight for short docs', (tester) async {
    Future<double> pumpEditorAndGetExtent(String initialContent) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                RichTextEditorSuper(
                  key: ValueKey('editor:$initialContent'),
                  initialContent: initialContent,
                  config: RichTextEditorConfig.cardDescription(),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final renderObject = tester.renderObject(find.byType(SuperEditor));
      final sliver = renderObject as RenderSliver;
      return sliver.geometry!.scrollExtent;
    }

    final emptyExtent = await pumpEditorAndGetExtent('');
    final oneCharExtent = await pumpEditorAndGetExtent('a');

    expect(emptyExtent, greaterThanOrEqualTo(150));
    expect(oneCharExtent, greaterThanOrEqualTo(150));
    expect((emptyExtent - oneCharExtent).abs(), lessThan(24));
  });
}
