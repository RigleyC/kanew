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

abstract class ChecklistItem implements _i1.SerializableModel {
  ChecklistItem._({
    this.id,
    required this.checklistId,
    required this.title,
    required this.isChecked,
    required this.rank,
    this.deletedAt,
  });

  factory ChecklistItem({
    _i1.UuidValue? id,
    required _i1.UuidValue checklistId,
    required String title,
    required bool isChecked,
    required String rank,
    DateTime? deletedAt,
  }) = _ChecklistItemImpl;

  factory ChecklistItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChecklistItem(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      checklistId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['checklistId'],
      ),
      title: jsonSerialization['title'] as String,
      isChecked: jsonSerialization['isChecked'] as bool,
      rank: jsonSerialization['rank'] as String,
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue checklistId;

  String title;

  bool isChecked;

  String rank;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [ChecklistItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChecklistItem copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? checklistId,
    String? title,
    bool? isChecked,
    String? rank,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChecklistItem',
      if (id != null) 'id': id?.toJson(),
      'checklistId': checklistId.toJson(),
      'title': title,
      'isChecked': isChecked,
      'rank': rank,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChecklistItemImpl extends ChecklistItem {
  _ChecklistItemImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue checklistId,
    required String title,
    required bool isChecked,
    required String rank,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         checklistId: checklistId,
         title: title,
         isChecked: isChecked,
         rank: rank,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [ChecklistItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChecklistItem copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? checklistId,
    String? title,
    bool? isChecked,
    String? rank,
    Object? deletedAt = _Undefined,
  }) {
    return ChecklistItem(
      id: id is _i1.UuidValue? ? id : this.id,
      checklistId: checklistId ?? this.checklistId,
      title: title ?? this.title,
      isChecked: isChecked ?? this.isChecked,
      rank: rank ?? this.rank,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}
