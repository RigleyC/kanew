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
import 'board_context.dart' as _i5;
import 'board_visibility.dart' as _i6;
import 'board_with_cards.dart' as _i7;
import 'card.dart' as _i8;
import 'card_activity.dart' as _i9;
import 'card_detail.dart' as _i10;
import 'card_label.dart' as _i11;
import 'card_list.dart' as _i12;
import 'card_priority.dart' as _i13;
import 'card_summary.dart' as _i14;
import 'checklist.dart' as _i15;
import 'checklist_item.dart' as _i16;
import 'checklist_with_items.dart' as _i17;
import 'comment.dart' as _i18;
import 'greetings/greeting.dart' as _i19;
import 'label_def.dart' as _i20;
import 'member_permission.dart' as _i21;
import 'member_role.dart' as _i22;
import 'member_status.dart' as _i23;
import 'member_with_user.dart' as _i24;
import 'password_reset_token.dart' as _i25;
import 'permission.dart' as _i26;
import 'permission_info.dart' as _i27;
import 'user_preference.dart' as _i28;
import 'workspace.dart' as _i29;
import 'workspace_invite.dart' as _i30;
import 'workspace_member.dart' as _i31;
import 'package:kanew_client/src/protocol/card_activity.dart' as _i32;
import 'package:kanew_client/src/protocol/attachment.dart' as _i33;
import 'package:kanew_client/src/protocol/board.dart' as _i34;
import 'package:kanew_client/src/protocol/card.dart' as _i35;
import 'package:kanew_client/src/protocol/card_detail.dart' as _i36;
import 'package:kanew_client/src/protocol/card_list.dart' as _i37;
import 'package:kanew_client/src/protocol/checklist.dart' as _i38;
import 'package:kanew_client/src/protocol/checklist_item.dart' as _i39;
import 'package:kanew_client/src/protocol/comment.dart' as _i40;
import 'package:kanew_client/src/protocol/workspace_invite.dart' as _i41;
import 'package:kanew_client/src/protocol/label_def.dart' as _i42;
import 'package:kanew_client/src/protocol/member_with_user.dart' as _i43;
import 'package:kanew_client/src/protocol/permission_info.dart' as _i44;
import 'package:kanew_client/src/protocol/permission.dart' as _i45;
import 'package:kanew_client/src/protocol/workspace.dart' as _i46;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i47;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i48;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i49;
export 'activity_type.dart';
export 'attachment.dart';
export 'board.dart';
export 'board_context.dart';
export 'board_visibility.dart';
export 'board_with_cards.dart';
export 'card.dart';
export 'card_activity.dart';
export 'card_detail.dart';
export 'card_label.dart';
export 'card_list.dart';
export 'card_priority.dart';
export 'card_summary.dart';
export 'checklist.dart';
export 'checklist_item.dart';
export 'checklist_with_items.dart';
export 'comment.dart';
export 'greetings/greeting.dart';
export 'label_def.dart';
export 'member_permission.dart';
export 'member_role.dart';
export 'member_status.dart';
export 'member_with_user.dart';
export 'password_reset_token.dart';
export 'permission.dart';
export 'permission_info.dart';
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
    if (t == _i5.BoardContext) {
      return _i5.BoardContext.fromJson(data) as T;
    }
    if (t == _i6.BoardVisibility) {
      return _i6.BoardVisibility.fromJson(data) as T;
    }
    if (t == _i7.BoardWithCards) {
      return _i7.BoardWithCards.fromJson(data) as T;
    }
    if (t == _i8.Card) {
      return _i8.Card.fromJson(data) as T;
    }
    if (t == _i9.CardActivity) {
      return _i9.CardActivity.fromJson(data) as T;
    }
    if (t == _i10.CardDetail) {
      return _i10.CardDetail.fromJson(data) as T;
    }
    if (t == _i11.CardLabel) {
      return _i11.CardLabel.fromJson(data) as T;
    }
    if (t == _i12.CardList) {
      return _i12.CardList.fromJson(data) as T;
    }
    if (t == _i13.CardPriority) {
      return _i13.CardPriority.fromJson(data) as T;
    }
    if (t == _i14.CardSummary) {
      return _i14.CardSummary.fromJson(data) as T;
    }
    if (t == _i15.Checklist) {
      return _i15.Checklist.fromJson(data) as T;
    }
    if (t == _i16.ChecklistItem) {
      return _i16.ChecklistItem.fromJson(data) as T;
    }
    if (t == _i17.ChecklistWithItems) {
      return _i17.ChecklistWithItems.fromJson(data) as T;
    }
    if (t == _i18.Comment) {
      return _i18.Comment.fromJson(data) as T;
    }
    if (t == _i19.Greeting) {
      return _i19.Greeting.fromJson(data) as T;
    }
    if (t == _i20.LabelDef) {
      return _i20.LabelDef.fromJson(data) as T;
    }
    if (t == _i21.MemberPermission) {
      return _i21.MemberPermission.fromJson(data) as T;
    }
    if (t == _i22.MemberRole) {
      return _i22.MemberRole.fromJson(data) as T;
    }
    if (t == _i23.MemberStatus) {
      return _i23.MemberStatus.fromJson(data) as T;
    }
    if (t == _i24.MemberWithUser) {
      return _i24.MemberWithUser.fromJson(data) as T;
    }
    if (t == _i25.PasswordResetToken) {
      return _i25.PasswordResetToken.fromJson(data) as T;
    }
    if (t == _i26.Permission) {
      return _i26.Permission.fromJson(data) as T;
    }
    if (t == _i27.PermissionInfo) {
      return _i27.PermissionInfo.fromJson(data) as T;
    }
    if (t == _i28.UserPreference) {
      return _i28.UserPreference.fromJson(data) as T;
    }
    if (t == _i29.Workspace) {
      return _i29.Workspace.fromJson(data) as T;
    }
    if (t == _i30.WorkspaceInvite) {
      return _i30.WorkspaceInvite.fromJson(data) as T;
    }
    if (t == _i31.WorkspaceMember) {
      return _i31.WorkspaceMember.fromJson(data) as T;
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
    if (t == _i1.getType<_i5.BoardContext?>()) {
      return (data != null ? _i5.BoardContext.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.BoardVisibility?>()) {
      return (data != null ? _i6.BoardVisibility.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.BoardWithCards?>()) {
      return (data != null ? _i7.BoardWithCards.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Card?>()) {
      return (data != null ? _i8.Card.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.CardActivity?>()) {
      return (data != null ? _i9.CardActivity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.CardDetail?>()) {
      return (data != null ? _i10.CardDetail.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.CardLabel?>()) {
      return (data != null ? _i11.CardLabel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.CardList?>()) {
      return (data != null ? _i12.CardList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.CardPriority?>()) {
      return (data != null ? _i13.CardPriority.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.CardSummary?>()) {
      return (data != null ? _i14.CardSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Checklist?>()) {
      return (data != null ? _i15.Checklist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.ChecklistItem?>()) {
      return (data != null ? _i16.ChecklistItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.ChecklistWithItems?>()) {
      return (data != null ? _i17.ChecklistWithItems.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.Comment?>()) {
      return (data != null ? _i18.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.Greeting?>()) {
      return (data != null ? _i19.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.LabelDef?>()) {
      return (data != null ? _i20.LabelDef.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.MemberPermission?>()) {
      return (data != null ? _i21.MemberPermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.MemberRole?>()) {
      return (data != null ? _i22.MemberRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.MemberStatus?>()) {
      return (data != null ? _i23.MemberStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.MemberWithUser?>()) {
      return (data != null ? _i24.MemberWithUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.PasswordResetToken?>()) {
      return (data != null ? _i25.PasswordResetToken.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.Permission?>()) {
      return (data != null ? _i26.Permission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.PermissionInfo?>()) {
      return (data != null ? _i27.PermissionInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.UserPreference?>()) {
      return (data != null ? _i28.UserPreference.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.Workspace?>()) {
      return (data != null ? _i29.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.WorkspaceInvite?>()) {
      return (data != null ? _i30.WorkspaceInvite.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.WorkspaceMember?>()) {
      return (data != null ? _i31.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == List<_i12.CardList>) {
      return (data as List).map((e) => deserialize<_i12.CardList>(e)).toList()
          as T;
    }
    if (t == List<_i20.LabelDef>) {
      return (data as List).map((e) => deserialize<_i20.LabelDef>(e)).toList()
          as T;
    }
    if (t == List<_i31.WorkspaceMember>) {
      return (data as List)
              .map((e) => deserialize<_i31.WorkspaceMember>(e))
              .toList()
          as T;
    }
    if (t == List<_i14.CardSummary>) {
      return (data as List)
              .map((e) => deserialize<_i14.CardSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i17.ChecklistWithItems>) {
      return (data as List)
              .map((e) => deserialize<_i17.ChecklistWithItems>(e))
              .toList()
          as T;
    }
    if (t == List<_i3.Attachment>) {
      return (data as List).map((e) => deserialize<_i3.Attachment>(e)).toList()
          as T;
    }
    if (t == List<_i18.Comment>) {
      return (data as List).map((e) => deserialize<_i18.Comment>(e)).toList()
          as T;
    }
    if (t == List<_i9.CardActivity>) {
      return (data as List)
              .map((e) => deserialize<_i9.CardActivity>(e))
              .toList()
          as T;
    }
    if (t == List<_i16.ChecklistItem>) {
      return (data as List)
              .map((e) => deserialize<_i16.ChecklistItem>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i32.CardActivity>) {
      return (data as List)
              .map((e) => deserialize<_i32.CardActivity>(e))
              .toList()
          as T;
    }
    if (t == List<_i33.Attachment>) {
      return (data as List).map((e) => deserialize<_i33.Attachment>(e)).toList()
          as T;
    }
    if (t == List<_i34.Board>) {
      return (data as List).map((e) => deserialize<_i34.Board>(e)).toList()
          as T;
    }
    if (t == List<_i35.Card>) {
      return (data as List).map((e) => deserialize<_i35.Card>(e)).toList() as T;
    }
    if (t == List<_i36.CardDetail>) {
      return (data as List).map((e) => deserialize<_i36.CardDetail>(e)).toList()
          as T;
    }
    if (t == List<_i37.CardList>) {
      return (data as List).map((e) => deserialize<_i37.CardList>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i38.Checklist>) {
      return (data as List).map((e) => deserialize<_i38.Checklist>(e)).toList()
          as T;
    }
    if (t == List<_i39.ChecklistItem>) {
      return (data as List)
              .map((e) => deserialize<_i39.ChecklistItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i40.Comment>) {
      return (data as List).map((e) => deserialize<_i40.Comment>(e)).toList()
          as T;
    }
    if (t == List<_i41.WorkspaceInvite>) {
      return (data as List)
              .map((e) => deserialize<_i41.WorkspaceInvite>(e))
              .toList()
          as T;
    }
    if (t == List<_i42.LabelDef>) {
      return (data as List).map((e) => deserialize<_i42.LabelDef>(e)).toList()
          as T;
    }
    if (t == List<_i43.MemberWithUser>) {
      return (data as List)
              .map((e) => deserialize<_i43.MemberWithUser>(e))
              .toList()
          as T;
    }
    if (t == List<_i44.PermissionInfo>) {
      return (data as List)
              .map((e) => deserialize<_i44.PermissionInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i45.Permission>) {
      return (data as List).map((e) => deserialize<_i45.Permission>(e)).toList()
          as T;
    }
    if (t == List<_i46.Workspace>) {
      return (data as List).map((e) => deserialize<_i46.Workspace>(e)).toList()
          as T;
    }
    try {
      return _i47.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i48.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i49.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ActivityType => 'ActivityType',
      _i3.Attachment => 'Attachment',
      _i4.Board => 'Board',
      _i5.BoardContext => 'BoardContext',
      _i6.BoardVisibility => 'BoardVisibility',
      _i7.BoardWithCards => 'BoardWithCards',
      _i8.Card => 'Card',
      _i9.CardActivity => 'CardActivity',
      _i10.CardDetail => 'CardDetail',
      _i11.CardLabel => 'CardLabel',
      _i12.CardList => 'CardList',
      _i13.CardPriority => 'CardPriority',
      _i14.CardSummary => 'CardSummary',
      _i15.Checklist => 'Checklist',
      _i16.ChecklistItem => 'ChecklistItem',
      _i17.ChecklistWithItems => 'ChecklistWithItems',
      _i18.Comment => 'Comment',
      _i19.Greeting => 'Greeting',
      _i20.LabelDef => 'LabelDef',
      _i21.MemberPermission => 'MemberPermission',
      _i22.MemberRole => 'MemberRole',
      _i23.MemberStatus => 'MemberStatus',
      _i24.MemberWithUser => 'MemberWithUser',
      _i25.PasswordResetToken => 'PasswordResetToken',
      _i26.Permission => 'Permission',
      _i27.PermissionInfo => 'PermissionInfo',
      _i28.UserPreference => 'UserPreference',
      _i29.Workspace => 'Workspace',
      _i30.WorkspaceInvite => 'WorkspaceInvite',
      _i31.WorkspaceMember => 'WorkspaceMember',
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
      case _i5.BoardContext():
        return 'BoardContext';
      case _i6.BoardVisibility():
        return 'BoardVisibility';
      case _i7.BoardWithCards():
        return 'BoardWithCards';
      case _i8.Card():
        return 'Card';
      case _i9.CardActivity():
        return 'CardActivity';
      case _i10.CardDetail():
        return 'CardDetail';
      case _i11.CardLabel():
        return 'CardLabel';
      case _i12.CardList():
        return 'CardList';
      case _i13.CardPriority():
        return 'CardPriority';
      case _i14.CardSummary():
        return 'CardSummary';
      case _i15.Checklist():
        return 'Checklist';
      case _i16.ChecklistItem():
        return 'ChecklistItem';
      case _i17.ChecklistWithItems():
        return 'ChecklistWithItems';
      case _i18.Comment():
        return 'Comment';
      case _i19.Greeting():
        return 'Greeting';
      case _i20.LabelDef():
        return 'LabelDef';
      case _i21.MemberPermission():
        return 'MemberPermission';
      case _i22.MemberRole():
        return 'MemberRole';
      case _i23.MemberStatus():
        return 'MemberStatus';
      case _i24.MemberWithUser():
        return 'MemberWithUser';
      case _i25.PasswordResetToken():
        return 'PasswordResetToken';
      case _i26.Permission():
        return 'Permission';
      case _i27.PermissionInfo():
        return 'PermissionInfo';
      case _i28.UserPreference():
        return 'UserPreference';
      case _i29.Workspace():
        return 'Workspace';
      case _i30.WorkspaceInvite():
        return 'WorkspaceInvite';
      case _i31.WorkspaceMember():
        return 'WorkspaceMember';
    }
    className = _i47.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i48.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i49.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'BoardContext') {
      return deserialize<_i5.BoardContext>(data['data']);
    }
    if (dataClassName == 'BoardVisibility') {
      return deserialize<_i6.BoardVisibility>(data['data']);
    }
    if (dataClassName == 'BoardWithCards') {
      return deserialize<_i7.BoardWithCards>(data['data']);
    }
    if (dataClassName == 'Card') {
      return deserialize<_i8.Card>(data['data']);
    }
    if (dataClassName == 'CardActivity') {
      return deserialize<_i9.CardActivity>(data['data']);
    }
    if (dataClassName == 'CardDetail') {
      return deserialize<_i10.CardDetail>(data['data']);
    }
    if (dataClassName == 'CardLabel') {
      return deserialize<_i11.CardLabel>(data['data']);
    }
    if (dataClassName == 'CardList') {
      return deserialize<_i12.CardList>(data['data']);
    }
    if (dataClassName == 'CardPriority') {
      return deserialize<_i13.CardPriority>(data['data']);
    }
    if (dataClassName == 'CardSummary') {
      return deserialize<_i14.CardSummary>(data['data']);
    }
    if (dataClassName == 'Checklist') {
      return deserialize<_i15.Checklist>(data['data']);
    }
    if (dataClassName == 'ChecklistItem') {
      return deserialize<_i16.ChecklistItem>(data['data']);
    }
    if (dataClassName == 'ChecklistWithItems') {
      return deserialize<_i17.ChecklistWithItems>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i18.Comment>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i19.Greeting>(data['data']);
    }
    if (dataClassName == 'LabelDef') {
      return deserialize<_i20.LabelDef>(data['data']);
    }
    if (dataClassName == 'MemberPermission') {
      return deserialize<_i21.MemberPermission>(data['data']);
    }
    if (dataClassName == 'MemberRole') {
      return deserialize<_i22.MemberRole>(data['data']);
    }
    if (dataClassName == 'MemberStatus') {
      return deserialize<_i23.MemberStatus>(data['data']);
    }
    if (dataClassName == 'MemberWithUser') {
      return deserialize<_i24.MemberWithUser>(data['data']);
    }
    if (dataClassName == 'PasswordResetToken') {
      return deserialize<_i25.PasswordResetToken>(data['data']);
    }
    if (dataClassName == 'Permission') {
      return deserialize<_i26.Permission>(data['data']);
    }
    if (dataClassName == 'PermissionInfo') {
      return deserialize<_i27.PermissionInfo>(data['data']);
    }
    if (dataClassName == 'UserPreference') {
      return deserialize<_i28.UserPreference>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i29.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceInvite') {
      return deserialize<_i30.WorkspaceInvite>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i31.WorkspaceMember>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i47.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i48.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i49.Protocol().deserializeByClassName(data);
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
      return _i47.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i48.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i49.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
