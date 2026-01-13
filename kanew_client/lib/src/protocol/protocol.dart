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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'activity_type.dart' as _i2;
import 'attachment.dart' as _i3;
import 'auth_result.dart' as _i4;
import 'auth_status.dart' as _i5;
import 'board.dart' as _i6;
import 'board_visibility.dart' as _i7;
import 'card.dart' as _i8;
import 'card_activity.dart' as _i9;
import 'card_label.dart' as _i10;
import 'card_list.dart' as _i11;
import 'card_priority.dart' as _i12;
import 'checklist.dart' as _i13;
import 'checklist_item.dart' as _i14;
import 'comment.dart' as _i15;
import 'greetings/greeting.dart' as _i16;
import 'label_def.dart' as _i17;
import 'member_permission.dart' as _i18;
import 'member_role.dart' as _i19;
import 'member_status.dart' as _i20;
import 'password_reset_token.dart' as _i21;
import 'permission.dart' as _i22;
import 'user_preference.dart' as _i23;
import 'user_verification.dart' as _i24;
import 'workspace.dart' as _i25;
import 'workspace_invite.dart' as _i26;
import 'workspace_member.dart' as _i27;
import 'package:kanew_client/src/protocol/workspace.dart' as _i28;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i29;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i30;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i31;
export 'activity_type.dart';
export 'attachment.dart';
export 'auth_result.dart';
export 'auth_status.dart';
export 'board.dart';
export 'board_visibility.dart';
export 'card.dart';
export 'card_activity.dart';
export 'card_label.dart';
export 'card_list.dart';
export 'card_priority.dart';
export 'checklist.dart';
export 'checklist_item.dart';
export 'comment.dart';
export 'greetings/greeting.dart';
export 'label_def.dart';
export 'member_permission.dart';
export 'member_role.dart';
export 'member_status.dart';
export 'password_reset_token.dart';
export 'permission.dart';
export 'user_preference.dart';
export 'user_verification.dart';
export 'workspace.dart';
export 'workspace_invite.dart';
export 'workspace_member.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.ActivityType) {
      return _i2.ActivityType.fromJson(data) as T;
    }
    if (t == _i3.Attachment) {
      return _i3.Attachment.fromJson(data) as T;
    }
    if (t == _i4.AuthResult) {
      return _i4.AuthResult.fromJson(data) as T;
    }
    if (t == _i5.AuthStatus) {
      return _i5.AuthStatus.fromJson(data) as T;
    }
    if (t == _i6.Board) {
      return _i6.Board.fromJson(data) as T;
    }
    if (t == _i7.BoardVisibility) {
      return _i7.BoardVisibility.fromJson(data) as T;
    }
    if (t == _i8.Card) {
      return _i8.Card.fromJson(data) as T;
    }
    if (t == _i9.CardActivity) {
      return _i9.CardActivity.fromJson(data) as T;
    }
    if (t == _i10.CardLabel) {
      return _i10.CardLabel.fromJson(data) as T;
    }
    if (t == _i11.CardList) {
      return _i11.CardList.fromJson(data) as T;
    }
    if (t == _i12.CardPriority) {
      return _i12.CardPriority.fromJson(data) as T;
    }
    if (t == _i13.Checklist) {
      return _i13.Checklist.fromJson(data) as T;
    }
    if (t == _i14.ChecklistItem) {
      return _i14.ChecklistItem.fromJson(data) as T;
    }
    if (t == _i15.Comment) {
      return _i15.Comment.fromJson(data) as T;
    }
    if (t == _i16.Greeting) {
      return _i16.Greeting.fromJson(data) as T;
    }
    if (t == _i17.LabelDef) {
      return _i17.LabelDef.fromJson(data) as T;
    }
    if (t == _i18.MemberPermission) {
      return _i18.MemberPermission.fromJson(data) as T;
    }
    if (t == _i19.MemberRole) {
      return _i19.MemberRole.fromJson(data) as T;
    }
    if (t == _i20.MemberStatus) {
      return _i20.MemberStatus.fromJson(data) as T;
    }
    if (t == _i21.PasswordResetToken) {
      return _i21.PasswordResetToken.fromJson(data) as T;
    }
    if (t == _i22.Permission) {
      return _i22.Permission.fromJson(data) as T;
    }
    if (t == _i23.UserPreference) {
      return _i23.UserPreference.fromJson(data) as T;
    }
    if (t == _i24.UserVerification) {
      return _i24.UserVerification.fromJson(data) as T;
    }
    if (t == _i25.Workspace) {
      return _i25.Workspace.fromJson(data) as T;
    }
    if (t == _i26.WorkspaceInvite) {
      return _i26.WorkspaceInvite.fromJson(data) as T;
    }
    if (t == _i27.WorkspaceMember) {
      return _i27.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ActivityType?>()) {
      return (data != null ? _i2.ActivityType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Attachment?>()) {
      return (data != null ? _i3.Attachment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AuthResult?>()) {
      return (data != null ? _i4.AuthResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AuthStatus?>()) {
      return (data != null ? _i5.AuthStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Board?>()) {
      return (data != null ? _i6.Board.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.BoardVisibility?>()) {
      return (data != null ? _i7.BoardVisibility.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Card?>()) {
      return (data != null ? _i8.Card.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.CardActivity?>()) {
      return (data != null ? _i9.CardActivity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.CardLabel?>()) {
      return (data != null ? _i10.CardLabel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.CardList?>()) {
      return (data != null ? _i11.CardList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.CardPriority?>()) {
      return (data != null ? _i12.CardPriority.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.Checklist?>()) {
      return (data != null ? _i13.Checklist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ChecklistItem?>()) {
      return (data != null ? _i14.ChecklistItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Comment?>()) {
      return (data != null ? _i15.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Greeting?>()) {
      return (data != null ? _i16.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.LabelDef?>()) {
      return (data != null ? _i17.LabelDef.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.MemberPermission?>()) {
      return (data != null ? _i18.MemberPermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.MemberRole?>()) {
      return (data != null ? _i19.MemberRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.MemberStatus?>()) {
      return (data != null ? _i20.MemberStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.PasswordResetToken?>()) {
      return (data != null ? _i21.PasswordResetToken.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.Permission?>()) {
      return (data != null ? _i22.Permission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.UserPreference?>()) {
      return (data != null ? _i23.UserPreference.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.UserVerification?>()) {
      return (data != null ? _i24.UserVerification.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.Workspace?>()) {
      return (data != null ? _i25.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.WorkspaceInvite?>()) {
      return (data != null ? _i26.WorkspaceInvite.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.WorkspaceMember?>()) {
      return (data != null ? _i27.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i28.Workspace>) {
      return (data as List).map((e) => deserialize<_i28.Workspace>(e)).toList()
          as T;
    }
    try {
      return _i29.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i30.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i31.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ActivityType => 'ActivityType',
      _i3.Attachment => 'Attachment',
      _i4.AuthResult => 'AuthResult',
      _i5.AuthStatus => 'AuthStatus',
      _i6.Board => 'Board',
      _i7.BoardVisibility => 'BoardVisibility',
      _i8.Card => 'Card',
      _i9.CardActivity => 'CardActivity',
      _i10.CardLabel => 'CardLabel',
      _i11.CardList => 'CardList',
      _i12.CardPriority => 'CardPriority',
      _i13.Checklist => 'Checklist',
      _i14.ChecklistItem => 'ChecklistItem',
      _i15.Comment => 'Comment',
      _i16.Greeting => 'Greeting',
      _i17.LabelDef => 'LabelDef',
      _i18.MemberPermission => 'MemberPermission',
      _i19.MemberRole => 'MemberRole',
      _i20.MemberStatus => 'MemberStatus',
      _i21.PasswordResetToken => 'PasswordResetToken',
      _i22.Permission => 'Permission',
      _i23.UserPreference => 'UserPreference',
      _i24.UserVerification => 'UserVerification',
      _i25.Workspace => 'Workspace',
      _i26.WorkspaceInvite => 'WorkspaceInvite',
      _i27.WorkspaceMember => 'WorkspaceMember',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('kanew.', '');
    }

    switch (data) {
      case _i2.ActivityType():
        return 'ActivityType';
      case _i3.Attachment():
        return 'Attachment';
      case _i4.AuthResult():
        return 'AuthResult';
      case _i5.AuthStatus():
        return 'AuthStatus';
      case _i6.Board():
        return 'Board';
      case _i7.BoardVisibility():
        return 'BoardVisibility';
      case _i8.Card():
        return 'Card';
      case _i9.CardActivity():
        return 'CardActivity';
      case _i10.CardLabel():
        return 'CardLabel';
      case _i11.CardList():
        return 'CardList';
      case _i12.CardPriority():
        return 'CardPriority';
      case _i13.Checklist():
        return 'Checklist';
      case _i14.ChecklistItem():
        return 'ChecklistItem';
      case _i15.Comment():
        return 'Comment';
      case _i16.Greeting():
        return 'Greeting';
      case _i17.LabelDef():
        return 'LabelDef';
      case _i18.MemberPermission():
        return 'MemberPermission';
      case _i19.MemberRole():
        return 'MemberRole';
      case _i20.MemberStatus():
        return 'MemberStatus';
      case _i21.PasswordResetToken():
        return 'PasswordResetToken';
      case _i22.Permission():
        return 'Permission';
      case _i23.UserPreference():
        return 'UserPreference';
      case _i24.UserVerification():
        return 'UserVerification';
      case _i25.Workspace():
        return 'Workspace';
      case _i26.WorkspaceInvite():
        return 'WorkspaceInvite';
      case _i27.WorkspaceMember():
        return 'WorkspaceMember';
    }
    className = _i29.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i30.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i31.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ActivityType') {
      return deserialize<_i2.ActivityType>(data['data']);
    }
    if (dataClassName == 'Attachment') {
      return deserialize<_i3.Attachment>(data['data']);
    }
    if (dataClassName == 'AuthResult') {
      return deserialize<_i4.AuthResult>(data['data']);
    }
    if (dataClassName == 'AuthStatus') {
      return deserialize<_i5.AuthStatus>(data['data']);
    }
    if (dataClassName == 'Board') {
      return deserialize<_i6.Board>(data['data']);
    }
    if (dataClassName == 'BoardVisibility') {
      return deserialize<_i7.BoardVisibility>(data['data']);
    }
    if (dataClassName == 'Card') {
      return deserialize<_i8.Card>(data['data']);
    }
    if (dataClassName == 'CardActivity') {
      return deserialize<_i9.CardActivity>(data['data']);
    }
    if (dataClassName == 'CardLabel') {
      return deserialize<_i10.CardLabel>(data['data']);
    }
    if (dataClassName == 'CardList') {
      return deserialize<_i11.CardList>(data['data']);
    }
    if (dataClassName == 'CardPriority') {
      return deserialize<_i12.CardPriority>(data['data']);
    }
    if (dataClassName == 'Checklist') {
      return deserialize<_i13.Checklist>(data['data']);
    }
    if (dataClassName == 'ChecklistItem') {
      return deserialize<_i14.ChecklistItem>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i15.Comment>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i16.Greeting>(data['data']);
    }
    if (dataClassName == 'LabelDef') {
      return deserialize<_i17.LabelDef>(data['data']);
    }
    if (dataClassName == 'MemberPermission') {
      return deserialize<_i18.MemberPermission>(data['data']);
    }
    if (dataClassName == 'MemberRole') {
      return deserialize<_i19.MemberRole>(data['data']);
    }
    if (dataClassName == 'MemberStatus') {
      return deserialize<_i20.MemberStatus>(data['data']);
    }
    if (dataClassName == 'PasswordResetToken') {
      return deserialize<_i21.PasswordResetToken>(data['data']);
    }
    if (dataClassName == 'Permission') {
      return deserialize<_i22.Permission>(data['data']);
    }
    if (dataClassName == 'UserPreference') {
      return deserialize<_i23.UserPreference>(data['data']);
    }
    if (dataClassName == 'UserVerification') {
      return deserialize<_i24.UserVerification>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i25.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceInvite') {
      return deserialize<_i26.WorkspaceInvite>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i27.WorkspaceMember>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i29.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i30.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i31.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
