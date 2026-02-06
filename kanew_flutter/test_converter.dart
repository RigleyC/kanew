import 'package:appflowy_editor/appflowy_editor.dart';
import 'lib/core/widgets/rich_text_editor/converters/appflowy_document_converter.dart';

void main() {
  final converter = AppFlowyDocumentConverter();
  
  print('=== Teste 1: String vazia ===');
  final empty = converter.normalize('');
  print('Result: $empty\n');
  
  print('=== Teste 2: Texto simples ===');
  final simple = converter.normalize('Este é um texto simples');
  print('Result: $simple\n');
  
  print('=== Teste 3: Múltiplas linhas ===');
  final multiline = converter.normalize('Linha 1\nLinha 2\nLinha 3');
  print('Result: $multiline\n');
}
