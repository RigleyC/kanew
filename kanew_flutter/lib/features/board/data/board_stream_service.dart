import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../core/auth/auth_service.dart';

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

  int? _currentBoardId;
  bool _disposed = false;
  bool _isConnecting = false;
  bool _authInvalid = false;
  int _reconnectAttempts = 0;

  BoardStreamService({required Client client}) : _client = client;

  Stream<BoardEvent> get events => _eventController.stream;

  StreamStatus get status => _status;

  /// Connects to board stream with auto-reconnect
  Future<void> connect(int boardId) async {
    if (_disposed) return;

    _authInvalid = false;
    _reconnectAttempts = 0;
    _currentBoardId = boardId;
    _updateStatus(StreamStatus.connecting);

    await _startListening();
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
          debugPrint('[BoardStreamService] Received event: ${event.eventType}');
          if (!_disposed) {
            _eventController.add(event);
          }
        },
        onError: (error, _) {
          debugPrint('[BoardStreamService] Stream error: $error');
          _handleDisconnection(error: error);
        },
        onDone: () {
          debugPrint('[BoardStreamService] Stream closed');
          _handleDisconnection();
        },
        cancelOnError: false,
      );

      _updateStatus(StreamStatus.connected);
      _reconnectAttempts = 0;
      debugPrint('[BoardStreamService] Connected to board $_currentBoardId');
    } catch (e) {
      debugPrint('[BoardStreamService] Connection error: $e');
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
      unawaited(AuthService.signOut());
      debugPrint('[BoardStreamService] Auth error, disconnecting stream');
      return;
    }

    _updateStatus(StreamStatus.reconnecting);
    _subscription?.cancel();
    _subscription = null;

    // Retry after 3 seconds
    _reconnectTimer?.cancel();
    _reconnectAttempts++;
    final delay = _computeReconnectDelay(_reconnectAttempts);
    _reconnectTimer = Timer(delay, () {
      if (!_disposed && _currentBoardId != null && !_authInvalid) {
        debugPrint('[BoardStreamService] Attempting reconnect...');
        _startListening();
      }
    });
  }

  Duration _computeReconnectDelay(int attempt) {
    const baseSeconds = 3;
    final exponent = attempt.clamp(0, 4).toInt();
    final baseDelay = Duration(seconds: baseSeconds * (1 << exponent));
    final jitterMs = Random().nextInt(500);
    return baseDelay + Duration(milliseconds: jitterMs);
  }

  bool _isAuthError(Object? error) {
    if (error == null) return false;
    final message = error.toString().toLowerCase();
    return message.contains('jwt') ||
        message.contains('unauthorized') ||
        message.contains('not authenticated') ||
        message.contains('authentication') ||
        (message.contains('refresh') && message.contains('token'));
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
