import 'package:get_it/get_it.dart';

import 'domain/usecases/get_members_usecase.dart';
import 'domain/usecases/remove_member_usecase.dart';
import 'domain/usecases/update_member_role_usecase.dart';
import 'domain/usecases/get_member_permissions_usecase.dart';
import 'domain/usecases/update_member_permissions_usecase.dart';
import 'domain/usecases/transfer_ownership_usecase.dart';
import 'domain/usecases/create_invite_usecase.dart';
import 'domain/usecases/get_invites_usecase.dart';
import 'domain/usecases/revoke_invite_usecase.dart';
import 'domain/usecases/get_invite_by_code_usecase.dart';
import 'domain/usecases/accept_invite_usecase.dart';
import 'domain/usecases/get_all_permissions_usecase.dart';
import 'presentation/stores/members_store.dart';
import 'presentation/stores/invite_store.dart';
import 'presentation/controllers/members_controller.dart';
import 'presentation/controllers/accept_invite_controller.dart';

/// Dependency injection for Member feature
class MemberInjector {
  final GetIt _getIt = GetIt.instance;
  
  void register() {
    // UseCases
    _getIt.registerLazySingleton(() => GetMembersUseCase(repository: _getIt()));
    _getIt.registerLazySingleton(() => RemoveMemberUseCase(repository: _getIt()));
    _getIt.registerLazySingleton(() => UpdateMemberRoleUseCase(repository: _getIt()));
    _getIt.registerLazySingleton(() => GetMemberPermissionsUseCase(repository: _getIt()));
    _getIt.registerLazySingleton(() => UpdateMemberPermissionsUseCase(repository: _getIt()));
    _getIt.registerLazySingleton(() => TransferOwnershipUseCase(repository: _getIt()));
    _getIt.registerLazySingleton(() => CreateInviteUseCase(repository: _getIt()));
    _getIt.registerLazySingleton(() => GetInvitesUseCase(repository: _getIt()));
    _getIt.registerLazySingleton(() => RevokeInviteUseCase(repository: _getIt()));
    _getIt.registerLazySingleton(() => GetInviteByCodeUseCase(repository: _getIt()));
    _getIt.registerLazySingleton(() => AcceptInviteUseCase(repository: _getIt()));
    _getIt.registerLazySingleton(() => GetAllPermissionsUseCase(repository: _getIt()));
    
    // Stores
    _getIt.registerFactory(() => MembersStore());
    _getIt.registerFactory(() => InviteStore());
    
    // Controllers
    _getIt.registerFactory(() => MembersController(
      getMembersUseCase: _getIt(),
      removeMemberUseCase: _getIt(),
      updateMemberRoleUseCase: _getIt(),
      getMemberPermissionsUseCase: _getIt(),
      updateMemberPermissionsUseCase: _getIt(),
      transferOwnershipUseCase: _getIt(),
      createInviteUseCase: _getIt(),
      getInvitesUseCase: _getIt(),
      revokeInviteUseCase: _getIt(),
      getAllPermissionsUseCase: _getIt(),
      workspaceRepository: _getIt(),
      store: _getIt(),
    ));
    
    _getIt.registerFactory(() => AcceptInviteController(
      getInviteByCodeUseCase: _getIt(),
      acceptInviteUseCase: _getIt(),
      store: _getIt(),
    ));
  }
}
