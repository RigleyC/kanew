import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_invite_by_code_usecase.dart';
import '../../domain/usecases/accept_invite_usecase.dart';
import '../states/invite_state.dart';
import '../stores/invite_store.dart';

/// Controller for accepting invites following AGENTS.md pattern
class AcceptInviteController extends ChangeNotifier {
  final GetInviteByCodeUseCase _getInviteByCodeUseCase;
  final AcceptInviteUseCase _acceptInviteUseCase;
  final InviteStore _store;

  AcceptInviteController({
    required GetInviteByCodeUseCase getInviteByCodeUseCase,
    required AcceptInviteUseCase acceptInviteUseCase,
    required InviteStore store,
  })  : _getInviteByCodeUseCase = getInviteByCodeUseCase,
        _acceptInviteUseCase = acceptInviteUseCase,
        _store = store;

  InviteStore get store => _store;
  InviteState get state => _store.value;

  /// Validates an invite by its code
  Future<void> validateInvite(String code) async {
    developer.log(
      '[AcceptInviteController] validateInvite starting',
      name: 'accept_invite',
    );
    
    _store.value = const InviteValidating();

    final result = await _getInviteByCodeUseCase(code);

    result.fold(
      (failure) {
        developer.log(
          '[AcceptInviteController] validateInvite failed: ${failure.message}',
          name: 'accept_invite',
        );
        _store.value = InviteError(failure.message);
      },
      (inviteDetails) {
        developer.log(
          '[AcceptInviteController] validateInvite success: inviteDetails=${inviteDetails?.workspaceName}',
          name: 'accept_invite',
        );
        if (inviteDetails == null) {
          _store.value = const InviteError('Convite não encontrado ou já foi utilizado.');
        } else {
          _store.value = InviteValidated(inviteDetails);
        }
      },
    );
  }

  /// Accepts an invite
  Future<void> acceptInvite(String code) async {
    developer.log(
      '[AcceptInviteController] acceptInvite called',
      name: 'accept_invite',
    );

    _store.value = const InviteAccepting();

    final result = await _acceptInviteUseCase(code);

    result.fold(
      (failure) {
        developer.log(
          '[AcceptInviteController] acceptInvite failed: ${failure.message}',
          name: 'accept_invite',
        );
        _store.value = InviteError(failure.message);
      },
      (acceptResult) {
        developer.log(
          '[AcceptInviteController] acceptInvite success! workspaceSlug: ${acceptResult.workspaceSlug}',
          name: 'accept_invite',
        );
        _store.value = InviteAccepted(acceptResult);
      },
    );
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }
}
