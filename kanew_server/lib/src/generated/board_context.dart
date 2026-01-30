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
import 'board.dart' as _i2;
import 'workspace.dart' as _i3;
import 'card_list.dart' as _i4;
import 'label_def.dart' as _i5;
import 'workspace_member.dart' as _i6;
import 'package:kanew_server/src/generated/protocol.dart' as _i7;

abstract class BoardContext
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  BoardContext._({
    required this.board,
    required this.workspace,
    required this.lists,
    required this.labels,
    required this.members,
  });

  factory BoardContext({
    required _i2.Board board,
    required _i3.Workspace workspace,
    required List<_i4.CardList> lists,
    required List<_i5.LabelDef> labels,
    required List<_i6.WorkspaceMember> members,
  }) = _BoardContextImpl;

  factory BoardContext.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardContext(
      board: _i7.Protocol().deserialize<_i2.Board>(jsonSerialization['board']),
      workspace: _i7.Protocol().deserialize<_i3.Workspace>(
        jsonSerialization['workspace'],
      ),
      lists: _i7.Protocol().deserialize<List<_i4.CardList>>(
        jsonSerialization['lists'],
      ),
      labels: _i7.Protocol().deserialize<List<_i5.LabelDef>>(
        jsonSerialization['labels'],
      ),
      members: _i7.Protocol().deserialize<List<_i6.WorkspaceMember>>(
        jsonSerialization['members'],
      ),
    );
  }

  _i2.Board board;

  _i3.Workspace workspace;

  List<_i4.CardList> lists;

  List<_i5.LabelDef> labels;

  List<_i6.WorkspaceMember> members;

  /// Returns a shallow copy of this [BoardContext]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardContext copyWith({
    _i2.Board? board,
    _i3.Workspace? workspace,
    List<_i4.CardList>? lists,
    List<_i5.LabelDef>? labels,
    List<_i6.WorkspaceMember>? members,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BoardContext',
      'board': board.toJson(),
      'workspace': workspace.toJson(),
      'lists': lists.toJson(valueToJson: (v) => v.toJson()),
      'labels': labels.toJson(valueToJson: (v) => v.toJson()),
      'members': members.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BoardContext',
      'board': board.toJsonForProtocol(),
      'workspace': workspace.toJsonForProtocol(),
      'lists': lists.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'labels': labels.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'members': members.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _BoardContextImpl extends BoardContext {
  _BoardContextImpl({
    required _i2.Board board,
    required _i3.Workspace workspace,
    required List<_i4.CardList> lists,
    required List<_i5.LabelDef> labels,
    required List<_i6.WorkspaceMember> members,
  }) : super._(
         board: board,
         workspace: workspace,
         lists: lists,
         labels: labels,
         members: members,
       );

  /// Returns a shallow copy of this [BoardContext]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardContext copyWith({
    _i2.Board? board,
    _i3.Workspace? workspace,
    List<_i4.CardList>? lists,
    List<_i5.LabelDef>? labels,
    List<_i6.WorkspaceMember>? members,
  }) {
    return BoardContext(
      board: board ?? this.board.copyWith(),
      workspace: workspace ?? this.workspace.copyWith(),
      lists: lists ?? this.lists.map((e0) => e0.copyWith()).toList(),
      labels: labels ?? this.labels.map((e0) => e0.copyWith()).toList(),
      members: members ?? this.members.map((e0) => e0.copyWith()).toList(),
    );
  }
}
