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
import 'permission.dart' as _i2;
import 'package:kanew_server/src/generated/protocol.dart' as _i3;

abstract class PermissionInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PermissionInfo._({
    required this.permission,
    required this.granted,
  });

  factory PermissionInfo({
    required _i2.Permission permission,
    required bool granted,
  }) = _PermissionInfoImpl;

  factory PermissionInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return PermissionInfo(
      permission: _i3.Protocol().deserialize<_i2.Permission>(
        jsonSerialization['permission'],
      ),
      granted: jsonSerialization['granted'] as bool,
    );
  }

  _i2.Permission permission;

  bool granted;

  /// Returns a shallow copy of this [PermissionInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PermissionInfo copyWith({
    _i2.Permission? permission,
    bool? granted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PermissionInfo',
      'permission': permission.toJson(),
      'granted': granted,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PermissionInfo',
      'permission': permission.toJsonForProtocol(),
      'granted': granted,
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
  }) : super._(
         permission: permission,
         granted: granted,
       );

  /// Returns a shallow copy of this [PermissionInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PermissionInfo copyWith({
    _i2.Permission? permission,
    bool? granted,
  }) {
    return PermissionInfo(
      permission: permission ?? this.permission.copyWith(),
      granted: granted ?? this.granted,
    );
  }
}
