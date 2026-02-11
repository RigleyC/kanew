#!/usr/bin/env dart

import 'dart:io';

void main() async {
  print('🔧 Fixing test file...\n');
  
  final file = File('test/features/workspace/presentation/members_page_controller_test.dart');
  String content = await file.readAsString();
  final original = content;
  
  // Mock MemberRepository methods - int → UuidValue
  content = content.replaceAll(
    'Future<Either<Failure, List<MemberWithUser>>> Function(int workspaceId)',
    'Future<Either<Failure, List<MemberWithUser>>> Function(UuidValue workspaceId)',
  );
  
  content = content.replaceAll(
    'Future<Either<Failure, void>> Function(int memberId)',
    'Future<Either<Failure, void>> Function(UuidValue memberId)',
  );
  
  content = content.replaceAll(
    'Future<Either<Failure, WorkspaceMember>> Function(int memberId, MemberRole newRole)',
    'Future<Either<Failure, WorkspaceMember>> Function(UuidValue memberId, MemberRole newRole)',
  );
  
  content = content.replaceAll(
    'Future<Either<Failure, List<PermissionInfo>>> Function(int memberId)',
    'Future<Either<Failure, List<PermissionInfo>>> Function(UuidValue memberId)',
  );
  
  content = content.replaceAll(
    'Future<Either<Failure, void>> Function(int memberId, List<int> permissionIds)',
    'Future<Either<Failure, void>> Function(UuidValue memberId, List<UuidValue> permissionIds)',
  );
  
  content = content.replaceAll(
    'Future<Either<Failure, void>> Function(int workspaceId, int newOwnerId)',
    'Future<Either<Failure, void>> Function(UuidValue workspaceId, UuidValue newOwnerId)',
  );
  
  content = content.replaceAll(
    'Future<Either<Failure, WorkspaceInvite>> Function(int workspaceId, List<int> permissionIds, {String? email})',
    'Future<Either<Failure, WorkspaceInvite>> Function(UuidValue workspaceId, List<UuidValue> permissionIds, {String? email})',
  );
  
  content = content.replaceAll(
    'Future<Either<Failure, List<WorkspaceInvite>>> Function(int workspaceId)',
    'Future<Either<Failure, List<WorkspaceInvite>>> Function(UuidValue workspaceId)',
  );
  
  content = content.replaceAll(
    'Future<Either<Failure, void>> Function(int inviteId)',
    'Future<Either<Failure, void>> Function(UuidValue inviteId)',
  );
  
  // Mock WorkspaceRepository methods
  content = content.replaceAll(
    'Future<Workspace> Function(int workspaceId, String name, {String? slug})',
    'Future<Workspace> Function(UuidValue workspaceId, String name, {String? slug})',
  );
  
  content = content.replaceAll(
    'Future<void> Function(int workspaceId)',
    'Future<void> Function(UuidValue workspaceId)',
  );
  
  // Usage in tests - test data
  content = content.replaceAll(
    RegExp(r', permissionIds: \[\d+(, \d+)*\]\)'),
    ', permissionIds: [UuidValue.fromString(\'00000000-0000-0000-0000-000000000001\')])',
  );
  
  content = content.replaceAll(
    RegExp(r'getMembers\(\d+\)'),
    'getMembers(UuidValue.fromString(\'00000000-0000-0000-0000-000000000001\'))',
  );
  
  if (content != original) {
    await file.writeAsString(content);
    print('✅ Fixed test file');
  }
  
  print('\nDone!');
}
