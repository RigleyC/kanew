// ignore_for_file: implementation_imports
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/cloud_storage_direct_upload.dart';

class RailwayObjectStorageCloudStorage extends CloudStorage {
  RailwayObjectStorageCloudStorage({
    required String storageId,
    required Uri endpoint,
    required String bucket,
    required String region,
    required String accessKeyId,
    required String secretAccessKey,
    bool forcePathStyle = false,
    Duration presignedUrlExpiresIn = const Duration(minutes: 15),
  }) : _endpoint = endpoint,
       _bucket = bucket,
       _region = region,
       _forcePathStyle = forcePathStyle,
       _presignedUrlExpiresIn = presignedUrlExpiresIn,
       _signer = AWSSigV4Signer(
         credentialsProvider: AWSCredentialsProvider(
           AWSCredentials(accessKeyId, secretAccessKey),
         ),
       ),
       super(storageId);

  static RailwayObjectStorageCloudStorage? tryFromEnvironment({
    String storageId = 'public',
  }) {
    String? read(String key) {
      final v = Platform.environment[key];
      if (v == null) return null;
      final trimmed = v.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    String? readEither(String preferred, String fallback) {
      return read(preferred) ?? read(fallback);
    }

    final bucket = readEither('OBJECT_STORAGE_BUCKET', 'BUCKET');
    final accessKeyId = readEither(
      'OBJECT_STORAGE_ACCESS_KEY_ID',
      'ACCESS_KEY_ID',
    );
    final secretAccessKey = readEither(
      'OBJECT_STORAGE_SECRET_ACCESS_KEY',
      'SECRET_ACCESS_KEY',
    );
    final region = readEither('OBJECT_STORAGE_REGION', 'REGION') ?? 'auto';
    final endpointRaw =
        readEither('OBJECT_STORAGE_ENDPOINT', 'ENDPOINT') ??
        'https://storage.railway.app';

    if (bucket == null || accessKeyId == null || secretAccessKey == null) {
      return null;
    }

    final endpoint = Uri.parse(endpointRaw);
    final forcePathStyle =
        (readEither('OBJECT_STORAGE_FORCE_PATH_STYLE', 'FORCE_PATH_STYLE') ??
                'false')
            .toLowerCase() ==
        'true';

    final presignedSeconds =
        int.tryParse(read('OBJECT_STORAGE_PRESIGNED_EXPIRES_SECONDS') ?? '') ??
        900;

    return RailwayObjectStorageCloudStorage(
      storageId: storageId,
      endpoint: endpoint,
      bucket: bucket,
      region: region,
      accessKeyId: accessKeyId,
      secretAccessKey: secretAccessKey,
      forcePathStyle: forcePathStyle,
      presignedUrlExpiresIn: Duration(seconds: presignedSeconds),
    );
  }

  final Uri _endpoint;
  final String _bucket;
  final String _region;
  final bool _forcePathStyle;
  final Duration _presignedUrlExpiresIn;

  final AWSSigV4Signer _signer;
  final AWSHttpClient _client = AWSHttpClient();

  AWSCredentialScope _scope() => AWSCredentialScope(
    region: _region,
    service: AWSService.s3,
  );

  Uri _objectUri(String key) {
    final normalizedKey = key.startsWith('/') ? key.substring(1) : key;
    final keySegments = normalizedKey
        .split('/')
        .where((s) => s.isNotEmpty)
        .toList();

    if (_forcePathStyle) {
      return Uri(
        scheme: _endpoint.scheme,
        host: _endpoint.host,
        port: _endpoint.hasPort ? _endpoint.port : null,
        pathSegments: <String>[_bucket, ...keySegments],
      );
    }

    return Uri(
      scheme: _endpoint.scheme,
      host: '$_bucket.${_endpoint.host}',
      port: _endpoint.hasPort ? _endpoint.port : null,
      pathSegments: keySegments,
    );
  }

  Future<AWSBaseHttpResponse> _sendSigned(
    AWSStreamedHttpRequest request,
  ) async {
    final signed = await _signer.sign(
      request,
      credentialScope: _scope(),
      serviceConfiguration: S3ServiceConfiguration(),
    );

    final op = signed.send(client: _client);
    return await op.response;
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
  }) async {
    try {
      final uri = _objectUri(path);
      final bytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );

      final request = AWSStreamedHttpRequest.put(
        uri,
        body: Stream.value(bytes),
        contentLength: bytes.length,
        headers: const {
          AWSHeaders.contentType: 'application/octet-stream',
        },
      );

      final response = await _sendSigned(request);
      await response.body.drain<void>();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw CloudStorageException(
          'Failed to store file (status ${response.statusCode}).',
        );
      }
    } catch (e) {
      if (e is CloudStorageException) rethrow;
      throw CloudStorageException('Failed to store file. ($e)');
    }
  }

  @override
  Future<ByteData?> retrieveFile({
    required Session session,
    required String path,
  }) async {
    try {
      final uri = _objectUri(path);
      final request = AWSStreamedHttpRequest.get(uri);
      final response = await _sendSigned(request);

      if (response.statusCode == 404) return null;
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw CloudStorageException(
          'Failed to retrieve file (status ${response.statusCode}).',
        );
      }

      final bytes = await Future.value(response.bodyBytes);
      return ByteData.sublistView(Uint8List.fromList(bytes));
    } catch (e) {
      if (e is CloudStorageException) rethrow;
      throw CloudStorageException('Failed to retrieve file. ($e)');
    }
  }

  @override
  Future<Uri?> getPublicUrl({
    required Session session,
    required String path,
  }) async {
    if (storageId != 'public') return null;

    try {
      final uri = _objectUri(path);
      final request = AWSHttpRequest.get(uri);
      return await _signer.presign(
        request,
        credentialScope: _scope(),
        serviceConfiguration: S3ServiceConfiguration(signPayload: false),
        expiresIn: _presignedUrlExpiresIn,
      );
    } catch (e) {
      throw CloudStorageException('Failed to create public URL. ($e)');
    }
  }

  @override
  Future<bool> fileExists({
    required Session session,
    required String path,
  }) async {
    try {
      final uri = _objectUri(path);
      final request = AWSStreamedHttpRequest.head(uri);
      final response = await _sendSigned(request);
      await response.body.drain<void>();

      if (response.statusCode == 404) return false;
      if (response.statusCode >= 200 && response.statusCode < 300) return true;
      throw CloudStorageException(
        'Failed to check file existence (status ${response.statusCode}).',
      );
    } catch (e) {
      if (e is CloudStorageException) rethrow;
      throw CloudStorageException('Failed to check if file exists. ($e)');
    }
  }

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    try {
      final uri = _objectUri(path);
      final request = AWSStreamedHttpRequest.delete(uri);
      final response = await _sendSigned(request);
      await response.body.drain<void>();

      if (response.statusCode == 404) return;
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw CloudStorageException(
          'Failed to delete file (status ${response.statusCode}).',
        );
      }
    } catch (e) {
      if (e is CloudStorageException) rethrow;
      throw CloudStorageException('Failed to delete file. ($e)');
    }
  }

  @override
  Future<String?> createDirectFileUploadDescription({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    final config = session.server.serverpod.config;

    final expiration = DateTime.now().add(expirationDuration);

    final uploadEntry = CloudStorageDirectUploadEntry(
      storageId: storageId,
      path: path,
      expiration: expiration,
      authKey: _generateAuthKey(),
    );

    final inserted = await CloudStorageDirectUploadEntry.db.insertRow(
      session,
      uploadEntry,
    );

    final uri = Uri(
      scheme: config.apiServer.publicScheme,
      host: config.apiServer.publicHost,
      port: config.apiServer.publicPort,
      path: '/serverpod_cloud_storage',
      queryParameters: {
        'method': 'upload',
        'storage': storageId,
        'path': path,
        'key': inserted.authKey,
      },
    );

    final uploadDescriptionData = {
      'url': uri.toString(),
      'type': 'binary',
    };

    return SerializationManager.encode(uploadDescriptionData);
  }

  @override
  Future<bool> verifyDirectFileUpload({
    required Session session,
    required String path,
  }) async {
    return fileExists(session: session, path: path);
  }

  static String _generateAuthKey() {
    const len = 16;
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(
        len,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );
  }
}
