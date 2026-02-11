#!/usr/bin/env dart

import 'dart:io';

/// Frontend UUID Migration Script - Phase 3
/// Fixes widget properties, local variables, and callbacks

void main() async {
  print('🚀 Starting Frontend UUID Migration Phase 3...\n');
  
  // Target specific files with many errors
  final targetFiles = [
    'lib/features/workspace/pages/members_page.dart',
    'lib/features/board/presentation/pages/card_detail_page.dart',
    'lib/features/board/presentation/pages/board_view_page.dart',
    'lib/features/board/presentation/controllers/board_view_controller.dart',
    'lib/features/board/presentation/controllers/card_detail_controller.dart',
    'lib/features/board/presentation/components/card_detail_sidebar.dart',
    'lib/features/board/presentation/store/board_store.dart',
    'lib/features/board/presentation/store/board_filter_store.dart',
    'lib/features/board/presentation/utils/board_data_adapter.dart',
    'lib/features/board/presentation/widgets/checklist/checklist_section.dart',
    'lib/features/board/presentation/widgets/checklist/checklist_card.dart',
    'lib/features/board/presentation/widgets/kanban_board.dart',
    'lib/features/board/data/board_stream_service.dart',
    'lib/features/board/data/card_repository.dart',
    'lib/core/widgets/member/permission_matrix.dart',
    'lib/core/widgets/sidebar_menu/list_sidebar_menu.dart',
    'lib/core/dialogs/members/pending_invites_list.dart',
    'lib/features/workspace/presentation/widgets/members/pending_invites_list.dart',
  ];
  
  for (final filePath in targetFiles) {
    await processFile(filePath);
  }
  
  print('\n✅ Phase 3 migration completed!');
  print('\n📋 Next steps:');
  print('1. Run: flutter analyze');
  print('2. Fix remaining errors manually');
}

Future<void> processFile(String filePath) async {
  final file = File(filePath);
  
  if (!await file.exists()) {
    print('⚠️  Skipping $filePath (not found)');
    return;
  }
  
  String content = await file.readAsString();
  final originalContent = content;
  
  // Pattern 1: Local variable declarations
  content = content.replaceAllMapped(
    RegExp(r'\bfinal int\?? (workspaceId|boardId|cardId|listId|labelId|memberId|checklistId|itemId|inviteId)\b'),
    (match) => 'final ${match.group(0)!.contains('?') ? 'UuidValue?' : 'UuidValue'} ${match.group(1)}',
  );
  
  content = content.replaceAllMapped(
    RegExp(r'\bvar (workspaceId|boardId|cardId|listId|labelId|memberId|checklistId|itemId|inviteId) = \d+'),
    (match) => 'UuidValue ${match.group(1)} = ${match.group(0)!.split(' = ')[1]}',
  );
  
  // Pattern 2: Method/function parameter in anonymous functions
  content = content.replaceAllMapped(
    RegExp(r'\(\s*int\s+(workspaceId|boardId|cardId|listId|labelId|memberId|checklistId|itemId|inviteId)\s*\)\s*(=>|{)'),
    (match) => '(UuidValue ${match.group(1)}) ${match.group(2)}',
  );
  
  // Pattern 3: Class field declarations
  content = content.replaceAllMapped(
    RegExp(r'^\s*(?:final|late)\s+int\??\s+(workspaceId|boardId|cardId|listId|labelId|memberId);', multiLine: true),
    (match) {
      final isNullable = match.group(0)!.contains('int?');
      final modifier = match.group(0)!.trim().split(' ')[0]; // 'final' or 'late'
      return '  $modifier ${isNullable ? 'UuidValue?' : 'UuidValue'} ${match.group(1)};';
    },
  );
  
  // Pattern 4: Widget constructor parameters (final int workspaceId in constructor)
  content = content.replaceAllMapped(
    RegExp(r'required int\?? (workspaceId|boardId|cardId|listId|labelId|memberId|checklistId|itemId)\b'),
    (match) {
      final isNullable = match.group(0)!.contains('int?');
      return 'required ${isNullable ? 'UuidValue?' : 'UuidValue'} ${match.group(1)}';
    },
  );
  
  // Pattern 5: Named parameters in function signatures
  content = content.replaceAllMapped(
    RegExp(r'{[^}]*int\?? (workspaceId|boardId|cardId|listId)[^}]*}'),
    (match) {
      return match.group(0)!.replaceAll('int ', 'UuidValue ').replaceAll('int?', 'UuidValue?');
    },
  );
  
  // Pattern 6: Return type for methods returning IDs
  content = content.replaceAllMapped(
    RegExp(r'\bint\?? get _current(List|Board|Card)Id\b'),
    (match) {
      final isNullable = match.group(0)!.contains('int?');
      return '${isNullable ? 'UuidValue?' : 'UuidValue'} get _current${match.group(1)}Id';
    },
  );
  
  // Pattern 7: Map/Set type parameters
  content = content.replaceAll(RegExp(r'Map<int,'), 'Map<UuidValue,');
  content = content.replaceAll(RegExp(r'Map<([^,]+), int>'), 'Map<\$1, UuidValue>');
  
  // Pattern 8: .uuid references (Card now has id directly, not uuid)
  content = content.replaceAll(RegExp(r'\.uuid(?!\w)'), '.id');
  
  // Pattern 9: Permission IDs in collections
  content = content.replaceAllMapped(
    RegExp(r'(selectedPermissions|permissionIds|initialPermissions)\s*=\s*{'),
    (match) => '${match.group(1)} = <UuidValue>{',
  );
  
  content = content.replaceAllMapped(
    RegExp(r'(selectedPermissions|permissionIds|initialPermissions)\s*=\s*\[\]'),
    (match) => '${match.group(1)} = <UuidValue>[]',
  );
  
  if (content != originalContent) {
    await file.writeAsString(content);
    print('✅ Updated: $filePath');
  } else {
    print('ℹ️  No changes: $filePath');
  }
}
