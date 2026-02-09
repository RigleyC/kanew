// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'file_picker_service.dart';

/// Web implementation using dart:html directly.
/// This bypasses the file_picker package which has initialization issues on web.
class FilePickerServiceImpl implements FilePickerService {
  @override
  Future<PickedFile?> pickFile({List<String>? allowedExtensions}) async {
    final files = await _pickFilesFromInput(
      multiple: false,
      allowedExtensions: allowedExtensions,
    );
    return files.isNotEmpty ? files.first : null;
  }

  @override
  Future<List<PickedFile>> pickMultipleFiles({
    List<String>? allowedExtensions,
  }) async {
    return _pickFilesFromInput(
      multiple: true,
      allowedExtensions: allowedExtensions,
    );
  }

  Future<List<PickedFile>> _pickFilesFromInput({
    required bool multiple,
    List<String>? allowedExtensions,
  }) async {
    final completer = Completer<List<PickedFile>>();

    final input = html.FileUploadInputElement()..multiple = multiple;

    // Set accepted file types
    if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
      input.accept = allowedExtensions.map((e) => '.$e').join(',');
    }

    // Listen for file selection
    input.onChange.listen((event) async {
      final files = input.files;
      if (files == null || files.isEmpty) {
        if (!completer.isCompleted) {
          completer.complete([]);
        }
        return;
      }

      final pickedFiles = <PickedFile>[];

      for (final file in files) {
        try {
          final bytes = await _readFileAsBytes(file);
          if (bytes != null) {
            pickedFiles.add(
              PickedFile(
                name: file.name,
                bytes: bytes,
                mimeType: file.type.isNotEmpty ? file.type : null,
                size: file.size,
              ),
            );
          }
        } catch (_) {
          // Skip files that fail to read
        }
      }

      if (!completer.isCompleted) {
        completer.complete(pickedFiles);
      }
    });

    // Trigger the file picker dialog
    input.click();

    return completer.future;
  }

  Future<Uint8List?> _readFileAsBytes(html.File file) async {
    final completer = Completer<Uint8List?>();
    final reader = html.FileReader();

    reader.onLoadEnd.listen((event) {
      final result = reader.result;

      if (result is ByteBuffer) {
        // This is the actual type returned by readAsArrayBuffer
        completer.complete(result.asUint8List());
      } else if (result is Uint8List) {
        completer.complete(result);
      } else if (result is List<int>) {
        completer.complete(Uint8List.fromList(result));
      } else {
        completer.complete(null);
      }
    });

    reader.onError.listen((event) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    });

    reader.readAsArrayBuffer(file);
    return completer.future;
  }
}
