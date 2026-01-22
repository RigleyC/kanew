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
import '../endpoints/label_endpoint.dart' as _i11;
import '../endpoints/workspace_endpoint.dart' as _i12;
import '../greetings/greeting_endpoint.dart' as _i13;
import 'dart:typed_data' as _i14;
import 'package:kanew_server/src/generated/card_priority.dart' as _i15;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i16;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i17;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i18;

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
      'label': _i11.LabelEndpoint()
        ..initialize(
          server,
          'label',
          null,
        ),
      'workspace': _i12.WorkspaceEndpoint()
        ..initialize(
          server,
          'workspace',
          null,
        ),
      'greeting': _i13.GreetingEndpoint()
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
              type: _i1.getType<_i14.ByteData>(),
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
        'getCardsByBoard': _i1.MethodConnector(
          name: 'getCardsByBoard',
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
                  (endpoints['card'] as _i7.CardEndpoint).getCardsByBoard(
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
              type: _i1.getType<_i15.CardPriority>(),
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
              type: _i1.getType<_i15.CardPriority?>(),
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
              type: _i1.getType<_i15.CardPriority?>(),
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
              ) async => (endpoints['label'] as _i11.LabelEndpoint).getLabels(
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
              ) async => (endpoints['label'] as _i11.LabelEndpoint).createLabel(
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
              ) async => (endpoints['label'] as _i11.LabelEndpoint).updateLabel(
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
              ) async => (endpoints['label'] as _i11.LabelEndpoint).deleteLabel(
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
              ) async => (endpoints['label'] as _i11.LabelEndpoint).attachLabel(
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
              ) async => (endpoints['label'] as _i11.LabelEndpoint).detachLabel(
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
                  (endpoints['label'] as _i11.LabelEndpoint).getCardLabels(
                    session,
                    params['cardId'],
                  ),
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
              ) async => (endpoints['workspace'] as _i12.WorkspaceEndpoint)
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
              ) async => (endpoints['workspace'] as _i12.WorkspaceEndpoint)
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
              ) async => (endpoints['workspace'] as _i12.WorkspaceEndpoint)
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
              ) async => (endpoints['workspace'] as _i12.WorkspaceEndpoint)
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
              ) async => (endpoints['workspace'] as _i12.WorkspaceEndpoint)
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
              ) async => (endpoints['greeting'] as _i13.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i16.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i17.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth'] = _i18.Endpoints()..initializeEndpoints(server);
  }
}
