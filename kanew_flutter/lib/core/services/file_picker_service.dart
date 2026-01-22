import 'dart:typed_data';

import 'file_picker_service_stub.dart'
    if (dart.library.html) 'file_picker_service_web.dart' as impl;

/// Represents a picked file with its data.
class PickedFile {
  final String name;
  final Uint8List bytes;
  final String? mimeType;
  final int size;

  PickedFile({
    required this.name,
    required this.bytes,
    this.mimeType,
    required this.size,
  });
}

/// Platform-agnostic file picker service interface.
abstract class FilePickerService {
  /// Creates the platform-specific implementation.
  factory FilePickerService() = impl.FilePickerServiceImpl;

  /// Picks a single file. Returns null if cancelled.
  Future<PickedFile?> pickFile({List<String>? allowedExtensions});

  /// Picks multiple files. Returns empty list if cancelled.
  Future<List<PickedFile>> pickMultipleFiles({List<String>? allowedExtensions});
}
