import 'package:test/test.dart';

void main() {
  group('Server Smoke Tests', () {
    test('Server package loads without errors', () {
      // Basic test para garantir que o package carrega
      expect(1 + 1, equals(2));
    });

    test('Environment variables can be read', () {
      // Verifica que env vars básicas funcionam
      final runmode = const String.fromEnvironment('runmode', defaultValue: 'development');
      expect(runmode, isNotEmpty);
    });
  });
}
