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

abstract class LabelDef implements _i1.SerializableModel {
  LabelDef._({
    this.id,
    required this.boardId,
    required this.name,
    required this.colorHex,
    this.deletedAt,
  });

  factory LabelDef({
    _i1.UuidValue? id,
    required _i1.UuidValue boardId,
    required String name,
    required String colorHex,
    DateTime? deletedAt,
  }) = _LabelDefImpl;

  factory LabelDef.fromJson(Map<String, dynamic> jsonSerialization) {
    return LabelDef(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      boardId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['boardId'],
      ),
      name: jsonSerialization['name'] as String,
      colorHex: jsonSerialization['colorHex'] as String,
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue boardId;

  String name;

  String colorHex;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [LabelDef]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LabelDef copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? boardId,
    String? name,
    String? colorHex,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LabelDef',
      if (id != null) 'id': id?.toJson(),
      'boardId': boardId.toJson(),
      'name': name,
      'colorHex': colorHex,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LabelDefImpl extends LabelDef {
  _LabelDefImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue boardId,
    required String name,
    required String colorHex,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         boardId: boardId,
         name: name,
         colorHex: colorHex,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [LabelDef]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LabelDef copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? boardId,
    String? name,
    String? colorHex,
    Object? deletedAt = _Undefined,
  }) {
    return LabelDef(
      id: id is _i1.UuidValue? ? id : this.id,
      boardId: boardId ?? this.boardId,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}
