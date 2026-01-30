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
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/activity_endpoint.dart' as _i4;
import '../endpoints/attachment_endpoint.dart' as _i5;
import '../endpoints/board_endpoint.dart' as _i6;
import '../endpoints/card_endpoint.dart' as _i7;
import '../endpoints/card_list_endpoint.dart' as _i8;
import '../endpoints/checklist_endpoint.dart' as _i9;
import '../endpoints/comment_endpoint.dart' as _i10;
import '../endpoints/invite_endpoint.dart' as _i11;
import '../endpoints/label_endpoint.dart' as _i12;
import '../endpoints/member_endpoint.dart' as _i13;
import '../endpoints/workspace_endpoint.dart' as _i14;
import '../greetings/greeting_endpoint.dart' as _i15;
import 'dart:typed_data' as _i16;
import 'package:kanew_server/src/generated/card_priority.dart' as _i17;
import 'package:kanew_server/src/generated/member_role.dart' as _i18;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i19;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i20;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i21;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'activity': _i4.ActivityEndpoint()
        ..initialize(
          server,
          'activity',
          null,
        ),
      'attachment': _i5.AttachmentEndpoint()
        ..initialize(
          server,
          'attachment',
          null,
        ),
      'board': _i6.BoardEndpoint()
        ..initialize(
          server,
          'board',
          null,
        ),
      'card': _i7.CardEndpoint()
        ..initialize(
          server,
          'card',
          null,
        ),
      'cardList': _i8.CardListEndpoint()
        ..initialize(
          server,
          'cardList',
          null,
        ),
      'checklist': _i9.ChecklistEndpoint()
        ..initialize(
          server,
          'checklist',
          null,
        ),
      'comment': _i10.CommentEndpoint()
        ..initialize(
          server,
          'comment',
          null,
        ),
      'invite': _i11.InviteEndpoint()
        ..initialize(
          server,
          'invite',
          null,
        ),
      'label': _i12.LabelEndpoint()
        ..initialize(
          server,
          'label',
          null,
        ),
      'member': _i13.MemberEndpoint()
        ..initialize(
          server,
          'member',
          null,
        ),
      'workspace': _i14.WorkspaceEndpoint()
        ..initialize(
          server,
          'workspace',
          null,
        ),
      'greeting': _i15.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'isEmailRegistered': _i1.MethodConnector(
          name: 'isEmailRegistered',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .isEmailRegistered(
                    session,
                    email: params['email'],
                  ),
        ),
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['activity'] = _i1.EndpointConnector(
      name: 'activity',
      endpoint: endpoints['activity']!,
      methodConnectors: {
        'getLog': _i1.MethodConnector(
          name: 'getLog',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['activity'] as _i4.ActivityEndpoint).getLog(
                session,
                params['cardId'],
              ),
        ),
      },
    );
    connectors['attachment'] = _i1.EndpointConnector(
      name: 'attachment',
      endpoint: endpoints['attachment']!,
      methodConnectors: {
        'uploadFile': _i1.MethodConnector(
          name: 'uploadFile',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'fileData': _i1.ParameterDescription(
              name: 'fileData',
              type: _i1.getType<_i16.ByteData>(),
              nullable: false,
            ),
            'mimeType': _i1.ParameterDescription(
              name: 'mimeType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['attachment'] as _i5.AttachmentEndpoint)
                  .uploadFile(
                    session,
                    cardId: params['cardId'],
                    fileName: params['fileName'],
                    fileData: params['fileData'],
                    mimeType: params['mimeType'],
                  ),
        ),
        'getUploadDescription': _i1.MethodConnector(
          name: 'getUploadDescription',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'size': _i1.ParameterDescription(
              name: 'size',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'mimeType': _i1.ParameterDescription(
              name: 'mimeType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['attachment'] as _i5.AttachmentEndpoint)
                  .getUploadDescription(
                    session,
                    cardId: params['cardId'],
                    fileName: params['fileName'],
                    size: params['size'],
                    mimeType: params['mimeType'],
                  ),
        ),
        'verifyUpload': _i1.MethodConnector(
          name: 'verifyUpload',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'storagePath': _i1.ParameterDescription(
              name: 'storagePath',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'mimeType': _i1.ParameterDescription(
              name: 'mimeType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'size': _i1.ParameterDescription(
              name: 'size',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['attachment'] as _i5.AttachmentEndpoint)
                  .verifyUpload(
                    session,
                    cardId: params['cardId'],
                    fileName: params['fileName'],
                    storagePath: params['storagePath'],
                    mimeType: params['mimeType'],
                    size: params['size'],
                  ),
        ),
        'listAttachments': _i1.MethodConnector(
          name: 'listAttachments',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['attachment'] as _i5.AttachmentEndpoint)
                  .listAttachments(
                    session,
                    params['cardId'],
                  ),
        ),
        'deleteAttachment': _i1.MethodConnector(
          name: 'deleteAttachment',
          params: {
            'attachmentId': _i1.ParameterDescription(
              name: 'attachmentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['attachment'] as _i5.AttachmentEndpoint)
                  .deleteAttachment(
                    session,
                    params['attachmentId'],
                  ),
        ),
      },
    );
    connectors['board'] = _i1.EndpointConnector(
      name: 'board',
      endpoint: endpoints['board']!,
      methodConnectors: {
        'getBoards': _i1.MethodConnector(
          name: 'getBoards',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['board'] as _i6.BoardEndpoint).getBoards(
                session,
                params['workspaceId'],
              ),
        ),
        'getBoardsByWorkspaceSlug': _i1.MethodConnector(
          name: 'getBoardsByWorkspaceSlug',
          params: {
            'workspaceSlug': _i1.ParameterDescription(
              name: 'workspaceSlug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['board'] as _i6.BoardEndpoint)
                  .getBoardsByWorkspaceSlug(
                    session,
                    params['workspaceSlug'],
                  ),
        ),
        'getBoard': _i1.MethodConnector(
          name: 'getBoard',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'slug': _i1.ParameterDescription(
              name: 'slug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['board'] as _i6.BoardEndpoint).getBoard(
                session,
                params['workspaceId'],
                params['slug'],
              ),
        ),
        'getBoardBySlug': _i1.MethodConnector(
          name: 'getBoardBySlug',
          params: {
            'workspaceSlug': _i1.ParameterDescription(
              name: 'workspaceSlug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'boardSlug': _i1.ParameterDescription(
              name: 'boardSlug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['board'] as _i6.BoardEndpoint).getBoardBySlug(
                    session,
                    params['workspaceSlug'],
                    params['boardSlug'],
                  ),
        ),
        'createBoard': _i1.MethodConnector(
          name: 'createBoard',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['board'] as _i6.BoardEndpoint).createBoard(
                session,
                params['workspaceId'],
                params['title'],
              ),
        ),
        'createBoardByWorkspaceSlug': _i1.MethodConnector(
          name: 'createBoardByWorkspaceSlug',
          params: {
            'workspaceSlug': _i1.ParameterDescription(
              name: 'workspaceSlug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['board'] as _i6.BoardEndpoint)
                  .createBoardByWorkspaceSlug(
                    session,
                    params['workspaceSlug'],
                    params['title'],
                  ),
        ),
        'updateBoard': _i1.MethodConnector(
          name: 'updateBoard',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'slug': _i1.ParameterDescription(
              name: 'slug',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['board'] as _i6.BoardEndpoint).updateBoard(
                session,
                params['boardId'],
                params['title'],
                params['slug'],
              ),
        ),
        'deleteBoard': _i1.MethodConnector(
          name: 'deleteBoard',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['board'] as _i6.BoardEndpoint).deleteBoard(
                session,
                params['boardId'],
              ),
        ),
      },
    );
    connectors['card'] = _i1.EndpointConnector(
      name: 'card',
      endpoint: endpoints['card']!,
      methodConnectors: {
        'getCards': _i1.MethodConnector(
          name: 'getCards',
          params: {
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['card'] as _i7.CardEndpoint).getCards(
                session,
                params['listId'],
              ),
        ),
        'getCardsByBoardDetail': _i1.MethodConnector(
          name: 'getCardsByBoardDetail',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['card'] as _i7.CardEndpoint).getCardsByBoardDetail(
                    session,
                    params['boardId'],
                  ),
        ),
        'getCard': _i1.MethodConnector(
          name: 'getCard',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['card'] as _i7.CardEndpoint).getCard(
                session,
                params['cardId'],
              ),
        ),
        'createCard': _i1.MethodConnector(
          name: 'createCard',
          params: {
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<_i17.CardPriority>(),
              nullable: false,
            ),
            'dueDate': _i1.ParameterDescription(
              name: 'dueDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['card'] as _i7.CardEndpoint).createCard(
                session,
                params['listId'],
                params['title'],
                description: params['description'],
                priority: params['priority'],
                dueDate: params['dueDate'],
              ),
        ),
        'createCardDetail': _i1.MethodConnector(
          name: 'createCardDetail',
          params: {
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<_i17.CardPriority>(),
              nullable: false,
            ),
            'dueDate': _i1.ParameterDescription(
              name: 'dueDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['card'] as _i7.CardEndpoint).createCardDetail(
                    session,
                    params['listId'],
                    params['title'],
                    description: params['description'],
                    priority: params['priority'],
                    dueDate: params['dueDate'],
                  ),
        ),
        'updateCard': _i1.MethodConnector(
          name: 'updateCard',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<_i17.CardPriority?>(),
              nullable: true,
            ),
            'dueDate': _i1.ParameterDescription(
              name: 'dueDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'isCompleted': _i1.ParameterDescription(
              name: 'isCompleted',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['card'] as _i7.CardEndpoint).updateCard(
                session,
                params['cardId'],
                title: params['title'],
                description: params['description'],
                priority: params['priority'],
                dueDate: params['dueDate'],
                isCompleted: params['isCompleted'],
              ),
        ),
        'moveCard': _i1.MethodConnector(
          name: 'moveCard',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'targetListId': _i1.ParameterDescription(
              name: 'targetListId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'afterRank': _i1.ParameterDescription(
              name: 'afterRank',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'beforeRank': _i1.ParameterDescription(
              name: 'beforeRank',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newPriority': _i1.ParameterDescription(
              name: 'newPriority',
              type: _i1.getType<_i17.CardPriority?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['card'] as _i7.CardEndpoint).moveCard(
                session,
                params['cardId'],
                params['targetListId'],
                afterRank: params['afterRank'],
                beforeRank: params['beforeRank'],
                newPriority: params['newPriority'],
              ),
        ),
        'deleteCard': _i1.MethodConnector(
          name: 'deleteCard',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['card'] as _i7.CardEndpoint).deleteCard(
                session,
                params['cardId'],
              ),
        ),
        'toggleComplete': _i1.MethodConnector(
          name: 'toggleComplete',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['card'] as _i7.CardEndpoint).toggleComplete(
                session,
                params['cardId'],
              ),
        ),
        'getCardDetail': _i1.MethodConnector(
          name: 'getCardDetail',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['card'] as _i7.CardEndpoint).getCardDetail(
                session,
                params['cardId'],
              ),
        ),
        'getCardDetailByUuid': _i1.MethodConnector(
          name: 'getCardDetailByUuid',
          params: {
            'uuid': _i1.ParameterDescription(
              name: 'uuid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['card'] as _i7.CardEndpoint).getCardDetailByUuid(
                    session,
                    params['uuid'],
                  ),
        ),
        'getBoardWithCards': _i1.MethodConnector(
          name: 'getBoardWithCards',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['card'] as _i7.CardEndpoint).getBoardWithCards(
                    session,
                    params['boardId'],
                  ),
        ),
      },
    );
    connectors['cardList'] = _i1.EndpointConnector(
      name: 'cardList',
      endpoint: endpoints['cardList']!,
      methodConnectors: {
        'getLists': _i1.MethodConnector(
          name: 'getLists',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cardList'] as _i8.CardListEndpoint).getLists(
                    session,
                    params['boardId'],
                  ),
        ),
        'createList': _i1.MethodConnector(
          name: 'createList',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cardList'] as _i8.CardListEndpoint).createList(
                    session,
                    params['boardId'],
                    params['title'],
                  ),
        ),
        'updateList': _i1.MethodConnector(
          name: 'updateList',
          params: {
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cardList'] as _i8.CardListEndpoint).updateList(
                    session,
                    params['listId'],
                    params['title'],
                  ),
        ),
        'reorderLists': _i1.MethodConnector(
          name: 'reorderLists',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'orderedListIds': _i1.ParameterDescription(
              name: 'orderedListIds',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cardList'] as _i8.CardListEndpoint).reorderLists(
                    session,
                    params['boardId'],
                    params['orderedListIds'],
                  ),
        ),
        'deleteList': _i1.MethodConnector(
          name: 'deleteList',
          params: {
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cardList'] as _i8.CardListEndpoint).deleteList(
                    session,
                    params['listId'],
                  ),
        ),
        'archiveList': _i1.MethodConnector(
          name: 'archiveList',
          params: {
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cardList'] as _i8.CardListEndpoint).archiveList(
                    session,
                    params['listId'],
                  ),
        ),
      },
    );
    connectors['checklist'] = _i1.EndpointConnector(
      name: 'checklist',
      endpoint: endpoints['checklist']!,
      methodConnectors: {
        'getChecklists': _i1.MethodConnector(
          name: 'getChecklists',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['checklist'] as _i9.ChecklistEndpoint)
                  .getChecklists(
                    session,
                    params['cardId'],
                  ),
        ),
        'getItems': _i1.MethodConnector(
          name: 'getItems',
          params: {
            'checklistId': _i1.ParameterDescription(
              name: 'checklistId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['checklist'] as _i9.ChecklistEndpoint).getItems(
                    session,
                    params['checklistId'],
                  ),
        ),
        'createChecklist': _i1.MethodConnector(
          name: 'createChecklist',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['checklist'] as _i9.ChecklistEndpoint)
                  .createChecklist(
                    session,
                    params['cardId'],
                    params['title'],
                  ),
        ),
        'updateChecklist': _i1.MethodConnector(
          name: 'updateChecklist',
          params: {
            'checklistId': _i1.ParameterDescription(
              name: 'checklistId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['checklist'] as _i9.ChecklistEndpoint)
                  .updateChecklist(
                    session,
                    params['checklistId'],
                    params['title'],
                  ),
        ),
        'deleteChecklist': _i1.MethodConnector(
          name: 'deleteChecklist',
          params: {
            'checklistId': _i1.ParameterDescription(
              name: 'checklistId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['checklist'] as _i9.ChecklistEndpoint)
                  .deleteChecklist(
                    session,
                    params['checklistId'],
                  ),
        ),
        'addItem': _i1.MethodConnector(
          name: 'addItem',
          params: {
            'checklistId': _i1.ParameterDescription(
              name: 'checklistId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['checklist'] as _i9.ChecklistEndpoint).addItem(
                    session,
                    params['checklistId'],
                    params['title'],
                  ),
        ),
        'updateItem': _i1.MethodConnector(
          name: 'updateItem',
          params: {
            'itemId': _i1.ParameterDescription(
              name: 'itemId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'isChecked': _i1.ParameterDescription(
              name: 'isChecked',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['checklist'] as _i9.ChecklistEndpoint).updateItem(
                    session,
                    params['itemId'],
                    title: params['title'],
                    isChecked: params['isChecked'],
                  ),
        ),
        'deleteItem': _i1.MethodConnector(
          name: 'deleteItem',
          params: {
            'itemId': _i1.ParameterDescription(
              name: 'itemId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['checklist'] as _i9.ChecklistEndpoint).deleteItem(
                    session,
                    params['itemId'],
                  ),
        ),
      },
    );
    connectors['comment'] = _i1.EndpointConnector(
      name: 'comment',
      endpoint: endpoints['comment']!,
      methodConnectors: {
        'getComments': _i1.MethodConnector(
          name: 'getComments',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['comment'] as _i10.CommentEndpoint).getComments(
                    session,
                    params['cardId'],
                  ),
        ),
        'createComment': _i1.MethodConnector(
          name: 'createComment',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'content': _i1.ParameterDescription(
              name: 'content',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['comment'] as _i10.CommentEndpoint).createComment(
                    session,
                    params['cardId'],
                    params['content'],
                  ),
        ),
        'deleteComment': _i1.MethodConnector(
          name: 'deleteComment',
          params: {
            'commentId': _i1.ParameterDescription(
              name: 'commentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['comment'] as _i10.CommentEndpoint).deleteComment(
                    session,
                    params['commentId'],
                  ),
        ),
      },
    );
    connectors['invite'] = _i1.EndpointConnector(
      name: 'invite',
      endpoint: endpoints['invite']!,
      methodConnectors: {
        'createInvite': _i1.MethodConnector(
          name: 'createInvite',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'permissionIds': _i1.ParameterDescription(
              name: 'permissionIds',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['invite'] as _i11.InviteEndpoint).createInvite(
                    session,
                    params['workspaceId'],
                    params['permissionIds'],
                    email: params['email'],
                  ),
        ),
        'getInvites': _i1.MethodConnector(
          name: 'getInvites',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['invite'] as _i11.InviteEndpoint).getInvites(
                    session,
                    params['workspaceId'],
                  ),
        ),
        'revokeInvite': _i1.MethodConnector(
          name: 'revokeInvite',
          params: {
            'inviteId': _i1.ParameterDescription(
              name: 'inviteId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['invite'] as _i11.InviteEndpoint).revokeInvite(
                    session,
                    params['inviteId'],
                  ),
        ),
        'getInviteByCode': _i1.MethodConnector(
          name: 'getInviteByCode',
          params: {
            'code': _i1.ParameterDescription(
              name: 'code',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['invite'] as _i11.InviteEndpoint).getInviteByCode(
                    session,
                    params['code'],
                  ),
        ),
        'acceptInvite': _i1.MethodConnector(
          name: 'acceptInvite',
          params: {
            'code': _i1.ParameterDescription(
              name: 'code',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['invite'] as _i11.InviteEndpoint).acceptInvite(
                    session,
                    params['code'],
                  ),
        ),
      },
    );
    connectors['label'] = _i1.EndpointConnector(
      name: 'label',
      endpoint: endpoints['label']!,
      methodConnectors: {
        'getLabels': _i1.MethodConnector(
          name: 'getLabels',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['label'] as _i12.LabelEndpoint).getLabels(
                session,
                params['boardId'],
              ),
        ),
        'createLabel': _i1.MethodConnector(
          name: 'createLabel',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'colorHex': _i1.ParameterDescription(
              name: 'colorHex',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['label'] as _i12.LabelEndpoint).createLabel(
                session,
                params['boardId'],
                params['name'],
                params['colorHex'],
              ),
        ),
        'updateLabel': _i1.MethodConnector(
          name: 'updateLabel',
          params: {
            'labelId': _i1.ParameterDescription(
              name: 'labelId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'colorHex': _i1.ParameterDescription(
              name: 'colorHex',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['label'] as _i12.LabelEndpoint).updateLabel(
                session,
                params['labelId'],
                params['name'],
                params['colorHex'],
              ),
        ),
        'deleteLabel': _i1.MethodConnector(
          name: 'deleteLabel',
          params: {
            'labelId': _i1.ParameterDescription(
              name: 'labelId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['label'] as _i12.LabelEndpoint).deleteLabel(
                session,
                params['labelId'],
              ),
        ),
        'attachLabel': _i1.MethodConnector(
          name: 'attachLabel',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'labelId': _i1.ParameterDescription(
              name: 'labelId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['label'] as _i12.LabelEndpoint).attachLabel(
                session,
                params['cardId'],
                params['labelId'],
              ),
        ),
        'detachLabel': _i1.MethodConnector(
          name: 'detachLabel',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'labelId': _i1.ParameterDescription(
              name: 'labelId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['label'] as _i12.LabelEndpoint).detachLabel(
                session,
                params['cardId'],
                params['labelId'],
              ),
        ),
        'getCardLabels': _i1.MethodConnector(
          name: 'getCardLabels',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['label'] as _i12.LabelEndpoint).getCardLabels(
                    session,
                    params['cardId'],
                  ),
        ),
      },
    );
    connectors['member'] = _i1.EndpointConnector(
      name: 'member',
      endpoint: endpoints['member']!,
      methodConnectors: {
        'getMembers': _i1.MethodConnector(
          name: 'getMembers',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['member'] as _i13.MemberEndpoint).getMembers(
                    session,
                    params['workspaceId'],
                  ),
        ),
        'removeMember': _i1.MethodConnector(
          name: 'removeMember',
          params: {
            'memberId': _i1.ParameterDescription(
              name: 'memberId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['member'] as _i13.MemberEndpoint).removeMember(
                    session,
                    params['memberId'],
                  ),
        ),
        'updateMemberRole': _i1.MethodConnector(
          name: 'updateMemberRole',
          params: {
            'memberId': _i1.ParameterDescription(
              name: 'memberId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newRole': _i1.ParameterDescription(
              name: 'newRole',
              type: _i1.getType<_i18.MemberRole>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['member'] as _i13.MemberEndpoint).updateMemberRole(
                    session,
                    params['memberId'],
                    params['newRole'],
                  ),
        ),
        'getMemberPermissions': _i1.MethodConnector(
          name: 'getMemberPermissions',
          params: {
            'memberId': _i1.ParameterDescription(
              name: 'memberId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['member'] as _i13.MemberEndpoint)
                  .getMemberPermissions(
                    session,
                    params['memberId'],
                  ),
        ),
        'updateMemberPermissions': _i1.MethodConnector(
          name: 'updateMemberPermissions',
          params: {
            'memberId': _i1.ParameterDescription(
              name: 'memberId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'permissionIds': _i1.ParameterDescription(
              name: 'permissionIds',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['member'] as _i13.MemberEndpoint)
                  .updateMemberPermissions(
                    session,
                    params['memberId'],
                    params['permissionIds'],
                  ),
        ),
        'transferOwnership': _i1.MethodConnector(
          name: 'transferOwnership',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newOwnerId': _i1.ParameterDescription(
              name: 'newOwnerId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['member'] as _i13.MemberEndpoint)
                  .transferOwnership(
                    session,
                    params['workspaceId'],
                    params['newOwnerId'],
                  ),
        ),
        'getAllPermissions': _i1.MethodConnector(
          name: 'getAllPermissions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['member'] as _i13.MemberEndpoint)
                  .getAllPermissions(session),
        ),
      },
    );
    connectors['workspace'] = _i1.EndpointConnector(
      name: 'workspace',
      endpoint: endpoints['workspace']!,
      methodConnectors: {
        'getWorkspaces': _i1.MethodConnector(
          name: 'getWorkspaces',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i14.WorkspaceEndpoint)
                  .getWorkspaces(session),
        ),
        'getWorkspace': _i1.MethodConnector(
          name: 'getWorkspace',
          params: {
            'slug': _i1.ParameterDescription(
              name: 'slug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i14.WorkspaceEndpoint)
                  .getWorkspace(
                    session,
                    params['slug'],
                  ),
        ),
        'createWorkspace': _i1.MethodConnector(
          name: 'createWorkspace',
          params: {
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'slug': _i1.ParameterDescription(
              name: 'slug',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i14.WorkspaceEndpoint)
                  .createWorkspace(
                    session,
                    params['title'],
                    params['slug'],
                  ),
        ),
        'updateWorkspace': _i1.MethodConnector(
          name: 'updateWorkspace',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'slug': _i1.ParameterDescription(
              name: 'slug',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i14.WorkspaceEndpoint)
                  .updateWorkspace(
                    session,
                    params['workspaceId'],
                    params['title'],
                    params['slug'],
                  ),
        ),
        'deleteWorkspace': _i1.MethodConnector(
          name: 'deleteWorkspace',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i14.WorkspaceEndpoint)
                  .deleteWorkspace(
                    session,
                    params['workspaceId'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i15.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i19.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i20.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth'] = _i21.Endpoints()..initializeEndpoints(server);
  }
}
