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
import 'card_list.dart' as _i3;
import 'checklist_with_items.dart' as _i4;
import 'attachment.dart' as _i5;
import 'label_def.dart' as _i6;
import 'comment.dart' as _i7;
import 'card_activity.dart' as _i8;
import 'package:kanew_client/src/protocol/protocol.dart' as _i9;

abstract class CardDetail implements _i1.SerializableModel {
  CardDetail._({
    required this.card,
    required this.currentList,
    required this.checklists,
    required this.attachments,
    required this.cardLabels,
    required this.recentComments,
    required this.totalComments,
    required this.recentActivities,
    required this.totalActivities,
    required this.canEdit,
  });

  factory CardDetail({
    required _i2.Card card,
    required _i3.CardList currentList,
    required List<_i4.ChecklistWithItems> checklists,
    required List<_i5.Attachment> attachments,
    required List<_i6.LabelDef> cardLabels,
    required List<_i7.Comment> recentComments,
    required int totalComments,
    required List<_i8.CardActivity> recentActivities,
    required int totalActivities,
    required bool canEdit,
  }) = _CardDetailImpl;

  factory CardDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return CardDetail(
      card: _i9.Protocol().deserialize<_i2.Card>(jsonSerialization['card']),
      currentList: _i9.Protocol().deserialize<_i3.CardList>(
        jsonSerialization['currentList'],
      ),
      checklists: _i9.Protocol().deserialize<List<_i4.ChecklistWithItems>>(
        jsonSerialization['checklists'],
      ),
      attachments: _i9.Protocol().deserialize<List<_i5.Attachment>>(
        jsonSerialization['attachments'],
      ),
      cardLabels: _i9.Protocol().deserialize<List<_i6.LabelDef>>(
        jsonSerialization['cardLabels'],
      ),
      recentComments: _i9.Protocol().deserialize<List<_i7.Comment>>(
        jsonSerialization['recentComments'],
      ),
      totalComments: jsonSerialization['totalComments'] as int,
      recentActivities: _i9.Protocol().deserialize<List<_i8.CardActivity>>(
        jsonSerialization['recentActivities'],
      ),
      totalActivities: jsonSerialization['totalActivities'] as int,
      canEdit: jsonSerialization['canEdit'] as bool,
    );
  }

  _i2.Card card;

  _i3.CardList currentList;

  List<_i4.ChecklistWithItems> checklists;

  List<_i5.Attachment> attachments;

  List<_i6.LabelDef> cardLabels;

  List<_i7.Comment> recentComments;

  int totalComments;

  List<_i8.CardActivity> recentActivities;

  int totalActivities;

  bool canEdit;

  /// Returns a shallow copy of this [CardDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CardDetail copyWith({
    _i2.Card? card,
    _i3.CardList? currentList,
    List<_i4.ChecklistWithItems>? checklists,
    List<_i5.Attachment>? attachments,
    List<_i6.LabelDef>? cardLabels,
    List<_i7.Comment>? recentComments,
    int? totalComments,
    List<_i8.CardActivity>? recentActivities,
    int? totalActivities,
    bool? canEdit,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CardDetail',
      'card': card.toJson(),
      'currentList': currentList.toJson(),
      'checklists': checklists.toJson(valueToJson: (v) => v.toJson()),
      'attachments': attachments.toJson(valueToJson: (v) => v.toJson()),
      'cardLabels': cardLabels.toJson(valueToJson: (v) => v.toJson()),
      'recentComments': recentComments.toJson(valueToJson: (v) => v.toJson()),
      'totalComments': totalComments,
      'recentActivities': recentActivities.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'totalActivities': totalActivities,
      'canEdit': canEdit,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CardDetailImpl extends CardDetail {
  _CardDetailImpl({
    required _i2.Card card,
    required _i3.CardList currentList,
    required List<_i4.ChecklistWithItems> checklists,
    required List<_i5.Attachment> attachments,
    required List<_i6.LabelDef> cardLabels,
    required List<_i7.Comment> recentComments,
    required int totalComments,
    required List<_i8.CardActivity> recentActivities,
    required int totalActivities,
    required bool canEdit,
  }) : super._(
         card: card,
         currentList: currentList,
         checklists: checklists,
         attachments: attachments,
         cardLabels: cardLabels,
         recentComments: recentComments,
         totalComments: totalComments,
         recentActivities: recentActivities,
         totalActivities: totalActivities,
         canEdit: canEdit,
       );

  /// Returns a shallow copy of this [CardDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CardDetail copyWith({
    _i2.Card? card,
    _i3.CardList? currentList,
    List<_i4.ChecklistWithItems>? checklists,
    List<_i5.Attachment>? attachments,
    List<_i6.LabelDef>? cardLabels,
    List<_i7.Comment>? recentComments,
    int? totalComments,
    List<_i8.CardActivity>? recentActivities,
    int? totalActivities,
    bool? canEdit,
  }) {
    return CardDetail(
      card: card ?? this.card.copyWith(),
      currentList: currentList ?? this.currentList.copyWith(),
      checklists:
          checklists ?? this.checklists.map((e0) => e0.copyWith()).toList(),
      attachments:
          attachments ?? this.attachments.map((e0) => e0.copyWith()).toList(),
      cardLabels:
          cardLabels ?? this.cardLabels.map((e0) => e0.copyWith()).toList(),
      recentComments:
          recentComments ??
          this.recentComments.map((e0) => e0.copyWith()).toList(),
      totalComments: totalComments ?? this.totalComments,
      recentActivities:
          recentActivities ??
          this.recentActivities.map((e0) => e0.copyWith()).toList(),
      totalActivities: totalActivities ?? this.totalActivities,
      canEdit: canEdit ?? this.canEdit,
    );
  }
}
