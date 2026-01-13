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

abstract class UserVerification implements _i1.SerializableModel {
  UserVerification._({
    this.id,
    required this.userId,
    bool? emailVerified,
    DateTime? createdAt,
    this.updatedAt,
  }) : emailVerified = emailVerified ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory UserVerification({
    int? id,
    required int userId,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserVerificationImpl;

  factory UserVerification.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserVerification(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      emailVerified: jsonSerialization['emailVerified'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  bool emailVerified;

  DateTime createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [UserVerification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserVerification copyWith({
    int? id,
    int? userId,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserVerification',
      if (id != null) 'id': id,
      'userId': userId,
      'emailVerified': emailVerified,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserVerificationImpl extends UserVerification {
  _UserVerificationImpl({
    int? id,
    required int userId,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         emailVerified: emailVerified,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserVerification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserVerification copyWith({
    Object? id = _Undefined,
    int? userId,
    bool? emailVerified,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return UserVerification(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
