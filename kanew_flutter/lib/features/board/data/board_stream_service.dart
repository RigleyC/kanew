import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';

enum StreamStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

/// Service that manages WebSocket connection to board updates stream.
/// NOT a controller - just handles connection lifecycle.
class BoardStreamService {
  final Client _client;

  StreamStatus _status = StreamStatus.disconnected;
  final ValueNotifier<StreamStatus> statusNotifier = ValueNotifier(
    StreamStatus.disconnected,
  );

  StreamSubscription<BoardEvent>? _subscription;
  final StreamController<BoardEvent> _eventController =
      StreamController<BoardEvent>.broadcast();
  Timer? _reconnectTimer;

  UuidValue? _currentBoardId;
  bool _disposed = false;
  bool _isConnecting = false;
  bool _authInvalid = false;
  int _reconnectAttempts = 0;
  int _consumerCount = 0;

  BoardStreamService({required Client client}) : _client = client;

  Stream<BoardEvent> get events => _eventController.stream;

  StreamStatus get status => _status;

  UuidValue? get currentBoardId => _currentBoardId;

  void _debugLog(String message) {
    if (!kDebugMode) return;
    debugPrint(message);
  }

  /// Connects to board stream with auto-reconnect
  Future<void> connect(UuidValue boardId) async {
    if (_disposed) return;
    _consumerCount++;

    if (_status == StreamStatus.connected && _currentBoardId == boardId) {
      return;
    }

    _authInvalid = false;
    _reconnectAttempts = 0;
    _currentBoardId = boardId;
    _updateStatus(StreamStatus.connecting);

    await _startListening();
  }

  /// Releases one consumer of this shared stream.
  /// When no consumers remain, the underlying connection is closed.
  Future<void> release() async {
    if (_consumerCount > 0) {
      _consumerCount--;
    }

    if (_consumerCount > 0) {
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _subscription?.cancel();
    _subscription = null;
    _currentBoardId = null;
    _authInvalid = false;
    _isConnecting = false;
    _reconnectAttempts = 0;
    _updateStatus(StreamStatus.disconnected);
  }

  Future<void> _startListening() async {
    if (_disposed || _currentBoardId == null || _isConnecting) return;

    _isConnecting = true;
    try {
      await _subscription?.cancel();
      _subscription = null;

      // Subscribe to board updates
      final stream = _client.boardStream.subscribeToBoardUpdates(
        _currentBoardId!,
      );

      _subscription = stream.listen(
        (event) {
          _debugLog('[BoardStreamService] Received event: ${event.eventType}');
          if (!_disposed) {
            _eventController.add(event);
          }
        },
        onError: (error, _) {
          _debugLog('[BoardStreamService] Stream error: $error');
          _handleDisconnection(error: error);
        },
        onDone: () {
          _debugLog('[BoardStreamService] Stream closed');
          _handleDisconnection();
        },
        cancelOnError: false,
      );

      _updateStatus(StreamStatus.connected);
      _reconnectAttempts = 0;
      _debugLog('[BoardStreamService] Connected to board $_currentBoardId');
    } catch (e) {
      _debugLog('[BoardStreamService] Connection error: $e');
      _handleDisconnection(error: e);
    } finally {
      _isConnecting = false;
    }
  }

  void _handleDisconnection({Object? error}) {
    if (_disposed) return;

    if (_isAuthError(error)) {
      _authInvalid = true;
      _updateStatus(StreamStatus.disconnected);
      _reconnectTimer?.cancel();
      _subscription?.cancel();
      _subscription = null;
      _debugLog(
        '[BoardStreamService] Auth error (${error.runtimeType}), stopping reconnect',
      );
      return;
    }

    _updateStatus(StreamStatus.reconnecting);
    _subscription?.cancel();
    _subscription = null;

    // Retry with exponential backoff (with jitter)
    _reconnectTimer?.cancel();
    _reconnectAttempts++;
    final delay = _computeReconnectDelay(_reconnectAttempts);
    _reconnectTimer = Timer(delay, () {
      if (!_disposed && _currentBoardId != null && !_authInvalid) {
        _debugLog('[BoardStreamService] Attempting reconnect...');
        _startListening();
      }
    });
  }

  Duration _computeReconnectDelay(int attempt) {
    const baseSeconds = 1;
    final exponent = (attempt - 1).clamp(0, 4).toInt();
    final baseDelay = Duration(seconds: baseSeconds * (1 << exponent));
    final jitterMs = Random().nextInt(500);
    return baseDelay + Duration(milliseconds: jitterMs);
  }

  bool _isAuthError(Object? error) {
    if (error == null) return false;

    if (error is ServerpodClientException) {
      return error.statusCode == 401 || error.statusCode == 403;
    }

    final message = error.toString().toLowerCase();
    return message.contains('unauthorized') ||
        message.contains('forbidden') ||
        message.contains('not authenticated');
  }

  void _updateStatus(StreamStatus newStatus) {
    _status = newStatus;
    statusNotifier.value = newStatus;
  }

  void dispose() {
    _disposed = true;
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _eventController.close();
    _updateStatus(StreamStatus.disconnected);
    statusNotifier.dispose();
  }
}
