#!/usr/bin/env dart

import 'dart:io';

/// Migration script to help convert int IDs to UuidValue across the codebase
/// Run with: dart run migrate_to_uuid.dart

void main() async {
  print('🚀 Starting UUID Migration Helper...\n');
  
  // Files to process
  final endpointFiles = [
    'lib/src/endpoints/workspace_endpoint.dart',
    'lib/src/endpoints/board_endpoint.dart',
    'lib/src/endpoints/card_endpoint.dart',
    'lib/src/endpoints/card_list_endpoint.dart',
    'lib/src/endpoints/invite_endpoint.dart',
    'lib/src/endpoints/activity_endpoint.dart',
    'lib/src/endpoints/attachment_endpoint.dart',
    'lib/src/endpoints/checklist_endpoint.dart',
    'lib/src/endpoints/comment_endpoint.dart',
    'lib/src/endpoints/label_endpoint.dart',
    'lib/src/endpoints/board_stream_endpoint.dart',
  ];
  
  final serviceFiles = [
    'lib/src/services/workspace_service.dart',
    'lib/src/services/user_registration_service.dart',
    'lib/src/services/activity_service.dart',
    'lib/src/services/board_broadcast_service.dart',
  ];
  
  final allFiles = [...endpointFiles, ...serviceFiles];
  
  for (final filePath in allFiles) {
    await processFile(filePath);
  }
  
  print('\n✅ Migration helper completed!');
  print('\n📋 Next steps:');
  print('1. Review the changes made by this script');
  print('2. Run: serverpod generate');
  print('3. Fix any remaining type errors manually');
  print('4. Test compilation with: dart analyze');
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
  
  // Pattern 1: Remove uuid field from model creation
  final uuidPattern = RegExp(r'\s*uuid:\s*const\s+Uuid\(\)\.v4obj\(\),?\s*\n', multiLine: true);
  if (uuidPattern.hasMatch(content)) {
    content = content.replaceAll(uuidPattern, '');
    changeCount++;
    print('  ✓ Removed uuid: const Uuid().v4obj() statements');
  }
  
  // Pattern 2: Update method parameters - int workspaceId -> UuidValue workspaceId
  final intParamPatterns = [
    RegExp(r'\bint\s+workspaceId\b'),
    RegExp(r'\bint\s+boardId\b'),
    RegExp(r'\bint\s+cardId\b'),
    RegExp(r'\bint\s+listId\b'),
    RegExp(r'\bint\s+memberId\b'),
    RegExp(r'\bint\s+workspaceMemberId\b'),
    RegExp(r'\bint\s+permissionId\b'),
    RegExp(r'\bint\s+labelDefId\b'),
    RegExp(r'\bint\s+checklistId\b'),
    RegExp(r'\bint\s+commentId\b'),
    RegExp(r'\bint\s+attachmentId\b'),
    RegExp(r'\bint\s+activityId\b'),
  ];
  
  for (final pattern in intParamPatterns) {
    if (pattern.hasMatch(content)) {
      final oldName = pattern.pattern.replaceAll(r'\b', '').replaceAll(r'\s+', ' ');
      final newName = oldName.replaceAll('int ', 'UuidValue ');
      content = content.replaceAll(pattern, newName);
      changeCount++;
    }
  }
  
  // Pattern 3: Update List<int> to List<UuidValue>
  final listIntPatterns = [
    RegExp(r'List<int>\s+grantedPermissionIds'),
    RegExp(r'List<int>\s+permissionIds'),
    RegExp(r'List<int>\s+orderedListIds'),
    RegExp(r'List<int>\s+cardIds'),
  ];
  
  for (final pattern in listIntPatterns) {
    if (pattern.hasMatch(content)) {
      content = content.replaceAllMapped(pattern, (match) => match.group(0)!.replaceAll('List<int>', 'List<UuidValue>'));
      changeCount++;
    }
  }
  
  // Pattern 4: Update nullable int parameters - int? -> UuidValue?
  final nullableIntParams = [
    RegExp(r'\bint\?\s+scopeBoardId\b'),
    RegExp(r'\bint\?\s+parentId\b'),
  ];
  
  for (final pattern in nullableIntParams) {
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
