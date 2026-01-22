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

enum ActivityType implements _i1.SerializableModel {
  create,
  update,
  delete,
  move,
  comment,
  archive,
  restore,
  attachmentAdded,
  attachmentDeleted;

  static ActivityType fromJson(String name) {
    switch (name) {
      case 'create':
        return ActivityType.create;
      case 'update':
        return ActivityType.update;
      case 'delete':
        return ActivityType.delete;
      case 'move':
        return ActivityType.move;
      case 'comment':
        return ActivityType.comment;
      case 'archive':
        return ActivityType.archive;
      case 'restore':
        return ActivityType.restore;
      case 'attachmentAdded':
        return ActivityType.attachmentAdded;
      case 'attachmentDeleted':
        return ActivityType.attachmentDeleted;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "ActivityType"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
