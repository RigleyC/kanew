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
import 'board_event_type.dart' as _i2;

abstract class BoardEvent implements _i1.SerializableModel {
  BoardEvent._({
    required this.eventType,
    required this.boardId,
    this.listId,
    this.cardId,
    this.payload,
    required this.timestamp,
    required this.actorId,
  });

  factory BoardEvent({
    required _i2.BoardEventType eventType,
    required _i1.UuidValue boardId,
    _i1.UuidValue? listId,
    _i1.UuidValue? cardId,
    String? payload,
    required DateTime timestamp,
    required _i1.UuidValue actorId,
  }) = _BoardEventImpl;

  factory BoardEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardEvent(
      eventType: _i2.BoardEventType.fromJson(
        (jsonSerialization['eventType'] as String),
      ),
      boardId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['boardId'],
      ),
      listId: jsonSerialization['listId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['listId']),
      cardId: jsonSerialization['cardId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['cardId']),
      payload: jsonSerialization['payload'] as String?,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      actorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['actorId'],
      ),
    );
  }

  _i2.BoardEventType eventType;

  _i1.UuidValue boardId;

  _i1.UuidValue? listId;

  _i1.UuidValue? cardId;

  String? payload;

  DateTime timestamp;

  _i1.UuidValue actorId;

  /// Returns a shallow copy of this [BoardEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardEvent copyWith({
    _i2.BoardEventType? eventType,
    _i1.UuidValue? boardId,
    _i1.UuidValue? listId,
    _i1.UuidValue? cardId,
    String? payload,
    DateTime? timestamp,
    _i1.UuidValue? actorId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BoardEvent',
      'eventType': eventType.toJson(),
      'boardId': boardId.toJson(),
      if (listId != null) 'listId': listId?.toJson(),
      if (cardId != null) 'cardId': cardId?.toJson(),
      if (payload != null) 'payload': payload,
      'timestamp': timestamp.toJson(),
      'actorId': actorId.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardEventImpl extends BoardEvent {
  _BoardEventImpl({
    required _i2.BoardEventType eventType,
    required _i1.UuidValue boardId,
    _i1.UuidValue? listId,
    _i1.UuidValue? cardId,
    String? payload,
    required DateTime timestamp,
    required _i1.UuidValue actorId,
  }) : super._(
         eventType: eventType,
         boardId: boardId,
         listId: listId,
         cardId: cardId,
         payload: payload,
         timestamp: timestamp,
         actorId: actorId,
       );

  /// Returns a shallow copy of this [BoardEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardEvent copyWith({
    _i2.BoardEventType? eventType,
    _i1.UuidValue? boardId,
    Object? listId = _Undefined,
    Object? cardId = _Undefined,
    Object? payload = _Undefined,
    DateTime? timestamp,
    _i1.UuidValue? actorId,
  }) {
    return BoardEvent(
      eventType: eventType ?? this.eventType,
      boardId: boardId ?? this.boardId,
      listId: listId is _i1.UuidValue? ? listId : this.listId,
      cardId: cardId is _i1.UuidValue? ? cardId : this.cardId,
      payload: payload is String? ? payload : this.payload,
      timestamp: timestamp ?? this.timestamp,
      actorId: actorId ?? this.actorId,
    );
  }
}
