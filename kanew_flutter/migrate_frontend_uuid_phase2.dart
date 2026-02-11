#!/usr/bin/env dart

import 'dart:io';

/// Frontend UUID Migration Script - Phase 2
/// Fixes remaining int -> UuidValue type mismatches

void main() async {
  print('🚀 Starting Frontend UUID Migration Phase 2...\n');
  
  // Find all dart files in lib/
  final libDir = Directory('lib');
  final dartFiles = <String>[];
  
  await for (final entity in libDir.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      dartFiles.add(entity.path.replaceAll('\\', '/'));
    }
  }
  
  print('Found ${dartFiles.length} dart files to process\n');
  
  for (final filePath in dartFiles) {
    await processFile(filePath);
  }
  
  print('\n✅ Phase 2 migration completed!');
  print('\n📋 Next steps:');
  print('1. Run: flutter analyze');
  print('2. Fix any remaining errors manually');
}

Future<void> processFile(String filePath) async {
  final file = File(filePath);
  String content = await file.readAsString();
  final originalContent = content;
  
  // Pattern 1: Getter return type - int? get xyz => ... should be UuidValue? get xyz
  content = content.replaceAllMapped(
    RegExp(r'\bint\?\s+get\s+(workspaceId|boardId|cardId|listId|memberId)\s*=>', multiLine: true),
    (match) => 'UuidValue? get ${match.group(1)} =>',
  );
  
  // Pattern 2: Set<int> to Set<UuidValue>
  content = content.replaceAll(RegExp(r'\bSet<int>\b'), 'Set<UuidValue>');
  
  // Pattern 3: List<int> to List<UuidValue> (more aggressive)
  content = content.replaceAll(RegExp(r'\bList<int>\b'), 'List<UuidValue>');
  
  // Pattern 4: Return type mismatches - int get xyz() => field (where field is UuidValue)
  content = content.replaceAllMapped(
    RegExp(r'\bint\s+get\s+(workspaceId|boardId|cardId|listId)\s*=>', multiLine: true),
    (match) => 'UuidValue get ${match.group(1)} =>',
  );
  
  // Pattern 5: Function callbacks - void Function(int, ...) to void Function(UuidValue, ...)
  content = content.replaceAll(
    RegExp(r'void Function\(int,'),
    'void Function(UuidValue,',
  );
  content = content.replaceAll(
    RegExp(r'void Function\(int\)'),
    'void Function(UuidValue)',
  );
  
  // Pattern 6: Future<void> Function(int, ...) to Future<void> Function(UuidValue, ...)
  content = content.replaceAll(
    RegExp(r'Future<void> Function\(int,'),
    'Future<void> Function(UuidValue,',
  );
  content = content.replaceAll(
    RegExp(r'Future<void> Function\(int\)'),
    'Future<void> Function(UuidValue)',
  );
  
  // Pattern 7: Variable declarations with specific ID names
  content = content.replaceAllMapped(
    RegExp(r'\bint\s+(newOwnerId)\b'),
    (match) => 'UuidValue ${match.group(1)}',
  );
  
  // Pattern 8: Function parameter types in lambdas/callbacks
  content = content.replaceAllMapped(
    RegExp(r'\(\s*int\s+(labelId|checklistId|itemId|commentId|attachmentId)\s*\)'),
    (match) => '(UuidValue ${match.group(1)})',
  );
  
  // Pattern 9: Map/Set literal conversions - .map((x) => int.parse(x))
  // This is risky, so we skip it
  
  if (content != originalContent) {
    await file.writeAsString(content);
    print('✅ Updated: $filePath');
  }
}
