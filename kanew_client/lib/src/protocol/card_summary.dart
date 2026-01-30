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
import 'card.dart' as _i2;
import 'label_def.dart' as _i3;
import 'package:kanew_client/src/protocol/protocol.dart' as _i4;

abstract class CardSummary implements _i1.SerializableModel {
  CardSummary._({
    required this.card,
    required this.cardLabels,
    required this.checklistTotal,
    required this.checklistCompleted,
    required this.attachmentCount,
    required this.commentCount,
  });

  factory CardSummary({
    required _i2.Card card,
    required List<_i3.LabelDef> cardLabels,
    required int checklistTotal,
    required int checklistCompleted,
    required int attachmentCount,
    required int commentCount,
  }) = _CardSummaryImpl;

  factory CardSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return CardSummary(
      card: _i4.Protocol().deserialize<_i2.Card>(jsonSerialization['card']),
      cardLabels: _i4.Protocol().deserialize<List<_i3.LabelDef>>(
        jsonSerialization['cardLabels'],
      ),
      checklistTotal: jsonSerialization['checklistTotal'] as int,
      checklistCompleted: jsonSerialization['checklistCompleted'] as int,
      attachmentCount: jsonSerialization['attachmentCount'] as int,
      commentCount: jsonSerialization['commentCount'] as int,
    );
  }

  _i2.Card card;

  List<_i3.LabelDef> cardLabels;

  int checklistTotal;

  int checklistCompleted;

  int attachmentCount;

  int commentCount;

  /// Returns a shallow copy of this [CardSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CardSummary copyWith({
    _i2.Card? card,
    List<_i3.LabelDef>? cardLabels,
    int? checklistTotal,
    int? checklistCompleted,
    int? attachmentCount,
    int? commentCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CardSummary',
      'card': card.toJson(),
      'cardLabels': cardLabels.toJson(valueToJson: (v) => v.toJson()),
      'checklistTotal': checklistTotal,
      'checklistCompleted': checklistCompleted,
      'attachmentCount': attachmentCount,
      'commentCount': commentCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CardSummaryImpl extends CardSummary {
  _CardSummaryImpl({
    required _i2.Card card,
    required List<_i3.LabelDef> cardLabels,
    required int checklistTotal,
    required int checklistCompleted,
    required int attachmentCount,
    required int commentCount,
  }) : super._(
         card: card,
         cardLabels: cardLabels,
         checklistTotal: checklistTotal,
         checklistCompleted: checklistCompleted,
         attachmentCount: attachmentCount,
         commentCount: commentCount,
       );

  /// Returns a shallow copy of this [CardSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CardSummary copyWith({
    _i2.Card? card,
    List<_i3.LabelDef>? cardLabels,
    int? checklistTotal,
    int? checklistCompleted,
    int? attachmentCount,
    int? commentCount,
  }) {
    return CardSummary(
      card: card ?? this.card.copyWith(),
      cardLabels:
          cardLabels ?? this.cardLabels.map((e0) => e0.copyWith()).toList(),
      checklistTotal: checklistTotal ?? this.checklistTotal,
      checklistCompleted: checklistCompleted ?? this.checklistCompleted,
      attachmentCount: attachmentCount ?? this.attachmentCount,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}
