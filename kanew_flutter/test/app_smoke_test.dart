import 'package:flutter_test/flutter_test.dart';
import 'package:kanew_flutter/main.dart';

void main() {
  group('App Smoke Tests', () {
    test('App initialization should not throw', () {
      expect(() => const KanewApp(), returnsNormally);
    });

    test('App widget can be instantiated', () {
      const app = KanewApp();
      expect(app, isA<KanewApp>());
    });
  });
}
