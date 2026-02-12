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

enum BoardEventType implements _i1.SerializableModel {
  cardCreated,
  cardUpdated,
  cardMoved,
  cardDeleted,
  cardArchived,
  listCreated,
  listUpdated,
  listReordered,
  listDeleted,
  listArchived,
  labelCreated,
  labelUpdated,
  labelDeleted,
  cardLabelsUpdated,
  checklistItemsReordered,
  boardUpdated,
  boardDeleted;

  static BoardEventType fromJson(String name) {
    switch (name) {
      case 'cardCreated':
        return BoardEventType.cardCreated;
      case 'cardUpdated':
        return BoardEventType.cardUpdated;
      case 'cardMoved':
        return BoardEventType.cardMoved;
      case 'cardDeleted':
        return BoardEventType.cardDeleted;
      case 'cardArchived':
        return BoardEventType.cardArchived;
      case 'listCreated':
        return BoardEventType.listCreated;
      case 'listUpdated':
        return BoardEventType.listUpdated;
      case 'listReordered':
        return BoardEventType.listReordered;
      case 'listDeleted':
        return BoardEventType.listDeleted;
      case 'listArchived':
        return BoardEventType.listArchived;
      case 'labelCreated':
        return BoardEventType.labelCreated;
      case 'labelUpdated':
        return BoardEventType.labelUpdated;
      case 'labelDeleted':
        return BoardEventType.labelDeleted;
      case 'cardLabelsUpdated':
        return BoardEventType.cardLabelsUpdated;
      case 'checklistItemsReordered':
        return BoardEventType.checklistItemsReordered;
      case 'boardUpdated':
        return BoardEventType.boardUpdated;
      case 'boardDeleted':
        return BoardEventType.boardDeleted;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "BoardEventType"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
