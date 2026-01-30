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

enum CardPriority implements _i1.SerializableModel {
  none,
  low,
  medium,
  high,
  urgent;

  static CardPriority fromJson(String name) {
    switch (name) {
      case 'none':
        return CardPriority.none;
      case 'low':
        return CardPriority.low;
      case 'medium':
        return CardPriority.medium;
      case 'high':
        return CardPriority.high;
      case 'urgent':
        return CardPriority.urgent;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "CardPriority"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
