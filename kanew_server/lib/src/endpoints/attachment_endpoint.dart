import 'dart:convert';
import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/permission_service.dart';
import '../services/auth_helper.dart';
import '../services/activity_service.dart';

class AttachmentEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<String?> _publicUrl(Session session, String storagePath) async {
    final uri = await session.storage.getPublicUrl(
      storageId: 'public',
      path: storagePath,
    );
    return uri?.toString();
  }

  /// Uploads a file directly via ByteData.
  /// This is a simpler approach that doesn't require the FileUploader client.
  ///
  /// Requires: card.update permission
  Future<Attachment?> uploadFile(
    Session session, {
    required int cardId,
    required String fileName,
    required ByteData fileData,
    required String mimeType,
  }) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    // 1. Verify Card and Permission
    final card = await Card.db.findById(session, cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'card.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to update this card');
    }

    // 2. Generate Storage Path
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final storagePath =
        'workspaces/${board.workspaceId}/cards/$cardId/${timestamp}_$fileName';

    // 3. Store the file directly using session.storage.storeFile
    await session.storage.storeFile(
      storageId: 'public',
      path: storagePath,
      byteData: fileData,
    );

    // 4. Get the public URL
    final publicUrl = await _publicUrl(session, storagePath);

    // 5. Create Attachment Record
    final size = fileData.lengthInBytes;
    final attachment = Attachment(
      cardId: cardId,
      workspaceId: board.workspaceId,
      fileName: fileName,
      mimeType: mimeType,
      size: size,
      storageKey: storagePath,
      uploaderId: numericUserId,
      createdAt: DateTime.now(),
      fileUrl: null,
    );

    final result = await Attachment.db.insertRow(session, attachment);

    // 6. Log Activity
    await ActivityService.log(
      session,
      cardId: cardId,
      actorId: numericUserId,
      type: ActivityType.attachmentAdded,
      details: 'adicionou o anexo "$fileName"',
    );

    return result.copyWith(fileUrl: publicUrl);
  }

  /// Returns an upload description for uploading a file to the server.
  /// The file is uploaded to the [storageId] storage.
  /// Returns a JSON string: {"path": "...", "description": "..."}
  ///
  /// Requires: card.update permission
  Future<String?> getUploadDescription(
    Session session, {
    required int cardId,
    required String fileName,
    required int size,
    required String mimeType,
  }) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    // 1. Verify Card and Permission
    final card = await Card.db.findById(session, cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'card.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to update this card');
    }

    // 2. Generate Storage Path
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final storagePath =
        'workspaces/${board.workspaceId}/cards/$cardId/${timestamp}_$fileName';

    // 3. Create Upload Description
    final description = await session.storage.createDirectFileUploadDescription(
      storageId: 'public',
      path: storagePath,
    );

    if (description == null) return null;

    return jsonEncode({
      'path': storagePath,
      'description': description,
    });
  }

  /// Verifies that a file has been uploaded and creates the Attachment record.
  ///
  /// Requires: card.update permission
  Future<Attachment?> verifyUpload(
    Session session, {
    required int cardId,
    required String fileName,
    required String storagePath,
    required String mimeType,
    required int size,
  }) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    // 1. Verify Card and Permission (Again, to be safe)
    final card = await Card.db.findById(session, cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'card.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to update this card');
    }

    // 2. Verify File Upload
    session.log('[AttachmentEndpoint] Verifying upload for path: $storagePath');
    final success = await session.storage.verifyDirectFileUpload(
      storageId: 'public',
      path: storagePath,
    );
    session.log('[AttachmentEndpoint] Verification result: $success');

    if (!success) {
      // Try to check if file exists
      final exists = await session.storage.fileExists(
        storageId: 'public',
        path: storagePath,
      );
      session.log('[AttachmentEndpoint] File exists check: $exists');
      throw Exception('File upload failed verification');
    }

    // 3. Create Attachment Record
    final publicUrl = await _publicUrl(session, storagePath);

    final attachment = Attachment(
      cardId: cardId,
      workspaceId: board.workspaceId,
      fileName: fileName,
      mimeType: mimeType,
      size: size,
      storageKey: storagePath,
      uploaderId: numericUserId,
      createdAt: DateTime.now(),
      fileUrl: null,
    );

    final result = await Attachment.db.insertRow(session, attachment);

    // 4. Log Activity
    await ActivityService.log(
      session,
      cardId: cardId,
      actorId: numericUserId,
      type: ActivityType.attachmentAdded,
      details: 'adicionou o anexo "$fileName"',
    );

    return result.copyWith(fileUrl: publicUrl);
  }

  /// Lists all active attachments for a card.
  ///
  /// Requires: card.read permission
  Future<List<Attachment>> listAttachments(
    Session session,
    int cardId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final card = await Card.db.findById(session, cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'card.read',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to read this card');
    }

    final rows = await Attachment.db.find(
      session,
      where: (a) => a.cardId.equals(cardId) & a.deletedAt.equals(null),
      orderBy: (a) => a.createdAt,
      orderDescending: true,
    );

    return Future.wait(
      rows.map((a) async {
        final url = a.storageKey.isNotEmpty
            ? await _publicUrl(session, a.storageKey)
            : null;
        return a.copyWith(fileUrl: url ?? a.fileUrl);
      }),
    );
  }

  /// Deletes an attachment (soft delete).
  ///
  /// Requires: card.update permission (and check ownership/admin logic)
  Future<void> deleteAttachment(
    Session session,
    int attachmentId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final attachment = await Attachment.db.findById(session, attachmentId);
    if (attachment == null || attachment.deletedAt != null) {
      throw Exception('Attachment not found');
    }

    final card = await Card.db.findById(session, attachment.cardId);
    if (card == null) {
      throw Exception('Card not found');
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'card.update',
    );

    // Allow uploader or workspace admin to delete
    final isUploader = attachment.uploaderId == numericUserId;

    if (!hasPermission && !isUploader) {
      throw Exception(
        'User does not have permission to delete this attachment',
      );
    }

    // Best-effort delete from storage
    try {
      await session.storage.deleteFile(
        storageId: 'public',
        path: attachment.storageKey,
      );
    } catch (e) {
      session.log('[AttachmentEndpoint] Failed to delete file from storage: $e');
    }

    // Soft delete
    final updated = attachment.copyWith(
      deletedAt: DateTime.now(),
    );
    await Attachment.db.updateRow(session, updated);

    // Log Activity
    await ActivityService.log(
      session,
      cardId: attachment.cardId,
      actorId: numericUserId,
      type: ActivityType.attachmentDeleted,
      details: 'removeu o anexo "${attachment.fileName}"',
    );
  }
}
