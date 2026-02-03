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

abstract class Attachment implements _i1.SerializableModel {
  Attachment._({
    this.id,
    required this.cardId,
    required this.workspaceId,
    required this.fileName,
    required this.mimeType,
    required this.size,
    required this.storageKey,
    this.fileUrl,
    required this.uploaderId,
    required this.createdAt,
    this.deletedAt,
  });

  factory Attachment({
    int? id,
    required int cardId,
    required int workspaceId,
    required String fileName,
    required String mimeType,
    required int size,
    required String storageKey,
    String? fileUrl,
    required _i1.UuidValue uploaderId,
    required DateTime createdAt,
    DateTime? deletedAt,
  }) = _AttachmentImpl;

  factory Attachment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attachment(
      id: jsonSerialization['id'] as int?,
      cardId: jsonSerialization['cardId'] as int,
      workspaceId: jsonSerialization['workspaceId'] as int,
      fileName: jsonSerialization['fileName'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      size: jsonSerialization['size'] as int,
      storageKey: jsonSerialization['storageKey'] as String,
      fileUrl: jsonSerialization['fileUrl'] as String?,
      uploaderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['uploaderId'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int cardId;

  int workspaceId;

  String fileName;

  String mimeType;

  int size;

  String storageKey;

  String? fileUrl;

  _i1.UuidValue uploaderId;

  DateTime createdAt;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [Attachment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Attachment copyWith({
    int? id,
    int? cardId,
    int? workspaceId,
    String? fileName,
    String? mimeType,
    int? size,
    String? storageKey,
    String? fileUrl,
    _i1.UuidValue? uploaderId,
    DateTime? createdAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Attachment',
      if (id != null) 'id': id,
      'cardId': cardId,
      'workspaceId': workspaceId,
      'fileName': fileName,
      'mimeType': mimeType,
      'size': size,
      'storageKey': storageKey,
      if (fileUrl != null) 'fileUrl': fileUrl,
      'uploaderId': uploaderId.toJson(),
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttachmentImpl extends Attachment {
  _AttachmentImpl({
    int? id,
    required int cardId,
    required int workspaceId,
    required String fileName,
    required String mimeType,
    required int size,
    required String storageKey,
    String? fileUrl,
    required _i1.UuidValue uploaderId,
    required DateTime createdAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         cardId: cardId,
         workspaceId: workspaceId,
         fileName: fileName,
         mimeType: mimeType,
         size: size,
         storageKey: storageKey,
         fileUrl: fileUrl,
         uploaderId: uploaderId,
         createdAt: createdAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Attachment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Attachment copyWith({
    Object? id = _Undefined,
    int? cardId,
    int? workspaceId,
    String? fileName,
    String? mimeType,
    int? size,
    String? storageKey,
    Object? fileUrl = _Undefined,
    _i1.UuidValue? uploaderId,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
  }) {
    return Attachment(
      id: id is int? ? id : this.id,
      cardId: cardId ?? this.cardId,
      workspaceId: workspaceId ?? this.workspaceId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      size: size ?? this.size,
      storageKey: storageKey ?? this.storageKey,
      fileUrl: fileUrl is String? ? fileUrl : this.fileUrl,
      uploaderId: uploaderId ?? this.uploaderId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}
