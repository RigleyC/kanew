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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i5;
import 'accept_invite_result.dart' as _i6;
import 'activity_type.dart' as _i7;
import 'attachment.dart' as _i8;
import 'board.dart' as _i9;
import 'board_context.dart' as _i10;
import 'board_visibility.dart' as _i11;
import 'board_with_cards.dart' as _i12;
import 'card.dart' as _i13;
import 'card_activity.dart' as _i14;
import 'card_detail.dart' as _i15;
import 'card_label.dart' as _i16;
import 'card_list.dart' as _i17;
import 'card_priority.dart' as _i18;
import 'card_summary.dart' as _i19;
import 'checklist.dart' as _i20;
import 'checklist_item.dart' as _i21;
import 'checklist_with_items.dart' as _i22;
import 'comment.dart' as _i23;
import 'greetings/greeting.dart' as _i24;
import 'invite_details.dart' as _i25;
import 'label_def.dart' as _i26;
import 'member_permission.dart' as _i27;
import 'member_role.dart' as _i28;
import 'member_status.dart' as _i29;
import 'member_with_user.dart' as _i30;
import 'password_reset_token.dart' as _i31;
import 'permission.dart' as _i32;
import 'permission_info.dart' as _i33;
import 'user_preference.dart' as _i34;
import 'workspace.dart' as _i35;
import 'workspace_invite.dart' as _i36;
import 'workspace_member.dart' as _i37;
import 'package:kanew_server/src/generated/card_activity.dart' as _i38;
import 'package:kanew_server/src/generated/attachment.dart' as _i39;
import 'package:kanew_server/src/generated/board.dart' as _i40;
import 'package:kanew_server/src/generated/card.dart' as _i41;
import 'package:kanew_server/src/generated/card_detail.dart' as _i42;
import 'package:kanew_server/src/generated/card_list.dart' as _i43;
import 'package:kanew_server/src/generated/checklist.dart' as _i44;
import 'package:kanew_server/src/generated/checklist_item.dart' as _i45;
import 'package:kanew_server/src/generated/comment.dart' as _i46;
import 'package:kanew_server/src/generated/workspace_invite.dart' as _i47;
import 'package:kanew_server/src/generated/label_def.dart' as _i48;
import 'package:kanew_server/src/generated/member_with_user.dart' as _i49;
import 'package:kanew_server/src/generated/permission_info.dart' as _i50;
import 'package:kanew_server/src/generated/permission.dart' as _i51;
import 'package:kanew_server/src/generated/workspace.dart' as _i52;
export 'accept_invite_result.dart';
export 'activity_type.dart';
export 'attachment.dart';
export 'board.dart';
export 'board_context.dart';
export 'board_visibility.dart';
export 'board_with_cards.dart';
export 'card.dart';
export 'card_activity.dart';
export 'card_detail.dart';
export 'card_label.dart';
export 'card_list.dart';
export 'card_priority.dart';
export 'card_summary.dart';
export 'checklist.dart';
export 'checklist_item.dart';
export 'checklist_with_items.dart';
export 'comment.dart';
export 'greetings/greeting.dart';
export 'invite_details.dart';
export 'label_def.dart';
export 'member_permission.dart';
export 'member_role.dart';
export 'member_status.dart';
export 'member_with_user.dart';
export 'password_reset_token.dart';
export 'permission.dart';
export 'permission_info.dart';
export 'user_preference.dart';
export 'workspace.dart';
export 'workspace_invite.dart';
export 'workspace_member.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'attachment',
      dartName: 'Attachment',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'attachment_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'cardId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'workspaceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'fileName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'mimeType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'size',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'storageKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'fileUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'uploaderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'attachment_fk_0',
          columns: ['cardId'],
          referenceTable: 'card',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'attachment_fk_1',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'attachment_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'board',
      dartName: 'Board',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'board_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'uuid',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'workspaceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'slug',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'visibility',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:BoardVisibility',
        ),
        _i2.ColumnDefinition(
          name: 'backgroundUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'isTemplate',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdBy',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deletedBy',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'board_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'board_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'board_uuid_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'uuid',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'board_slug_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'card',
      dartName: 'Card',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'card_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'uuid',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'listId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'boardId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'descriptionDocument',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'priority',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:CardPriority',
        ),
        _i2.ColumnDefinition(
          name: 'rank',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'dueDate',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'isCompleted',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdBy',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deletedBy',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'card_fk_0',
          columns: ['listId'],
          referenceTable: 'card_list',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'card_fk_1',
          columns: ['boardId'],
          referenceTable: 'board',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'card_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'card_uuid_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'uuid',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'card_activity',
      dartName: 'CardActivity',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'card_activity_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'cardId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'actorId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'type',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ActivityType',
        ),
        _i2.ColumnDefinition(
          name: 'details',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'card_activity_fk_0',
          columns: ['cardId'],
          referenceTable: 'card',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'card_activity_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'card_label',
      dartName: 'CardLabel',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'card_label_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'cardId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'labelDefId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'card_label_fk_0',
          columns: ['cardId'],
          referenceTable: 'card',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'card_label_fk_1',
          columns: ['labelDefId'],
          referenceTable: 'label_def',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'card_label_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'card_label_unique',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'cardId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'labelDefId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'card_list',
      dartName: 'CardList',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'card_list_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'uuid',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'boardId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'rank',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'archived',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deletedBy',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'card_list_fk_0',
          columns: ['boardId'],
          referenceTable: 'board',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'card_list_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'card_list_uuid_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'uuid',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'checklist',
      dartName: 'Checklist',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'checklist_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'cardId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'rank',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'checklist_fk_0',
          columns: ['cardId'],
          referenceTable: 'card',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'checklist_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'checklist_item',
      dartName: 'ChecklistItem',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'checklist_item_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'checklistId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'isChecked',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'rank',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'checklist_item_fk_0',
          columns: ['checklistId'],
          referenceTable: 'checklist',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'checklist_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'comment',
      dartName: 'Comment',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'comment_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'cardId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'authorId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'content',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'comment_fk_0',
          columns: ['cardId'],
          referenceTable: 'card',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'comment_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'label_def',
      dartName: 'LabelDef',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'label_def_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'boardId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'colorHex',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'label_def_fk_0',
          columns: ['boardId'],
          referenceTable: 'board',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'label_def_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'member_permission',
      dartName: 'MemberPermission',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'member_permission_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'workspaceMemberId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'permissionId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'scopeBoardId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'member_permission_fk_0',
          columns: ['workspaceMemberId'],
          referenceTable: 'workspace_member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'member_permission_fk_1',
          columns: ['permissionId'],
          referenceTable: 'permission',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'member_permission_fk_2',
          columns: ['scopeBoardId'],
          referenceTable: 'board',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'member_permission_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'mem_perm_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'workspaceMemberId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'permissionId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'scopeBoardId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'password_reset_token',
      dartName: 'PasswordResetToken',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'password_reset_token_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'token',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'password_reset_token_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'password_reset_token_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'token',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'permission',
      dartName: 'Permission',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'permission_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'slug',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'permission_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'permission_slug_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_preference',
      dartName: 'UserPreference',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'user_preference_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'lastWorkspaceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'theme',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_preference_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'user_info_id_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userInfoId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'workspace',
      dartName: 'Workspace',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'workspace_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'uuid',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'slug',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'ownerId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deletedBy',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'workspace_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'workspace_uuid_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'uuid',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'workspace_slug_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'workspace_invite',
      dartName: 'WorkspaceInvite',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'workspace_invite_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'code',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'workspaceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdBy',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'initialPermissions',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<int>',
        ),
        _i2.ColumnDefinition(
          name: 'acceptedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'revokedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'workspace_invite_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'workspace_invite_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'workspace_invite_code_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'workspace_member',
      dartName: 'WorkspaceMember',
      schema: 'public',
      module: 'kanew',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'workspace_member_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'workspaceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:MemberRole',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:MemberStatus',
        ),
        _i2.ColumnDefinition(
          name: 'joinedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deletedBy',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'workspace_member_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'workspace_member_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'workspace_member_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i5.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i6.AcceptInviteResult) {
      return _i6.AcceptInviteResult.fromJson(data) as T;
    }
    if (t == _i7.ActivityType) {
      return _i7.ActivityType.fromJson(data) as T;
    }
    if (t == _i8.Attachment) {
      return _i8.Attachment.fromJson(data) as T;
    }
    if (t == _i9.Board) {
      return _i9.Board.fromJson(data) as T;
    }
    if (t == _i10.BoardContext) {
      return _i10.BoardContext.fromJson(data) as T;
    }
    if (t == _i11.BoardVisibility) {
      return _i11.BoardVisibility.fromJson(data) as T;
    }
    if (t == _i12.BoardWithCards) {
      return _i12.BoardWithCards.fromJson(data) as T;
    }
    if (t == _i13.Card) {
      return _i13.Card.fromJson(data) as T;
    }
    if (t == _i14.CardActivity) {
      return _i14.CardActivity.fromJson(data) as T;
    }
    if (t == _i15.CardDetail) {
      return _i15.CardDetail.fromJson(data) as T;
    }
    if (t == _i16.CardLabel) {
      return _i16.CardLabel.fromJson(data) as T;
    }
    if (t == _i17.CardList) {
      return _i17.CardList.fromJson(data) as T;
    }
    if (t == _i18.CardPriority) {
      return _i18.CardPriority.fromJson(data) as T;
    }
    if (t == _i19.CardSummary) {
      return _i19.CardSummary.fromJson(data) as T;
    }
    if (t == _i20.Checklist) {
      return _i20.Checklist.fromJson(data) as T;
    }
    if (t == _i21.ChecklistItem) {
      return _i21.ChecklistItem.fromJson(data) as T;
    }
    if (t == _i22.ChecklistWithItems) {
      return _i22.ChecklistWithItems.fromJson(data) as T;
    }
    if (t == _i23.Comment) {
      return _i23.Comment.fromJson(data) as T;
    }
    if (t == _i24.Greeting) {
      return _i24.Greeting.fromJson(data) as T;
    }
    if (t == _i25.InviteDetails) {
      return _i25.InviteDetails.fromJson(data) as T;
    }
    if (t == _i26.LabelDef) {
      return _i26.LabelDef.fromJson(data) as T;
    }
    if (t == _i27.MemberPermission) {
      return _i27.MemberPermission.fromJson(data) as T;
    }
    if (t == _i28.MemberRole) {
      return _i28.MemberRole.fromJson(data) as T;
    }
    if (t == _i29.MemberStatus) {
      return _i29.MemberStatus.fromJson(data) as T;
    }
    if (t == _i30.MemberWithUser) {
      return _i30.MemberWithUser.fromJson(data) as T;
    }
    if (t == _i31.PasswordResetToken) {
      return _i31.PasswordResetToken.fromJson(data) as T;
    }
    if (t == _i32.Permission) {
      return _i32.Permission.fromJson(data) as T;
    }
    if (t == _i33.PermissionInfo) {
      return _i33.PermissionInfo.fromJson(data) as T;
    }
    if (t == _i34.UserPreference) {
      return _i34.UserPreference.fromJson(data) as T;
    }
    if (t == _i35.Workspace) {
      return _i35.Workspace.fromJson(data) as T;
    }
    if (t == _i36.WorkspaceInvite) {
      return _i36.WorkspaceInvite.fromJson(data) as T;
    }
    if (t == _i37.WorkspaceMember) {
      return _i37.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i1.getType<_i6.AcceptInviteResult?>()) {
      return (data != null ? _i6.AcceptInviteResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ActivityType?>()) {
      return (data != null ? _i7.ActivityType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Attachment?>()) {
      return (data != null ? _i8.Attachment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Board?>()) {
      return (data != null ? _i9.Board.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.BoardContext?>()) {
      return (data != null ? _i10.BoardContext.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.BoardVisibility?>()) {
      return (data != null ? _i11.BoardVisibility.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.BoardWithCards?>()) {
      return (data != null ? _i12.BoardWithCards.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.Card?>()) {
      return (data != null ? _i13.Card.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.CardActivity?>()) {
      return (data != null ? _i14.CardActivity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.CardDetail?>()) {
      return (data != null ? _i15.CardDetail.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.CardLabel?>()) {
      return (data != null ? _i16.CardLabel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.CardList?>()) {
      return (data != null ? _i17.CardList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.CardPriority?>()) {
      return (data != null ? _i18.CardPriority.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.CardSummary?>()) {
      return (data != null ? _i19.CardSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Checklist?>()) {
      return (data != null ? _i20.Checklist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.ChecklistItem?>()) {
      return (data != null ? _i21.ChecklistItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.ChecklistWithItems?>()) {
      return (data != null ? _i22.ChecklistWithItems.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.Comment?>()) {
      return (data != null ? _i23.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.Greeting?>()) {
      return (data != null ? _i24.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.InviteDetails?>()) {
      return (data != null ? _i25.InviteDetails.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.LabelDef?>()) {
      return (data != null ? _i26.LabelDef.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.MemberPermission?>()) {
      return (data != null ? _i27.MemberPermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.MemberRole?>()) {
      return (data != null ? _i28.MemberRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.MemberStatus?>()) {
      return (data != null ? _i29.MemberStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.MemberWithUser?>()) {
      return (data != null ? _i30.MemberWithUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.PasswordResetToken?>()) {
      return (data != null ? _i31.PasswordResetToken.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i32.Permission?>()) {
      return (data != null ? _i32.Permission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.PermissionInfo?>()) {
      return (data != null ? _i33.PermissionInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.UserPreference?>()) {
      return (data != null ? _i34.UserPreference.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.Workspace?>()) {
      return (data != null ? _i35.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.WorkspaceInvite?>()) {
      return (data != null ? _i36.WorkspaceInvite.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.WorkspaceMember?>()) {
      return (data != null ? _i37.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == List<_i17.CardList>) {
      return (data as List).map((e) => deserialize<_i17.CardList>(e)).toList()
          as T;
    }
    if (t == List<_i26.LabelDef>) {
      return (data as List).map((e) => deserialize<_i26.LabelDef>(e)).toList()
          as T;
    }
    if (t == List<_i37.WorkspaceMember>) {
      return (data as List)
              .map((e) => deserialize<_i37.WorkspaceMember>(e))
              .toList()
          as T;
    }
    if (t == List<_i19.CardSummary>) {
      return (data as List)
              .map((e) => deserialize<_i19.CardSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i22.ChecklistWithItems>) {
      return (data as List)
              .map((e) => deserialize<_i22.ChecklistWithItems>(e))
              .toList()
          as T;
    }
    if (t == List<_i8.Attachment>) {
      return (data as List).map((e) => deserialize<_i8.Attachment>(e)).toList()
          as T;
    }
    if (t == List<_i23.Comment>) {
      return (data as List).map((e) => deserialize<_i23.Comment>(e)).toList()
          as T;
    }
    if (t == List<_i14.CardActivity>) {
      return (data as List)
              .map((e) => deserialize<_i14.CardActivity>(e))
              .toList()
          as T;
    }
    if (t == List<_i21.ChecklistItem>) {
      return (data as List)
              .map((e) => deserialize<_i21.ChecklistItem>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i38.CardActivity>) {
      return (data as List)
              .map((e) => deserialize<_i38.CardActivity>(e))
              .toList()
          as T;
    }
    if (t == List<_i39.Attachment>) {
      return (data as List).map((e) => deserialize<_i39.Attachment>(e)).toList()
          as T;
    }
    if (t == List<_i40.Board>) {
      return (data as List).map((e) => deserialize<_i40.Board>(e)).toList()
          as T;
    }
    if (t == List<_i41.Card>) {
      return (data as List).map((e) => deserialize<_i41.Card>(e)).toList() as T;
    }
    if (t == List<_i42.CardDetail>) {
      return (data as List).map((e) => deserialize<_i42.CardDetail>(e)).toList()
          as T;
    }
    if (t == List<_i43.CardList>) {
      return (data as List).map((e) => deserialize<_i43.CardList>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i44.Checklist>) {
      return (data as List).map((e) => deserialize<_i44.Checklist>(e)).toList()
          as T;
    }
    if (t == List<_i45.ChecklistItem>) {
      return (data as List)
              .map((e) => deserialize<_i45.ChecklistItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i46.Comment>) {
      return (data as List).map((e) => deserialize<_i46.Comment>(e)).toList()
          as T;
    }
    if (t == List<_i47.WorkspaceInvite>) {
      return (data as List)
              .map((e) => deserialize<_i47.WorkspaceInvite>(e))
              .toList()
          as T;
    }
    if (t == List<_i48.LabelDef>) {
      return (data as List).map((e) => deserialize<_i48.LabelDef>(e)).toList()
          as T;
    }
    if (t == List<_i49.MemberWithUser>) {
      return (data as List)
              .map((e) => deserialize<_i49.MemberWithUser>(e))
              .toList()
          as T;
    }
    if (t == List<_i50.PermissionInfo>) {
      return (data as List)
              .map((e) => deserialize<_i50.PermissionInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i51.Permission>) {
      return (data as List).map((e) => deserialize<_i51.Permission>(e)).toList()
          as T;
    }
    if (t == List<_i52.Workspace>) {
      return (data as List).map((e) => deserialize<_i52.Workspace>(e)).toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i5.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i6.AcceptInviteResult => 'AcceptInviteResult',
      _i7.ActivityType => 'ActivityType',
      _i8.Attachment => 'Attachment',
      _i9.Board => 'Board',
      _i10.BoardContext => 'BoardContext',
      _i11.BoardVisibility => 'BoardVisibility',
      _i12.BoardWithCards => 'BoardWithCards',
      _i13.Card => 'Card',
      _i14.CardActivity => 'CardActivity',
      _i15.CardDetail => 'CardDetail',
      _i16.CardLabel => 'CardLabel',
      _i17.CardList => 'CardList',
      _i18.CardPriority => 'CardPriority',
      _i19.CardSummary => 'CardSummary',
      _i20.Checklist => 'Checklist',
      _i21.ChecklistItem => 'ChecklistItem',
      _i22.ChecklistWithItems => 'ChecklistWithItems',
      _i23.Comment => 'Comment',
      _i24.Greeting => 'Greeting',
      _i25.InviteDetails => 'InviteDetails',
      _i26.LabelDef => 'LabelDef',
      _i27.MemberPermission => 'MemberPermission',
      _i28.MemberRole => 'MemberRole',
      _i29.MemberStatus => 'MemberStatus',
      _i30.MemberWithUser => 'MemberWithUser',
      _i31.PasswordResetToken => 'PasswordResetToken',
      _i32.Permission => 'Permission',
      _i33.PermissionInfo => 'PermissionInfo',
      _i34.UserPreference => 'UserPreference',
      _i35.Workspace => 'Workspace',
      _i36.WorkspaceInvite => 'WorkspaceInvite',
      _i37.WorkspaceMember => 'WorkspaceMember',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('kanew.', '');
    }

    switch (data) {
      case _i6.AcceptInviteResult():
        return 'AcceptInviteResult';
      case _i7.ActivityType():
        return 'ActivityType';
      case _i8.Attachment():
        return 'Attachment';
      case _i9.Board():
        return 'Board';
      case _i10.BoardContext():
        return 'BoardContext';
      case _i11.BoardVisibility():
        return 'BoardVisibility';
      case _i12.BoardWithCards():
        return 'BoardWithCards';
      case _i13.Card():
        return 'Card';
      case _i14.CardActivity():
        return 'CardActivity';
      case _i15.CardDetail():
        return 'CardDetail';
      case _i16.CardLabel():
        return 'CardLabel';
      case _i17.CardList():
        return 'CardList';
      case _i18.CardPriority():
        return 'CardPriority';
      case _i19.CardSummary():
        return 'CardSummary';
      case _i20.Checklist():
        return 'Checklist';
      case _i21.ChecklistItem():
        return 'ChecklistItem';
      case _i22.ChecklistWithItems():
        return 'ChecklistWithItems';
      case _i23.Comment():
        return 'Comment';
      case _i24.Greeting():
        return 'Greeting';
      case _i25.InviteDetails():
        return 'InviteDetails';
      case _i26.LabelDef():
        return 'LabelDef';
      case _i27.MemberPermission():
        return 'MemberPermission';
      case _i28.MemberRole():
        return 'MemberRole';
      case _i29.MemberStatus():
        return 'MemberStatus';
      case _i30.MemberWithUser():
        return 'MemberWithUser';
      case _i31.PasswordResetToken():
        return 'PasswordResetToken';
      case _i32.Permission():
        return 'Permission';
      case _i33.PermissionInfo():
        return 'PermissionInfo';
      case _i34.UserPreference():
        return 'UserPreference';
      case _i35.Workspace():
        return 'Workspace';
      case _i36.WorkspaceInvite():
        return 'WorkspaceInvite';
      case _i37.WorkspaceMember():
        return 'WorkspaceMember';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i5.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AcceptInviteResult') {
      return deserialize<_i6.AcceptInviteResult>(data['data']);
    }
    if (dataClassName == 'ActivityType') {
      return deserialize<_i7.ActivityType>(data['data']);
    }
    if (dataClassName == 'Attachment') {
      return deserialize<_i8.Attachment>(data['data']);
    }
    if (dataClassName == 'Board') {
      return deserialize<_i9.Board>(data['data']);
    }
    if (dataClassName == 'BoardContext') {
      return deserialize<_i10.BoardContext>(data['data']);
    }
    if (dataClassName == 'BoardVisibility') {
      return deserialize<_i11.BoardVisibility>(data['data']);
    }
    if (dataClassName == 'BoardWithCards') {
      return deserialize<_i12.BoardWithCards>(data['data']);
    }
    if (dataClassName == 'Card') {
      return deserialize<_i13.Card>(data['data']);
    }
    if (dataClassName == 'CardActivity') {
      return deserialize<_i14.CardActivity>(data['data']);
    }
    if (dataClassName == 'CardDetail') {
      return deserialize<_i15.CardDetail>(data['data']);
    }
    if (dataClassName == 'CardLabel') {
      return deserialize<_i16.CardLabel>(data['data']);
    }
    if (dataClassName == 'CardList') {
      return deserialize<_i17.CardList>(data['data']);
    }
    if (dataClassName == 'CardPriority') {
      return deserialize<_i18.CardPriority>(data['data']);
    }
    if (dataClassName == 'CardSummary') {
      return deserialize<_i19.CardSummary>(data['data']);
    }
    if (dataClassName == 'Checklist') {
      return deserialize<_i20.Checklist>(data['data']);
    }
    if (dataClassName == 'ChecklistItem') {
      return deserialize<_i21.ChecklistItem>(data['data']);
    }
    if (dataClassName == 'ChecklistWithItems') {
      return deserialize<_i22.ChecklistWithItems>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i23.Comment>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i24.Greeting>(data['data']);
    }
    if (dataClassName == 'InviteDetails') {
      return deserialize<_i25.InviteDetails>(data['data']);
    }
    if (dataClassName == 'LabelDef') {
      return deserialize<_i26.LabelDef>(data['data']);
    }
    if (dataClassName == 'MemberPermission') {
      return deserialize<_i27.MemberPermission>(data['data']);
    }
    if (dataClassName == 'MemberRole') {
      return deserialize<_i28.MemberRole>(data['data']);
    }
    if (dataClassName == 'MemberStatus') {
      return deserialize<_i29.MemberStatus>(data['data']);
    }
    if (dataClassName == 'MemberWithUser') {
      return deserialize<_i30.MemberWithUser>(data['data']);
    }
    if (dataClassName == 'PasswordResetToken') {
      return deserialize<_i31.PasswordResetToken>(data['data']);
    }
    if (dataClassName == 'Permission') {
      return deserialize<_i32.Permission>(data['data']);
    }
    if (dataClassName == 'PermissionInfo') {
      return deserialize<_i33.PermissionInfo>(data['data']);
    }
    if (dataClassName == 'UserPreference') {
      return deserialize<_i34.UserPreference>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i35.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceInvite') {
      return deserialize<_i36.WorkspaceInvite>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i37.WorkspaceMember>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i5.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i5.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i8.Attachment:
        return _i8.Attachment.t;
      case _i9.Board:
        return _i9.Board.t;
      case _i13.Card:
        return _i13.Card.t;
      case _i14.CardActivity:
        return _i14.CardActivity.t;
      case _i16.CardLabel:
        return _i16.CardLabel.t;
      case _i17.CardList:
        return _i17.CardList.t;
      case _i20.Checklist:
        return _i20.Checklist.t;
      case _i21.ChecklistItem:
        return _i21.ChecklistItem.t;
      case _i23.Comment:
        return _i23.Comment.t;
      case _i26.LabelDef:
        return _i26.LabelDef.t;
      case _i27.MemberPermission:
        return _i27.MemberPermission.t;
      case _i31.PasswordResetToken:
        return _i31.PasswordResetToken.t;
      case _i32.Permission:
        return _i32.Permission.t;
      case _i34.UserPreference:
        return _i34.UserPreference.t;
      case _i35.Workspace:
        return _i35.Workspace.t;
      case _i36.WorkspaceInvite:
        return _i36.WorkspaceInvite.t;
      case _i37.WorkspaceMember:
        return _i37.WorkspaceMember.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'kanew';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i5.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
