#!/usr/bin/env dart

import 'dart:io';

/// Frontend UUID Migration - Phase 4
/// Fixa conversões String ↔ UuidValue e últimos conflitos int → UuidValue

void main() async {
  print('🚀 Starting Frontend UUID Migration Phase 4...\n');
  
  // Arquivos que precisam de conversão String → UuidValue
  final routeParamFiles = [
    'lib/core/router/app_router.dart',
    'lib/features/board/presentation/controllers/board_view_controller.dart',
    'lib/features/board/presentation/components/board_group_header.dart',
    'lib/features/workspace/presentation/controllers/members_page_controller.dart',
  ];
  
  // Arquivos com conversões UuidValue → String (display)
  final displayFiles = [
    'lib/features/board/presentation/utils/board_data_adapter.dart',
  ];
  
  // Arquivos com estado local Set<int> → Set<UuidValue>
  final stateFiles = [
    'lib/features/workspace/pages/members_page.dart',
    'lib/features/workspace/presentation/widgets/members/invite_dialog.dart',
    'lib/core/widgets/member/permission_matrix.dart',
  ];
  
  for (final filePath in routeParamFiles) {
    await fixRouteParams(filePath);
  }
  
  for (final filePath in displayFiles) {
    await fixDisplayConversions(filePath);
  }
  
  for (final filePath in stateFiles) {
    await fixStateCollections(filePath);
  }
  
  // Corrigir arquivos com callbacks int → UuidValue
  await fixCallbacks('lib/features/workspace/pages/members_page.dart');
  
  print('\n✅ Phase 4 migration completed!');
  print('\n📋 Run: flutter analyze');
}

Future<void> fixRouteParams(String filePath) async {
  final file = File(filePath);
  if (!await file.exists()) return;
  
  String content = await file.readAsString();
  final original = content;
  
  // Pattern 1: state.pathParameters['boardId'] → state.pathParameters['boardId']! (adicionar ! para non-null)
  content = content.replaceAll("state.pathParameters['boardId']", "state.pathParameters['boardId']!");
  content = content.replaceAll("state.pathParameters['workspaceId']", "state.pathParameters['workspaceId']!");
  content = content.replaceAll("state.pathParameters['cardId']", "state.pathParameters['cardId']!");
  
  // Pattern 2: Adicionar UuidValue.fromString() para parâmetros de rota
  // Captura: controller.load(..., state.pathParameters['boardId']!)
  // Transforma: controller.load(..., UuidValue.fromString(state.pathParameters['boardId']!))
  content = content.replaceAllMapped(
    RegExp(r'controller\.load\([^)]*state\.pathParameters\['),
    (m) {
      final matchStr = m.group(0) ?? '';
      return matchStr.replaceAll('controller.load(', 'controller.load(');
    },
  );
  
  // Pattern mais específico: Encontrar onde state.pathParameters['xxx'] é passado para UuidValue?
  final pathParamPatterns = [
    'boardId',
    'workspaceId', 
    'cardId',
    'listId',
    'memberId',
    'labelId',
  ];
  
  for (final param in pathParamPatterns) {
    // Substituir String crua para UuidValue
    content = content.replaceAllMapped(
      RegExp(r'UuidValue\? $param = state\.pathParameters\['"'"'$param'"'"'\]!'),
      (match) => 'UuidValue? $param = UuidValue.fromString(state.pathParameters[\'$param\']!)',
    );
  }
  
  // Pattern: parâmetros de rotas go_router
  // De: final boardId = state.pathParameters['boardId']!
  // Para: final boardId = UuidValue.fromString(state.pathParameters['boardId']!)
  content = content.replaceAllMapped(
    RegExp(r'final (boardId|workspaceId|cardId|listId|memberId|inviteId) = state\.pathParameters\['"'"'(boardId|workspaceId|cardId|listId|memberId|inviteId)'"'"'\]!;'),
    (match) {
      final varName = match.group(1);
      return 'final $varName = UuidValue.fromString(state.pathParameters[\'$varName\']!);';
    },
  );
  
  // Pattern: parâmetros opcionais de rotas
  content = content.replaceAllMapped(
    RegExp(r'UuidValue\? (boardId|workspaceId|cardId)\? ='),
    (match) => 'UuidValue? ${match.group(1)} =',
  );
  
  if (content != original) {
    await file.writeAsString(content);
    print('✅ Fixed route params: $filePath');
  }
}

Future<void> fixDisplayConversions(String filePath) async {
  final file = File(filePath);
  if (!await file.exists()) return;
  
  String content = await file.readAsString();
  final original = content;
  
  // Pattern: UuidValue.toString() para exibir
  // Alguns lugares usam .toString() que é redundante, outros precisam de String()
  
  // Encontrar: .toString() em UuidValue (redundante mas não causa erro)
  // O problema é quando precisamos String e temos UuidValue
  
  // Pattern: children.map((x) => int.parse(x.id.toString())) 
  // Isso é porque children eram ints, agora são UuidValue
  // Precisamos: children.map((x) => x.id)
  content = content.replaceAll(
    RegExp(r'\.map\(\(x\) => int\.parse\(x\.id\.toString\(\)\)\)'),
    '.map((x) => x.id)',
  );
  
  // Pattern: onde precisamos String de UuidValue para chave de Map
  // map[xxx.toString()] ou map[uuid.toString()]
  content = content.replaceAllMapped(
    RegExp(r'(map|cache|items)\[(\w+)\.toString\(\)\]'),
    (match) => '${match.group(1)}[${match.group(2)}]',
  );
  
  if (content != original) {
    await file.writeAsString(content);
    print('✅ Fixed display conversions: $filePath');
  }
}

Future<void> fixStateCollections(String filePath) async {
  final file = File(filePath);
  if (!await file.exists()) return;
  
  String content = await file.readAsString();
  final original = content;
  
  // Pattern 1: Set<int> → Set<UuidValue>
  content = content.replaceAll('Set<int> ', 'Set<UuidValue> ');
  content = content.replaceAll('Set<int>', 'Set<UuidValue>');
  
  // Pattern 2: List<int> → List<UuidValue>
  content = content.replaceAll('List<int> ', 'List<UuidValue> ');
  content = content.replaceAll('List<int>', 'List<UuidValue>');
  
  // Pattern 3: Inicialização vazia {}
  content = content.replaceAllMapped(
    RegExp(r'(selectedPermissions|permissionIds|selectedIds|initialPermissions) = \{'),
    (match) => '${match.group(1)} = <UuidValue>{',
  );
  
  // Pattern 4: Adicionar tipo para coleção vazia
  content = content.replaceAllMapped(
    RegExp(r'(selectedPermissions|permissionIds) = \[\]'),
    (match) => '${match.group(1)} = <UuidValue>[]',
  );
  
  if (content != original) {
    await file.writeAsString(content);
    print('✅ Fixed state collections: $filePath');
  }
}

Future<void> fixCallbacks(String filePath) async {
  final file = File(filePath);
  if (!await file.exists()) return;
  
  String content = await file.readAsString();
  final original = content;
  
  // Pattern: void Function(int, ...) → void Function(UuidValue, ...)
  content = content.replaceAll('void Function(int, ', 'void Function(UuidValue, ');
  content = content.replaceAll('void Function(int)', 'void Function(UuidValue)');
  
  // Future<void> Function(int, ...)
  content = content.replaceAll('Future<void> Function(int, ', 'Future<void> Function(UuidValue, ');
  content = content.replaceAll('Future<void> Function(int)', 'Future<void> Function(UuidValue)');
  
  // void Function(int, int, ...)
  content = content.replaceAll('void Function(int, int, ', 'void Function(UuidValue, UuidValue, ');
  content = content.replaceAll('void Function(int, int)', 'void Function(UuidValue, UuidValue)');
  
  if (content != original) {
    await file.writeAsString(content);
    print('✅ Fixed callbacks: $filePath');
  }
}
