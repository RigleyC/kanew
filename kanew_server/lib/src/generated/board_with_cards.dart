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
import 'board_context.dart' as _i2;
import 'card_summary.dart' as _i3;
import 'package:kanew_server/src/generated/protocol.dart' as _i4;

abstract class BoardWithCards
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  BoardWithCards._({
    required this.context,
    required this.cards,
  });

  factory BoardWithCards({
    required _i2.BoardContext context,
    required List<_i3.CardSummary> cards,
  }) = _BoardWithCardsImpl;

  factory BoardWithCards.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardWithCards(
      context: _i4.Protocol().deserialize<_i2.BoardContext>(
        jsonSerialization['context'],
      ),
      cards: _i4.Protocol().deserialize<List<_i3.CardSummary>>(
        jsonSerialization['cards'],
      ),
    );
  }

  _i2.BoardContext context;

  List<_i3.CardSummary> cards;

  /// Returns a shallow copy of this [BoardWithCards]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardWithCards copyWith({
    _i2.BoardContext? context,
    List<_i3.CardSummary>? cards,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BoardWithCards',
      'context': context.toJson(),
      'cards': cards.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BoardWithCards',
      'context': context.toJsonForProtocol(),
      'cards': cards.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _BoardWithCardsImpl extends BoardWithCards {
  _BoardWithCardsImpl({
    required _i2.BoardContext context,
    required List<_i3.CardSummary> cards,
  }) : super._(
         context: context,
         cards: cards,
       );

  /// Returns a shallow copy of this [BoardWithCards]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardWithCards copyWith({
    _i2.BoardContext? context,
    List<_i3.CardSummary>? cards,
  }) {
    return BoardWithCards(
      context: context ?? this.context.copyWith(),
      cards: cards ?? this.cards.map((e0) => e0.copyWith()).toList(),
    );
  }
}
