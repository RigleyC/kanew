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
import 'permission.dart' as _i2;
import 'package:kanew_client/src/protocol/protocol.dart' as _i3;

abstract class PermissionInfo implements _i1.SerializableModel {
  PermissionInfo._({
    required this.permission,
    required this.granted,
    required this.isDefault,
    required this.isAdded,
    required this.isRemoved,
  });

  factory PermissionInfo({
    required _i2.Permission permission,
    required bool granted,
    required bool isDefault,
    required bool isAdded,
    required bool isRemoved,
  }) = _PermissionInfoImpl;

  factory PermissionInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return PermissionInfo(
      permission: _i3.Protocol().deserialize<_i2.Permission>(
        jsonSerialization['permission'],
      ),
      granted: jsonSerialization['granted'] as bool,
      isDefault: jsonSerialization['isDefault'] as bool,
      isAdded: jsonSerialization['isAdded'] as bool,
      isRemoved: jsonSerialization['isRemoved'] as bool,
    );
  }

  _i2.Permission permission;

  bool granted;

  bool isDefault;

  bool isAdded;

  bool isRemoved;

  /// Returns a shallow copy of this [PermissionInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PermissionInfo copyWith({
    _i2.Permission? permission,
    bool? granted,
    bool? isDefault,
    bool? isAdded,
    bool? isRemoved,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PermissionInfo',
      'permission': permission.toJson(),
      'granted': granted,
      'isDefault': isDefault,
      'isAdded': isAdded,
      'isRemoved': isRemoved,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PermissionInfoImpl extends PermissionInfo {
  _PermissionInfoImpl({
    required _i2.Permission permission,
    required bool granted,
    required bool isDefault,
    required bool isAdded,
    required bool isRemoved,
  }) : super._(
         permission: permission,
         granted: granted,
         isDefault: isDefault,
         isAdded: isAdded,
         isRemoved: isRemoved,
       );

  /// Returns a shallow copy of this [PermissionInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PermissionInfo copyWith({
    _i2.Permission? permission,
    bool? granted,
    bool? isDefault,
    bool? isAdded,
    bool? isRemoved,
  }) {
    return PermissionInfo(
      permission: permission ?? this.permission.copyWith(),
      granted: granted ?? this.granted,
      isDefault: isDefault ?? this.isDefault,
      isAdded: isAdded ?? this.isAdded,
      isRemoved: isRemoved ?? this.isRemoved,
    );
  }
}
