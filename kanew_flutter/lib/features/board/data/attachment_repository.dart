import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../core/error/failures.dart';
import '../../../core/services/file_picker_service.dart';

class AttachmentRepository {
  final Client _client;

  AttachmentRepository(this._client);

  Future<Either<Failure, List<Attachment>>> getAttachments(int cardId) async {
    try {
      // ignore: undefined_getter
      final attachments = await _client.attachment.listAttachments(cardId);
      return Right(attachments);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Attachment>> uploadAttachment(
    int cardId,
    PickedFile file,
  ) async {
    try {
      if (file.size == 0) {
        return const Left(ServerFailure('File is empty'));
      }

      final fileName = file.name;
      final mimeType = file.mimeType ?? 'application/octet-stream';

      // Convert Uint8List to ByteData
      final byteData = ByteData.view(file.bytes.buffer);

      // Use the new uploadFile endpoint that handles storage directly
      // ignore: undefined_getter
      final attachment = await _client.attachment.uploadFile(
        cardId: cardId,
        fileName: fileName,
        fileData: byteData,
        mimeType: mimeType,
      );

      if (attachment == null) {
        return const Left(ServerFailure('Upload failed'));
      }

      return Right(attachment);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteAttachment(int attachmentId) async {
    try {
      // ignore: undefined_getter
      await _client.attachment.deleteAttachment(attachmentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
