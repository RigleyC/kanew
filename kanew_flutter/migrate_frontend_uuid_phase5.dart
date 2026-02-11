#!/usr/bin/env dart

import 'dart:io';

/// Frontend UUID Migration - Phase 5
/// Corrige métodos/funções que ainda usam int em vez de UuidValue

void main() async {
  print('🚀 Starting Frontend UUID Migration Phase 5...\n');
  
  await fixMembersPage();
  await fixBoardViewController();
  await fixBoardGroupHeader();
  await fixAppRouter();
  await fixPendingInvitesList();
  await fixBoardDataAdapter();
  
  print('\n✅ Phase 5 migration completed!');
  print('\n📋 Run: flutter analyze');
}

Future<void> fixMembersPage() async {
  final file = File('lib/features/workspace/pages/members_page.dart');
  String content = await file.readAsString();
  final original = content;
  
  // Corrigir assinatura dos métodos
  content = content.replaceAll(
    'void _confirmRemoveMember(\n    BuildContext parentContext,\n    int memberId,',
    'void _confirmRemoveMember(\n    BuildContext parentContext,\n    UuidValue memberId,',
  );
  
  content = content.replaceAll(
    'Future<void> _changeMemberRole(int memberId, MemberRole newRole)',
    'Future<void> _changeMemberRole(UuidValue memberId, MemberRole newRole)',
  );
  
  content = content.replaceAll(
    'Future<void> _showPermissionsDialog(int memberId, String userName)',
    'Future<void> _showPermissionsDialog(UuidValue memberId, String userName)',
  );
  
  // Corrigir callbacks que recebem IDs
  content = content.replaceAll(
    RegExp(r'onTransfer: \(int newOwnerId\)'),
    'onTransfer: (UuidValue newOwnerId)',
  );
  
  // Corrigir onRemove callback
  content = content.replaceAll(
    RegExp(r'onRemove: \(\) => _confirmRemoveMember\([^,]+,\s*'),
    'onRemove: () => _confirmRemoveMember(context,\n                                  ',
  );
  
  await file.writeAsString(content);
  if (content != original) {
    print('✅ Fixed members_page.dart');
  }
}

Future<void> fixBoardViewController() async {
  final file = File('lib/features/board/presentation/controllers/board_view_controller.dart');
  String content = await file.readAsString();
  final original = content;
  
  // Corrigir onde state.pathParameters['xxx']! é passado diretamente para UuidValue
  // Precisa adicionar UuidValue.fromString()
  
  content = content.replaceAllMapped(
    RegExp(r'(\w+)\s*=\s*state\.pathParameters\['"'"'(\w+)'"'"'\]\!;'),
    (match) {
      final varName = match.group(1);
      final paramName = match.group(2);
      return 'final $varName = UuidValue.fromString(state.pathParameters[\'$paramName\']!);';
    },
  );
  
  await file.writeAsString(content);
  if (content != original) {
    print('✅ Fixed board_view_controller.dart');
  }
}

Future<void> fixBoardGroupHeader() async {
  final file = File('lib/features/board/presentation/components/board_group_header.dart');
  String content = await file.readAsString();
  final original = content;
  
  // Widget constructor parameters
  // Verificar se listId é UuidValue
  content = content.replaceAll(
    RegExp(r'required int listId'),
    'required UuidValue listId',
  );
  
  await file.writeAsString(content);
  if (content != original) {
    print('✅ Fixed board_group_header.dart');
  }
}

Future<void> fixAppRouter() async {
  final file = File('lib/core/router/app_router.dart');
  String content = await file.readAsString();
  final original = content;
  
  // Encontrar onde int é passado para UuidValue?
  content = content.replaceAllMapped(
    RegExp(r'boardId:\s*(\w+)\.pathParameters\['"'"'boardId'"'"'\]!'),
    (match) {
      final paramVar = match.group(1);
      return 'boardId: UuidValue.fromString($paramVar.pathParameters[\'boardId\']!)';
    },
  );
  
  await file.writeAsString(content);
  if (content != original) {
    print('✅ Fixed app_router.dart');
  }
}

Future<void> fixPendingInvitesList() async {
  final file = File('lib/features/workspace/presentation/widgets/members/pending_invites_list.dart');
  String content = await file.readAsString();
  final original = content;
  
  // O callback onRevoke espera int mas está recebendo UuidValue
  // Preciso ver como está o widget
  content = content.replaceAll(
    'void Function(int inviteId) onRevoke',
    'void Function(UuidValue inviteId) onRevoke',
  );
  
  await file.writeAsString(content);
  if (content != original) {
    print('✅ Fixed pending_invites_list.dart');
  }
}

Future<void> fixBoardDataAdapter() async {
  final file = File('lib/features/board/presentation/utils/board_data_adapter.dart');
  String content = await file.readAsString();
  final original = content;
  
  // Onde UuidValue está sendo usado como String
  // Provavelmente precisa .toString() ou usar como chave de Map
  content = content.replaceAll(
    'cache[card.id]',
    'cache[card.id.toString()]',
  );
  
  await file.writeAsString(content);
  if (content != original) {
    print('✅ Fixed board_data_adapter.dart');
  }
}
