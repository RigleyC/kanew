import 'package:flutter_test/flutter_test.dart';
import 'package:kanew_flutter/main.dart';

void main() {
  group('App Smoke Tests', () {
    test('App initialization should not throw', () {
      expect(() => const KanewApp(), returnsNormally);
    });

    testWidgets('App widget builds without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const KanewApp());
      expect(find.byType(KanewApp), findsOneWidget);
    });
  });
}
