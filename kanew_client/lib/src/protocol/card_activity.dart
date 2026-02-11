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

abstract class CardActivity implements _i1.SerializableModel {
  CardActivity._({
    this.id,
    required this.cardId,
    required this.actorId,
    required this.type,
    this.details,
    required this.createdAt,
  });

  factory CardActivity({
    _i1.UuidValue? id,
    required _i1.UuidValue cardId,
    required _i1.UuidValue actorId,
    required _i2.ActivityType type,
    String? details,
    required DateTime createdAt,
  }) = _CardActivityImpl;

  factory CardActivity.fromJson(Map<String, dynamic> jsonSerialization) {
    return CardActivity(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      cardId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['cardId']),
      actorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['actorId'],
      ),
      type: _i2.ActivityType.fromJson((jsonSerialization['type'] as String)),
      details: jsonSerialization['details'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue cardId;

  _i1.UuidValue actorId;

  _i2.ActivityType type;

  String? details;

  DateTime createdAt;

  /// Returns a shallow copy of this [CardActivity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CardActivity copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? cardId,
    _i1.UuidValue? actorId,
    _i2.ActivityType? type,
    String? details,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CardActivity',
      if (id != null) 'id': id?.toJson(),
      'cardId': cardId.toJson(),
      'actorId': actorId.toJson(),
      'type': type.toJson(),
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CardActivityImpl extends CardActivity {
  _CardActivityImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue cardId,
    required _i1.UuidValue actorId,
    required _i2.ActivityType type,
    String? details,
    required DateTime createdAt,
  }) : super._(
         id: id,
         cardId: cardId,
         actorId: actorId,
         type: type,
         details: details,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CardActivity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CardActivity copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? cardId,
    _i1.UuidValue? actorId,
    _i2.ActivityType? type,
    Object? details = _Undefined,
    DateTime? createdAt,
  }) {
    return CardActivity(
      id: id is _i1.UuidValue? ? id : this.id,
      cardId: cardId ?? this.cardId,
      actorId: actorId ?? this.actorId,
      type: type ?? this.type,
      details: details is String? ? details : this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
