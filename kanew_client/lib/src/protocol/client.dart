/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:kanew_client/src/protocol/card_activity.dart' as _i5;
import 'package:kanew_client/src/protocol/attachment.dart' as _i6;
import 'dart:typed_data' as _i7;
import 'package:kanew_client/src/protocol/board.dart' as _i8;
import 'package:kanew_client/src/protocol/card.dart' as _i9;
import 'package:kanew_client/src/protocol/card_detail.dart' as _i10;
import 'package:kanew_client/src/protocol/card_priority.dart' as _i11;
import 'package:kanew_client/src/protocol/board_with_cards.dart' as _i12;
import 'package:kanew_client/src/protocol/card_list.dart' as _i13;
import 'package:kanew_client/src/protocol/checklist.dart' as _i14;
import 'package:kanew_client/src/protocol/checklist_item.dart' as _i15;
import 'package:kanew_client/src/protocol/comment.dart' as _i16;
import 'package:kanew_client/src/protocol/workspace_invite.dart' as _i17;
import 'package:kanew_client/src/protocol/invite_details.dart' as _i18;
import 'package:kanew_client/src/protocol/accept_invite_result.dart' as _i19;
import 'package:kanew_client/src/protocol/label_def.dart' as _i20;
import 'package:kanew_client/src/protocol/member_with_user.dart' as _i21;
import 'package:kanew_client/src/protocol/workspace_member.dart' as _i22;
import 'package:kanew_client/src/protocol/member_role.dart' as _i23;
import 'package:kanew_client/src/protocol/permission_info.dart' as _i24;
import 'package:kanew_client/src/protocol/permission.dart' as _i25;
import 'package:kanew_client/src/protocol/workspace.dart' as _i26;
import 'package:kanew_client/src/protocol/greetings/greeting.dart' as _i27;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i28;
import 'protocol.dart' as _i29;

/// Extends EmailIdpBaseEndpoint to expose email auth endpoints.
///
/// All standard auth methods are inherited from EmailIdpBaseEndpoint:
/// - startRegistration(email) → Sends verification code
/// - verifyRegistrationCode(accountRequestId, code) → Returns registration token
/// - finishRegistration(registrationToken, password) → Creates user
/// - login(email, password) → Returns session token
/// - startPasswordReset(email) → Sends password reset code
/// - verifyPasswordResetCode(passwordResetRequestId, code) → Returns reset token
/// - finishPasswordReset(token, newPassword) → Resets password
///
/// The workspace creation hook is configured via `onAfterAccountCreated`
/// in server.dart, so no override is needed here.
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Checks if an email address is already registered.
  ///
  /// Returns `true` if the email has an existing account, `false` otherwise.
  /// This allows the client to show appropriate error messages before
  /// attempting registration.
  _i3.Future<bool> isEmailRegistered({required String email}) =>
      caller.callServerEndpoint<bool>(
        'emailIdp',
        'isEmailRegistered',
        {'email': email},
      );

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointActivity extends _i2.EndpointRef {
  EndpointActivity(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'activity';

  /// Gets activity log for a card
  _i3.Future<List<_i5.CardActivity>> getLog(int cardId) =>
      caller.callServerEndpoint<List<_i5.CardActivity>>(
        'activity',
        'getLog',
        {'cardId': cardId},
      );
}

/// {@category Endpoint}
class EndpointAttachment extends _i2.EndpointRef {
  EndpointAttachment(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'attachment';

  /// Uploads a file directly via ByteData.
  /// This is a simpler approach that doesn't require the FileUploader client.
  ///
  /// Requires: card.update permission
  _i3.Future<_i6.Attachment?> uploadFile({
    required int cardId,
    required String fileName,
    required _i7.ByteData fileData,
    required String mimeType,
  }) => caller.callServerEndpoint<_i6.Attachment?>(
    'attachment',
    'uploadFile',
    {
      'cardId': cardId,
      'fileName': fileName,
      'fileData': fileData,
      'mimeType': mimeType,
    },
  );

  /// Returns an upload description for uploading a file to the server.
  /// The file is uploaded to the [storageId] storage.
  /// Returns a JSON string: {"path": "...", "description": "..."}
  ///
  /// Requires: card.update permission
  _i3.Future<String?> getUploadDescription({
    required int cardId,
    required String fileName,
    required int size,
    required String mimeType,
  }) => caller.callServerEndpoint<String?>(
    'attachment',
    'getUploadDescription',
    {
      'cardId': cardId,
      'fileName': fileName,
      'size': size,
      'mimeType': mimeType,
    },
  );

  /// Verifies that a file has been uploaded and creates the Attachment record.
  ///
  /// Requires: card.update permission
  _i3.Future<_i6.Attachment?> verifyUpload({
    required int cardId,
    required String fileName,
    required String storagePath,
    required String mimeType,
    required int size,
  }) => caller.callServerEndpoint<_i6.Attachment?>(
    'attachment',
    'verifyUpload',
    {
      'cardId': cardId,
      'fileName': fileName,
      'storagePath': storagePath,
      'mimeType': mimeType,
      'size': size,
    },
  );

  /// Lists all active attachments for a card.
  ///
  /// Requires: card.read permission
  _i3.Future<List<_i6.Attachment>> listAttachments(int cardId) =>
      caller.callServerEndpoint<List<_i6.Attachment>>(
        'attachment',
        'listAttachments',
        {'cardId': cardId},
      );

  /// Deletes an attachment (soft delete).
  ///
  /// Requires: card.update permission (and check ownership/admin logic)
  _i3.Future<void> deleteAttachment(int attachmentId) =>
      caller.callServerEndpoint<void>(
        'attachment',
        'deleteAttachment',
        {'attachmentId': attachmentId},
      );
}

/// Endpoint for managing boards within a workspace
/// {@category Endpoint}
class EndpointBoard extends _i2.EndpointRef {
  EndpointBoard(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'board';

  /// Gets all boards for a workspace by ID
  /// Requires: board.read permission
  _i3.Future<List<_i8.Board>> getBoards(int workspaceId) =>
      caller.callServerEndpoint<List<_i8.Board>>(
        'board',
        'getBoards',
        {'workspaceId': workspaceId},
      );

  /// Gets all boards for a workspace by workspace slug
  /// Requires: board.read permission
  _i3.Future<List<_i8.Board>> getBoardsByWorkspaceSlug(String workspaceSlug) =>
      caller.callServerEndpoint<List<_i8.Board>>(
        'board',
        'getBoardsByWorkspaceSlug',
        {'workspaceSlug': workspaceSlug},
      );

  /// Gets a single board by slug within a workspace (by workspace ID)
  /// Requires: board.read permission
  _i3.Future<_i8.Board?> getBoard(
    int workspaceId,
    String slug,
  ) => caller.callServerEndpoint<_i8.Board?>(
    'board',
    'getBoard',
    {
      'workspaceId': workspaceId,
      'slug': slug,
    },
  );

  /// Gets a single board by workspace slug and board slug
  /// Requires: board.read permission
  _i3.Future<_i8.Board?> getBoardBySlug(
    String workspaceSlug,
    String boardSlug,
  ) => caller.callServerEndpoint<_i8.Board?>(
    'board',
    'getBoardBySlug',
    {
      'workspaceSlug': workspaceSlug,
      'boardSlug': boardSlug,
    },
  );

  /// Creates a new board in a workspace (by workspace ID)
  /// Requires: board.create permission
  _i3.Future<_i8.Board> createBoard(
    int workspaceId,
    String title,
  ) => caller.callServerEndpoint<_i8.Board>(
    'board',
    'createBoard',
    {
      'workspaceId': workspaceId,
      'title': title,
    },
  );

  /// Creates a new board in a workspace by workspace slug
  /// Requires: board.create permission
  _i3.Future<_i8.Board> createBoardByWorkspaceSlug(
    String workspaceSlug,
    String title,
  ) => caller.callServerEndpoint<_i8.Board>(
    'board',
    'createBoardByWorkspaceSlug',
    {
      'workspaceSlug': workspaceSlug,
      'title': title,
    },
  );

  /// Updates a board's title and/or slug
  /// Requires: board.update permission
  _i3.Future<_i8.Board> updateBoard(
    int boardId,
    String title,
    String? slug,
  ) => caller.callServerEndpoint<_i8.Board>(
    'board',
    'updateBoard',
    {
      'boardId': boardId,
      'title': title,
      'slug': slug,
    },
  );

  /// Soft deletes a board
  /// Requires: board.delete permission
  _i3.Future<void> deleteBoard(int boardId) => caller.callServerEndpoint<void>(
    'board',
    'deleteBoard',
    {'boardId': boardId},
  );
}

/// Endpoint for managing cards within a list
/// {@category Endpoint}
class EndpointCard extends _i2.EndpointRef {
  EndpointCard(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'card';

  /// Gets all cards for a list
  /// Requires: board.read permission
  _i3.Future<List<_i9.Card>> getCards(int listId) =>
      caller.callServerEndpoint<List<_i9.Card>>(
        'card',
        'getCards',
        {'listId': listId},
      );

  /// Gets all cards for a board with complete details
  /// Requires: board.read permission
  ///
  /// This is an aggregate endpoint that returns everything needed for the board page
  /// in a single request, reducing the number of HTTP calls from many to 1.
  _i3.Future<List<_i10.CardDetail>> getCardsByBoardDetail(int boardId) =>
      caller.callServerEndpoint<List<_i10.CardDetail>>(
        'card',
        'getCardsByBoardDetail',
        {'boardId': boardId},
      );

  /// Gets a single card by ID
  /// Requires: board.read permission
  _i3.Future<_i9.Card?> getCard(int cardId) =>
      caller.callServerEndpoint<_i9.Card?>(
        'card',
        'getCard',
        {'cardId': cardId},
      );

  /// Creates a new card in a list
  /// Requires: board.update permission
  _i3.Future<_i9.Card> createCard(
    int listId,
    String title, {
    String? description,
    required _i11.CardPriority priority,
    DateTime? dueDate,
  }) => caller.callServerEndpoint<_i9.Card>(
    'card',
    'createCard',
    {
      'listId': listId,
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate,
    },
  );

  /// Creates a new card and returns complete CardDetail
  /// Requires: board.update permission
  _i3.Future<_i10.CardDetail> createCardDetail(
    int listId,
    String title, {
    String? description,
    required _i11.CardPriority priority,
    DateTime? dueDate,
  }) => caller.callServerEndpoint<_i10.CardDetail>(
    'card',
    'createCardDetail',
    {
      'listId': listId,
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate,
    },
  );

  /// Updates a card's details
  /// Requires: board.update permission
  _i3.Future<_i9.Card> updateCard(
    int cardId, {
    String? title,
    String? description,
    _i11.CardPriority? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) => caller.callServerEndpoint<_i9.Card>(
    'card',
    'updateCard',
    {
      'cardId': cardId,
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
    },
  );

  /// Moves a card to a different list and/or reorders within the list
  /// Requires: board.update permission
  _i3.Future<_i9.Card> moveCard(
    int cardId,
    int targetListId, {
    String? afterRank,
    String? beforeRank,
    _i11.CardPriority? newPriority,
  }) => caller.callServerEndpoint<_i9.Card>(
    'card',
    'moveCard',
    {
      'cardId': cardId,
      'targetListId': targetListId,
      'afterRank': afterRank,
      'beforeRank': beforeRank,
      'newPriority': newPriority,
    },
  );

  /// Soft deletes a card
  /// Requires: board.update permission
  _i3.Future<void> deleteCard(int cardId) => caller.callServerEndpoint<void>(
    'card',
    'deleteCard',
    {'cardId': cardId},
  );

  /// Toggles card completion status
  /// Requires: board.update permission
  _i3.Future<_i9.Card> toggleComplete(int cardId) =>
      caller.callServerEndpoint<_i9.Card>(
        'card',
        'toggleComplete',
        {'cardId': cardId},
      );

  /// Gets complete card details including all related data
  /// Requires: board.read permission
  ///
  /// This is an aggregate endpoint that returns everything needed for the card detail page
  /// in a single request, reducing the number of HTTP calls from 7+ to 1.
  _i3.Future<_i10.CardDetail?> getCardDetail(int cardId) =>
      caller.callServerEndpoint<_i10.CardDetail?>(
        'card',
        'getCardDetail',
        {'cardId': cardId},
      );

  /// Gets complete card details by UUID
  /// Requires: board.read permission
  _i3.Future<_i10.CardDetail?> getCardDetailByUuid(String uuid) =>
      caller.callServerEndpoint<_i10.CardDetail?>(
        'card',
        'getCardDetailByUuid',
        {'uuid': uuid},
      );

  /// Gets board context with all cards (summary only)
  /// Requires: board.read permission
  ///
  /// This endpoint returns BoardContext (loaded once) + CardSummary list (lightweight)
  /// Use this instead of getCardsByBoardDetail for better performance
  _i3.Future<_i12.BoardWithCards> getBoardWithCards(int boardId) =>
      caller.callServerEndpoint<_i12.BoardWithCards>(
        'card',
        'getBoardWithCards',
        {'boardId': boardId},
      );
}

/// Endpoint for managing lists within a board
/// {@category Endpoint}
class EndpointCardList extends _i2.EndpointRef {
  EndpointCardList(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'cardList';

  /// Gets all lists for a board
  /// Requires: board.read permission
  _i3.Future<List<_i13.CardList>> getLists(int boardId) =>
      caller.callServerEndpoint<List<_i13.CardList>>(
        'cardList',
        'getLists',
        {'boardId': boardId},
      );

  /// Creates a new list in a board
  /// Requires: board.update permission
  _i3.Future<_i13.CardList> createList(
    int boardId,
    String title,
  ) => caller.callServerEndpoint<_i13.CardList>(
    'cardList',
    'createList',
    {
      'boardId': boardId,
      'title': title,
    },
  );

  /// Updates a list's title
  /// Requires: board.update permission
  _i3.Future<_i13.CardList> updateList(
    int listId,
    String title,
  ) => caller.callServerEndpoint<_i13.CardList>(
    'cardList',
    'updateList',
    {
      'listId': listId,
      'title': title,
    },
  );

  /// Reorders lists within a board
  /// Receives an ordered list of list IDs and recalculates ranks
  /// Requires: board.update permission
  _i3.Future<List<_i13.CardList>> reorderLists(
    int boardId,
    List<int> orderedListIds,
  ) => caller.callServerEndpoint<List<_i13.CardList>>(
    'cardList',
    'reorderLists',
    {
      'boardId': boardId,
      'orderedListIds': orderedListIds,
    },
  );

  /// Soft deletes a list
  /// Requires: board.update permission
  _i3.Future<void> deleteList(int listId) => caller.callServerEndpoint<void>(
    'cardList',
    'deleteList',
    {'listId': listId},
  );

  /// Archives a list (sets archived = true)
  /// Requires: board.update permission
  _i3.Future<_i13.CardList> archiveList(int listId) =>
      caller.callServerEndpoint<_i13.CardList>(
        'cardList',
        'archiveList',
        {'listId': listId},
      );
}

/// Endpoint for managing checklists within a card
/// {@category Endpoint}
class EndpointChecklist extends _i2.EndpointRef {
  EndpointChecklist(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'checklist';

  /// Gets all checklists for a card
  /// Requires: board.read permission
  _i3.Future<List<_i14.Checklist>> getChecklists(int cardId) =>
      caller.callServerEndpoint<List<_i14.Checklist>>(
        'checklist',
        'getChecklists',
        {'cardId': cardId},
      );

  /// Gets all items for a checklist
  /// Requires: board.read permission
  _i3.Future<List<_i15.ChecklistItem>> getItems(int checklistId) =>
      caller.callServerEndpoint<List<_i15.ChecklistItem>>(
        'checklist',
        'getItems',
        {'checklistId': checklistId},
      );

  /// Creates a new checklist in a card
  /// Requires: board.update permission
  _i3.Future<_i14.Checklist> createChecklist(
    int cardId,
    String title,
  ) => caller.callServerEndpoint<_i14.Checklist>(
    'checklist',
    'createChecklist',
    {
      'cardId': cardId,
      'title': title,
    },
  );

  /// Updates a checklist
  /// Requires: board.update permission
  _i3.Future<_i14.Checklist> updateChecklist(
    int checklistId,
    String title,
  ) => caller.callServerEndpoint<_i14.Checklist>(
    'checklist',
    'updateChecklist',
    {
      'checklistId': checklistId,
      'title': title,
    },
  );

  /// Soft deletes a checklist
  /// Requires: board.update permission
  _i3.Future<void> deleteChecklist(int checklistId) =>
      caller.callServerEndpoint<void>(
        'checklist',
        'deleteChecklist',
        {'checklistId': checklistId},
      );

  /// Creates a new item in a checklist
  /// Requires: board.update permission
  _i3.Future<_i15.ChecklistItem> addItem(
    int checklistId,
    String title,
  ) => caller.callServerEndpoint<_i15.ChecklistItem>(
    'checklist',
    'addItem',
    {
      'checklistId': checklistId,
      'title': title,
    },
  );

  /// Updates a checklist item
  /// Requires: board.update permission
  _i3.Future<_i15.ChecklistItem> updateItem(
    int itemId, {
    String? title,
    bool? isChecked,
  }) => caller.callServerEndpoint<_i15.ChecklistItem>(
    'checklist',
    'updateItem',
    {
      'itemId': itemId,
      'title': title,
      'isChecked': isChecked,
    },
  );

  /// Soft deletes a checklist item
  /// Requires: board.update permission
  _i3.Future<void> deleteItem(int itemId) => caller.callServerEndpoint<void>(
    'checklist',
    'deleteItem',
    {'itemId': itemId},
  );
}

/// {@category Endpoint}
class EndpointComment extends _i2.EndpointRef {
  EndpointComment(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'comment';

  /// Gets all comments for a card
  _i3.Future<List<_i16.Comment>> getComments(int cardId) =>
      caller.callServerEndpoint<List<_i16.Comment>>(
        'comment',
        'getComments',
        {'cardId': cardId},
      );

  /// Creates a comment
  _i3.Future<_i16.Comment> createComment(
    int cardId,
    String content,
  ) => caller.callServerEndpoint<_i16.Comment>(
    'comment',
    'createComment',
    {
      'cardId': cardId,
      'content': content,
    },
  );

  /// Deletes a comment (soft delete)
  _i3.Future<void> deleteComment(int commentId) =>
      caller.callServerEndpoint<void>(
        'comment',
        'deleteComment',
        {'commentId': commentId},
      );
}

/// Endpoint for managing workspace invites
/// {@category Endpoint}
class EndpointInvite extends _i2.EndpointRef {
  EndpointInvite(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'invite';

  /// Creates a new workspace invite
  /// Requires 'workspace.invite' permission
  _i3.Future<_i17.WorkspaceInvite> createInvite(
    int workspaceId,
    List<int> permissionIds, {
    String? email,
  }) => caller.callServerEndpoint<_i17.WorkspaceInvite>(
    'invite',
    'createInvite',
    {
      'workspaceId': workspaceId,
      'permissionIds': permissionIds,
      'email': email,
    },
  );

  /// Gets all pending invites for a workspace
  _i3.Future<List<_i17.WorkspaceInvite>> getInvites(int workspaceId) =>
      caller.callServerEndpoint<List<_i17.WorkspaceInvite>>(
        'invite',
        'getInvites',
        {'workspaceId': workspaceId},
      );

  /// Revokes an invite
  _i3.Future<void> revokeInvite(int inviteId) =>
      caller.callServerEndpoint<void>(
        'invite',
        'revokeInvite',
        {'inviteId': inviteId},
      );

  /// Gets invite by code (public - no auth required for validation)
  _i3.Future<_i18.InviteDetails?> getInviteByCode(String code) =>
      caller.callServerEndpoint<_i18.InviteDetails?>(
        'invite',
        'getInviteByCode',
        {'code': code},
      );

  /// Accepts an invite and joins workspace
  /// Requires authentication
  _i3.Future<_i19.AcceptInviteResult> acceptInvite(String code) =>
      caller.callServerEndpoint<_i19.AcceptInviteResult>(
        'invite',
        'acceptInvite',
        {'code': code},
      );
}

/// {@category Endpoint}
class EndpointLabel extends _i2.EndpointRef {
  EndpointLabel(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'label';

  /// Gets all labels defined for a board
  _i3.Future<List<_i20.LabelDef>> getLabels(int boardId) =>
      caller.callServerEndpoint<List<_i20.LabelDef>>(
        'label',
        'getLabels',
        {'boardId': boardId},
      );

  /// Creates a new label definition
  _i3.Future<_i20.LabelDef> createLabel(
    int boardId,
    String name,
    String colorHex,
  ) => caller.callServerEndpoint<_i20.LabelDef>(
    'label',
    'createLabel',
    {
      'boardId': boardId,
      'name': name,
      'colorHex': colorHex,
    },
  );

  /// Updates a label definition
  _i3.Future<_i20.LabelDef> updateLabel(
    int labelId,
    String name,
    String colorHex,
  ) => caller.callServerEndpoint<_i20.LabelDef>(
    'label',
    'updateLabel',
    {
      'labelId': labelId,
      'name': name,
      'colorHex': colorHex,
    },
  );

  /// Deletes a label definition (soft delete)
  _i3.Future<void> deleteLabel(int labelId) => caller.callServerEndpoint<void>(
    'label',
    'deleteLabel',
    {'labelId': labelId},
  );

  /// Attaches a label to a card
  _i3.Future<void> attachLabel(
    int cardId,
    int labelId,
  ) => caller.callServerEndpoint<void>(
    'label',
    'attachLabel',
    {
      'cardId': cardId,
      'labelId': labelId,
    },
  );

  /// Detaches a label from a card
  _i3.Future<void> detachLabel(
    int cardId,
    int labelId,
  ) => caller.callServerEndpoint<void>(
    'label',
    'detachLabel',
    {
      'cardId': cardId,
      'labelId': labelId,
    },
  );

  /// Get labels attached to a card
  _i3.Future<List<_i20.LabelDef>> getCardLabels(int cardId) =>
      caller.callServerEndpoint<List<_i20.LabelDef>>(
        'label',
        'getCardLabels',
        {'cardId': cardId},
      );
}

/// Endpoint for managing workspace members
/// {@category Endpoint}
class EndpointMember extends _i2.EndpointRef {
  EndpointMember(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'member';

  /// Gets all members of a workspace with UserInfo details
  _i3.Future<List<_i21.MemberWithUser>> getMembers(int workspaceId) =>
      caller.callServerEndpoint<List<_i21.MemberWithUser>>(
        'member',
        'getMembers',
        {'workspaceId': workspaceId},
      );

  /// Removes a member from workspace (soft delete)
  _i3.Future<void> removeMember(int memberId) =>
      caller.callServerEndpoint<void>(
        'member',
        'removeMember',
        {'memberId': memberId},
      );

  /// Updates member role
  _i3.Future<_i22.WorkspaceMember> updateMemberRole(
    int memberId,
    _i23.MemberRole newRole,
  ) => caller.callServerEndpoint<_i22.WorkspaceMember>(
    'member',
    'updateMemberRole',
    {
      'memberId': memberId,
      'newRole': newRole,
    },
  );

  /// Gets all permissions for a member with granted status
  _i3.Future<List<_i24.PermissionInfo>> getMemberPermissions(int memberId) =>
      caller.callServerEndpoint<List<_i24.PermissionInfo>>(
        'member',
        'getMemberPermissions',
        {'memberId': memberId},
      );

  /// Updates member permissions
  _i3.Future<void> updateMemberPermissions(
    int memberId,
    List<int> permissionIds,
  ) => caller.callServerEndpoint<void>(
    'member',
    'updateMemberPermissions',
    {
      'memberId': memberId,
      'permissionIds': permissionIds,
    },
  );

  /// Transfers workspace ownership to another member
  _i3.Future<void> transferOwnership(
    int workspaceId,
    int newOwnerId,
  ) => caller.callServerEndpoint<void>(
    'member',
    'transferOwnership',
    {
      'workspaceId': workspaceId,
      'newOwnerId': newOwnerId,
    },
  );

  /// Gets all available permissions in the system
  _i3.Future<List<_i25.Permission>> getAllPermissions() =>
      caller.callServerEndpoint<List<_i25.Permission>>(
        'member',
        'getAllPermissions',
        {},
      );
}

/// Endpoint for managing workspaces
/// {@category Endpoint}
class EndpointWorkspace extends _i2.EndpointRef {
  EndpointWorkspace(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'workspace';

  /// Gets all workspaces for authenticated user
  _i3.Future<List<_i26.Workspace>> getWorkspaces() =>
      caller.callServerEndpoint<List<_i26.Workspace>>(
        'workspace',
        'getWorkspaces',
        {},
      );

  /// Gets a single workspace by slug
  /// Verifies that user has permission to read workspace
  _i3.Future<_i26.Workspace?> getWorkspace(String slug) =>
      caller.callServerEndpoint<_i26.Workspace?>(
        'workspace',
        'getWorkspace',
        {'slug': slug},
      );

  /// Creates a new workspace
  _i3.Future<_i26.Workspace> createWorkspace(
    String title,
    String? slug,
  ) => caller.callServerEndpoint<_i26.Workspace>(
    'workspace',
    'createWorkspace',
    {
      'title': title,
      'slug': slug,
    },
  );

  /// Updates workspace settings
  _i3.Future<_i26.Workspace> updateWorkspace(
    int workspaceId,
    String title,
    String? slug,
  ) => caller.callServerEndpoint<_i26.Workspace>(
    'workspace',
    'updateWorkspace',
    {
      'workspaceId': workspaceId,
      'title': title,
      'slug': slug,
    },
  );

  /// Soft deletes a workspace
  _i3.Future<void> deleteWorkspace(int workspaceId) =>
      caller.callServerEndpoint<void>(
        'workspace',
        'deleteWorkspace',
        {'workspaceId': workspaceId},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i27.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i27.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
    auth = _i28.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;

  late final _i28.Caller auth;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i29.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    activity = EndpointActivity(this);
    attachment = EndpointAttachment(this);
    board = EndpointBoard(this);
    card = EndpointCard(this);
    cardList = EndpointCardList(this);
    checklist = EndpointChecklist(this);
    comment = EndpointComment(this);
    invite = EndpointInvite(this);
    label = EndpointLabel(this);
    member = EndpointMember(this);
    workspace = EndpointWorkspace(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointActivity activity;

  late final EndpointAttachment attachment;

  late final EndpointBoard board;

  late final EndpointCard card;

  late final EndpointCardList cardList;

  late final EndpointChecklist checklist;

  late final EndpointComment comment;

  late final EndpointInvite invite;

  late final EndpointLabel label;

  late final EndpointMember member;

  late final EndpointWorkspace workspace;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'activity': activity,
    'attachment': attachment,
    'board': board,
    'card': card,
    'cardList': cardList,
    'checklist': checklist,
    'comment': comment,
    'invite': invite,
    'label': label,
    'member': member,
    'workspace': workspace,
    'greeting': greeting,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
    'auth': modules.auth,
  };
}
