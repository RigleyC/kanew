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

abstract class CardLabel implements _i1.SerializableModel {
  CardLabel._({
    this.id,
    required this.cardId,
    required this.labelDefId,
  });

  factory CardLabel({
    _i1.UuidValue? id,
    required _i1.UuidValue cardId,
    required _i1.UuidValue labelDefId,
  }) = _CardLabelImpl;

  factory CardLabel.fromJson(Map<String, dynamic> jsonSerialization) {
    return CardLabel(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      cardId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['cardId']),
      labelDefId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['labelDefId'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue cardId;

  _i1.UuidValue labelDefId;

  /// Returns a shallow copy of this [CardLabel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CardLabel copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? cardId,
    _i1.UuidValue? labelDefId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CardLabel',
      if (id != null) 'id': id?.toJson(),
      'cardId': cardId.toJson(),
      'labelDefId': labelDefId.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CardLabelImpl extends CardLabel {
  _CardLabelImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue cardId,
    required _i1.UuidValue labelDefId,
  }) : super._(
         id: id,
         cardId: cardId,
         labelDefId: labelDefId,
       );

  /// Returns a shallow copy of this [CardLabel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CardLabel copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? cardId,
    _i1.UuidValue? labelDefId,
  }) {
    return CardLabel(
      id: id is _i1.UuidValue? ? id : this.id,
      cardId: cardId ?? this.cardId,
      labelDefId: labelDefId ?? this.labelDefId,
    );
  }
}
