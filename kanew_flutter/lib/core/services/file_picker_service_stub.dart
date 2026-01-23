import 'package:file_picker/file_picker.dart';

import 'file_picker_service.dart';

/// Non-web implementation using file_picker package.
/// Used on mobile/desktop platforms where file_picker works correctly.
class FilePickerServiceImpl implements FilePickerService {
  @override
  Future<PickedFile?> pickFile({List<String>? allowedExtensions}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        withData: true,
        allowMultiple: false,
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;
      final bytes = file.bytes;

      if (bytes == null) return null;

      return PickedFile(
        name: file.name,
        bytes: bytes,
        mimeType: _getMimeType(file.name),
        size: file.size,
      );
    } catch (e) {
      // Fallback: if file_picker fails, return null
      return null;
    }
  }

  @override
  Future<List<PickedFile>> pickMultipleFiles({
    List<String>? allowedExtensions,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        withData: true,
        allowMultiple: true,
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result == null || result.files.isEmpty) return [];

      final pickedFiles = <PickedFile>[];

      for (final file in result.files) {
        final bytes = file.bytes;
        if (bytes != null) {
          pickedFiles.add(
            PickedFile(
              name: file.name,
              bytes: bytes,
              mimeType: _getMimeType(file.name),
              size: file.size,
            ),
          );
        }
      }

      return pickedFiles;
    } catch (e) {
      return [];
    }
  }

  String? _getMimeType(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    const mimeTypes = {
      'pdf': 'application/pdf',
      'png': 'image/png',
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'gif': 'image/gif',
      'webp': 'image/webp',
      'txt': 'text/plain',
      'html': 'text/html',
      'css': 'text/css',
      'js': 'application/javascript',
      'json': 'application/json',
      'xml': 'application/xml',
      'zip': 'application/zip',
      'doc': 'application/msword',
      'docx':
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls': 'application/vnd.ms-excel',
      'xlsx':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    };
    return mimeTypes[ext];
  }
}
