import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/failures.dart';
import '../../../core/services/file_picker_service.dart';

/// Repository for attachment operations
class AttachmentRepository {
  final Client _client;

  AttachmentRepository({Client? client}) : _client = client ?? getIt<Client>();

  /// Busca todos os anexos de um card
  Future<Either<Failure, List<Attachment>>> getAttachments(UuidValue cardId) async {
    developer.log(
      'AttachmentRepository.getAttachments($cardId)',
      name: 'attachment_repository',
    );
    try {
      final attachments = await _client.attachment.listAttachments(cardId);
      developer.log(
        'AttachmentRepository.getAttachments success: ${attachments.length} attachments',
        name: 'attachment_repository',
      );
      return Right(attachments);
    } catch (e, s) {
      developer.log(
        'AttachmentRepository.getAttachments error: $e',
        name: 'attachment_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Falha ao carregar anexos',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Faz upload de um anexo para o card
  Future<Either<Failure, Attachment>> uploadAttachment(
    UuidValue cardId,
    PickedFile file,
  ) async {
    developer.log(
      'AttachmentRepository.uploadAttachment($cardId, ${file.name})',
      name: 'attachment_repository',
    );
    try {
      if (file.size == 0) {
        return const Left(ServerFailure('Arquivo vazio'));
      }

      final fileName = file.name;
      final mimeType = file.mimeType ?? 'application/octet-stream';

      // Convert Uint8List to ByteData
      final byteData = ByteData.view(file.bytes.buffer);

      // Use the new uploadFile endpoint that handles storage directly
      final attachment = await _client.attachment.uploadFile(
        cardId: cardId,
        fileName: fileName,
        fileData: byteData,
        mimeType: mimeType,
      );

      if (attachment == null) {
        return const Left(ServerFailure('Falha no upload'));
      }

      developer.log(
        'AttachmentRepository.uploadAttachment success',
        name: 'attachment_repository',
      );
      return Right(attachment);
    } catch (e, s) {
      developer.log(
        'AttachmentRepository.uploadAttachment error: $e',
        name: 'attachment_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Falha ao fazer upload de anexo',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Exclui um anexo
  Future<Either<Failure, Unit>> deleteAttachment(UuidValue attachmentId) async {
    developer.log(
      'AttachmentRepository.deleteAttachment($attachmentId)',
      name: 'attachment_repository',
    );
    try {
      await _client.attachment.deleteAttachment(attachmentId);
      developer.log(
        'AttachmentRepository.deleteAttachment success',
        name: 'attachment_repository',
      );
      return const Right(unit);
    } catch (e, s) {
      developer.log(
        'AttachmentRepository.deleteAttachment error: $e',
        name: 'attachment_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Falha ao excluir anexo',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }
}
