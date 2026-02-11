#!/usr/bin/env dart

import 'dart:io';

/// Frontend UUID Migration Script
/// Converts frontend repositories, controllers, and pages from int to UuidValue

void main() async {
  print('🚀 Starting Frontend UUID Migration...\n');
  
  // Repository files (actual structure)
  final repositoryFiles = [
    'lib/features/auth/data/auth_repository.dart',
    'lib/features/workspace/data/workspace_repository.dart',
    'lib/features/workspace/domain/repositories/member_repository.dart',
    'lib/features/workspace/data/repositories/member_repository_impl.dart',
    'lib/features/board/data/board_repository.dart',
    'lib/features/board/data/card_repository.dart',
    'lib/features/board/data/list_repository.dart',
    'lib/features/board/data/label_repository.dart',
    'lib/features/board/data/activity_repository.dart',
    'lib/features/board/data/attachment_repository.dart',
    'lib/features/board/data/checklist_repository.dart',
    'lib/features/board/data/comment_repository.dart',
  ];
  
  // Controller and ViewModel files
  final controllerFiles = [
    'lib/features/auth/viewmodel/auth_controller.dart',
    'lib/features/workspace/viewmodel/workspace_controller.dart',
    'lib/features/workspace/presentation/controllers/members_page_controller.dart',
    'lib/features/board/presentation/controllers/boards_page_controller.dart',
    'lib/features/board/presentation/controllers/board_view_controller.dart',
    'lib/features/board/presentation/controllers/card_detail_controller.dart',
  ];
  
  final allFiles = [...repositoryFiles, ...controllerFiles];
  
  for (final filePath in allFiles) {
    await processFile(filePath);
  }
  
  print('\n✅ Frontend migration completed!');
  print('\n📋 Next steps:');
  print('1. Run: flutter pub get');
  print('2. Run: flutter analyze');
  print('3. Fix any remaining type errors manually');
}

Future<void> processFile(String filePath) async {
  final file = File(filePath);
  
  if (!await file.exists()) {
    print('⚠️  Skipping $filePath (not found)');
    return;
  }
  
  print('📝 Processing: $filePath');
  
  String content = await file.readAsString();
  int changeCount = 0;
  
  // Pattern 1: Method parameters - int workspaceId -> UuidValue workspaceId
  final intParamPatterns = [
    RegExp(r'\bint\s+workspaceId\b'),
    RegExp(r'\bint\s+boardId\b'),
    RegExp(r'\bint\s+cardId\b'),
    RegExp(r'\bint\s+listId\b'),
    RegExp(r'\bint\s+memberId\b'),
    RegExp(r'\bint\s+inviteId\b'),
    RegExp(r'\bint\s+labelId\b'),
    RegExp(r'\bint\s+checklistId\b'),
    RegExp(r'\bint\s+itemId\b'),
    RegExp(r'\bint\s+commentId\b'),
    RegExp(r'\bint\s+attachmentId\b'),
    RegExp(r'\bint\s+activityId\b'),
    RegExp(r'\bint\s+newOwnerId\b'),
  ];
  
  for (final pattern in intParamPatterns) {
    if (pattern.hasMatch(content)) {
      final oldName = pattern.pattern.replaceAll(r'\b', '').replaceAll(r'\s+', ' ');
      final newName = oldName.replaceAll('int ', 'UuidValue ');
      content = content.replaceAll(pattern, newName);
      changeCount++;
    }
  }
  
  // Pattern 2: Nullable int parameters
  final nullableIntParams = [
    RegExp(r'\bint\?\s+workspaceId\b'),
    RegExp(r'\bint\?\s+boardId\b'),
    RegExp(r'\bint\?\s+listId\b'),
    RegExp(r'\bint\?\s+cardId\b'),
  ];
  
  for (final pattern in nullableIntParams) {
    if (pattern.hasMatch(content)) {
      content = content.replaceAllMapped(pattern, (match) => match.group(0)!.replaceAll('int?', 'UuidValue?'));
      changeCount++;
    }
  }
  
  // Pattern 3: List<int> to List<UuidValue>
  final listIntPatterns = [
    RegExp(r'List<int>\s+\w*[Ii]ds'),
    RegExp(r'List<int>>'),  // For nested generics
  ];
  
  for (final pattern in listIntPatterns) {
    if (pattern.hasMatch(content)) {
      content = content.replaceAll('List<int>', 'List<UuidValue>');
      changeCount++;
      break; // Only count once
    }
  }
  
  // Pattern 4: Private int fields
  final privateFieldPatterns = [
    RegExp(r'int\? _workspaceId'),
    RegExp(r'int\? _boardId'),
    RegExp(r'int\? _cardId'),
    RegExp(r'int\? _listId'),
  ];
  
  for (final pattern in privateFieldPatterns) {
    if (pattern.hasMatch(content)) {
      content = content.replaceAllMapped(pattern, (match) => match.group(0)!.replaceAll('int?', 'UuidValue?'));
      changeCount++;
    }
  }
  
  if (changeCount > 0) {
    await file.writeAsString(content);
    print('  ✅ Applied $changeCount pattern replacements\n');
  } else {
    print('  ℹ️  No changes needed\n');
  }
}
