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
import 'board.dart' as _i4;
import 'board_visibility.dart' as _i5;
import 'card.dart' as _i6;
import 'card_activity.dart' as _i7;
import 'card_label.dart' as _i8;
import 'card_list.dart' as _i9;
import 'card_priority.dart' as _i10;
import 'checklist.dart' as _i11;
import 'checklist_item.dart' as _i12;
import 'comment.dart' as _i13;
import 'greetings/greeting.dart' as _i14;
import 'label_def.dart' as _i15;
import 'member_permission.dart' as _i16;
import 'member_role.dart' as _i17;
import 'member_status.dart' as _i18;
import 'password_reset_token.dart' as _i19;
import 'permission.dart' as _i20;
import 'user_preference.dart' as _i21;
import 'workspace.dart' as _i22;
import 'workspace_invite.dart' as _i23;
import 'workspace_member.dart' as _i24;
import 'package:kanew_client/src/protocol/card_activity.dart' as _i25;
import 'package:kanew_client/src/protocol/attachment.dart' as _i26;
import 'package:kanew_client/src/protocol/board.dart' as _i27;
import 'package:kanew_client/src/protocol/card.dart' as _i28;
import 'package:kanew_client/src/protocol/card_list.dart' as _i29;
import 'package:kanew_client/src/protocol/checklist.dart' as _i30;
import 'package:kanew_client/src/protocol/checklist_item.dart' as _i31;
import 'package:kanew_client/src/protocol/comment.dart' as _i32;
import 'package:kanew_client/src/protocol/label_def.dart' as _i33;
import 'package:kanew_client/src/protocol/workspace.dart' as _i34;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i35;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i36;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i37;
export 'activity_type.dart';
export 'attachment.dart';
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
    if (t == _i4.Board) {
      return _i4.Board.fromJson(data) as T;
    }
    if (t == _i5.BoardVisibility) {
      return _i5.BoardVisibility.fromJson(data) as T;
    }
    if (t == _i6.Card) {
      return _i6.Card.fromJson(data) as T;
    }
    if (t == _i7.CardActivity) {
      return _i7.CardActivity.fromJson(data) as T;
    }
    if (t == _i8.CardLabel) {
      return _i8.CardLabel.fromJson(data) as T;
    }
    if (t == _i9.CardList) {
      return _i9.CardList.fromJson(data) as T;
    }
    if (t == _i10.CardPriority) {
      return _i10.CardPriority.fromJson(data) as T;
    }
    if (t == _i11.Checklist) {
      return _i11.Checklist.fromJson(data) as T;
    }
    if (t == _i12.ChecklistItem) {
      return _i12.ChecklistItem.fromJson(data) as T;
    }
    if (t == _i13.Comment) {
      return _i13.Comment.fromJson(data) as T;
    }
    if (t == _i14.Greeting) {
      return _i14.Greeting.fromJson(data) as T;
    }
    if (t == _i15.LabelDef) {
      return _i15.LabelDef.fromJson(data) as T;
    }
    if (t == _i16.MemberPermission) {
      return _i16.MemberPermission.fromJson(data) as T;
    }
    if (t == _i17.MemberRole) {
      return _i17.MemberRole.fromJson(data) as T;
    }
    if (t == _i18.MemberStatus) {
      return _i18.MemberStatus.fromJson(data) as T;
    }
    if (t == _i19.PasswordResetToken) {
      return _i19.PasswordResetToken.fromJson(data) as T;
    }
    if (t == _i20.Permission) {
      return _i20.Permission.fromJson(data) as T;
    }
    if (t == _i21.UserPreference) {
      return _i21.UserPreference.fromJson(data) as T;
    }
    if (t == _i22.Workspace) {
      return _i22.Workspace.fromJson(data) as T;
    }
    if (t == _i23.WorkspaceInvite) {
      return _i23.WorkspaceInvite.fromJson(data) as T;
    }
    if (t == _i24.WorkspaceMember) {
      return _i24.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ActivityType?>()) {
      return (data != null ? _i2.ActivityType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Attachment?>()) {
      return (data != null ? _i3.Attachment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Board?>()) {
      return (data != null ? _i4.Board.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.BoardVisibility?>()) {
      return (data != null ? _i5.BoardVisibility.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Card?>()) {
      return (data != null ? _i6.Card.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.CardActivity?>()) {
      return (data != null ? _i7.CardActivity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.CardLabel?>()) {
      return (data != null ? _i8.CardLabel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.CardList?>()) {
      return (data != null ? _i9.CardList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.CardPriority?>()) {
      return (data != null ? _i10.CardPriority.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Checklist?>()) {
      return (data != null ? _i11.Checklist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ChecklistItem?>()) {
      return (data != null ? _i12.ChecklistItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.Comment?>()) {
      return (data != null ? _i13.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Greeting?>()) {
      return (data != null ? _i14.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.LabelDef?>()) {
      return (data != null ? _i15.LabelDef.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.MemberPermission?>()) {
      return (data != null ? _i16.MemberPermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.MemberRole?>()) {
      return (data != null ? _i17.MemberRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.MemberStatus?>()) {
      return (data != null ? _i18.MemberStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.PasswordResetToken?>()) {
      return (data != null ? _i19.PasswordResetToken.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.Permission?>()) {
      return (data != null ? _i20.Permission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.UserPreference?>()) {
      return (data != null ? _i21.UserPreference.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.Workspace?>()) {
      return (data != null ? _i22.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.WorkspaceInvite?>()) {
      return (data != null ? _i23.WorkspaceInvite.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.WorkspaceMember?>()) {
      return (data != null ? _i24.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i25.CardActivity>) {
      return (data as List)
              .map((e) => deserialize<_i25.CardActivity>(e))
              .toList()
          as T;
    }
    if (t == List<_i26.Attachment>) {
      return (data as List).map((e) => deserialize<_i26.Attachment>(e)).toList()
          as T;
    }
    if (t == List<_i27.Board>) {
      return (data as List).map((e) => deserialize<_i27.Board>(e)).toList()
          as T;
    }
    if (t == List<_i28.Card>) {
      return (data as List).map((e) => deserialize<_i28.Card>(e)).toList() as T;
    }
    if (t == List<_i29.CardList>) {
      return (data as List).map((e) => deserialize<_i29.CardList>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i30.Checklist>) {
      return (data as List).map((e) => deserialize<_i30.Checklist>(e)).toList()
          as T;
    }
    if (t == List<_i31.ChecklistItem>) {
      return (data as List)
              .map((e) => deserialize<_i31.ChecklistItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i32.Comment>) {
      return (data as List).map((e) => deserialize<_i32.Comment>(e)).toList()
          as T;
    }
    if (t == List<_i33.LabelDef>) {
      return (data as List).map((e) => deserialize<_i33.LabelDef>(e)).toList()
          as T;
    }
    if (t == List<_i34.Workspace>) {
      return (data as List).map((e) => deserialize<_i34.Workspace>(e)).toList()
          as T;
    }
    try {
      return _i35.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i36.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i37.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ActivityType => 'ActivityType',
      _i3.Attachment => 'Attachment',
      _i4.Board => 'Board',
      _i5.BoardVisibility => 'BoardVisibility',
      _i6.Card => 'Card',
      _i7.CardActivity => 'CardActivity',
      _i8.CardLabel => 'CardLabel',
      _i9.CardList => 'CardList',
      _i10.CardPriority => 'CardPriority',
      _i11.Checklist => 'Checklist',
      _i12.ChecklistItem => 'ChecklistItem',
      _i13.Comment => 'Comment',
      _i14.Greeting => 'Greeting',
      _i15.LabelDef => 'LabelDef',
      _i16.MemberPermission => 'MemberPermission',
      _i17.MemberRole => 'MemberRole',
      _i18.MemberStatus => 'MemberStatus',
      _i19.PasswordResetToken => 'PasswordResetToken',
      _i20.Permission => 'Permission',
      _i21.UserPreference => 'UserPreference',
      _i22.Workspace => 'Workspace',
      _i23.WorkspaceInvite => 'WorkspaceInvite',
      _i24.WorkspaceMember => 'WorkspaceMember',
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
      case _i4.Board():
        return 'Board';
      case _i5.BoardVisibility():
        return 'BoardVisibility';
      case _i6.Card():
        return 'Card';
      case _i7.CardActivity():
        return 'CardActivity';
      case _i8.CardLabel():
        return 'CardLabel';
      case _i9.CardList():
        return 'CardList';
      case _i10.CardPriority():
        return 'CardPriority';
      case _i11.Checklist():
        return 'Checklist';
      case _i12.ChecklistItem():
        return 'ChecklistItem';
      case _i13.Comment():
        return 'Comment';
      case _i14.Greeting():
        return 'Greeting';
      case _i15.LabelDef():
        return 'LabelDef';
      case _i16.MemberPermission():
        return 'MemberPermission';
      case _i17.MemberRole():
        return 'MemberRole';
      case _i18.MemberStatus():
        return 'MemberStatus';
      case _i19.PasswordResetToken():
        return 'PasswordResetToken';
      case _i20.Permission():
        return 'Permission';
      case _i21.UserPreference():
        return 'UserPreference';
      case _i22.Workspace():
        return 'Workspace';
      case _i23.WorkspaceInvite():
        return 'WorkspaceInvite';
      case _i24.WorkspaceMember():
        return 'WorkspaceMember';
    }
    className = _i35.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i36.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i37.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'Board') {
      return deserialize<_i4.Board>(data['data']);
    }
    if (dataClassName == 'BoardVisibility') {
      return deserialize<_i5.BoardVisibility>(data['data']);
    }
    if (dataClassName == 'Card') {
      return deserialize<_i6.Card>(data['data']);
    }
    if (dataClassName == 'CardActivity') {
      return deserialize<_i7.CardActivity>(data['data']);
    }
    if (dataClassName == 'CardLabel') {
      return deserialize<_i8.CardLabel>(data['data']);
    }
    if (dataClassName == 'CardList') {
      return deserialize<_i9.CardList>(data['data']);
    }
    if (dataClassName == 'CardPriority') {
      return deserialize<_i10.CardPriority>(data['data']);
    }
    if (dataClassName == 'Checklist') {
      return deserialize<_i11.Checklist>(data['data']);
    }
    if (dataClassName == 'ChecklistItem') {
      return deserialize<_i12.ChecklistItem>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i13.Comment>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i14.Greeting>(data['data']);
    }
    if (dataClassName == 'LabelDef') {
      return deserialize<_i15.LabelDef>(data['data']);
    }
    if (dataClassName == 'MemberPermission') {
      return deserialize<_i16.MemberPermission>(data['data']);
    }
    if (dataClassName == 'MemberRole') {
      return deserialize<_i17.MemberRole>(data['data']);
    }
    if (dataClassName == 'MemberStatus') {
      return deserialize<_i18.MemberStatus>(data['data']);
    }
    if (dataClassName == 'PasswordResetToken') {
      return deserialize<_i19.PasswordResetToken>(data['data']);
    }
    if (dataClassName == 'Permission') {
      return deserialize<_i20.Permission>(data['data']);
    }
    if (dataClassName == 'UserPreference') {
      return deserialize<_i21.UserPreference>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i22.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceInvite') {
      return deserialize<_i23.WorkspaceInvite>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i24.WorkspaceMember>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i35.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i36.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i37.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i35.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i36.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i37.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
