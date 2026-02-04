import 'dart:async';
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
  final ValueNotifier<StreamStatus> statusNotifier =
      ValueNotifier(StreamStatus.disconnected);

  StreamSubscription<BoardEvent>? _subscription;
  final StreamController<BoardEvent> _eventController =
      StreamController<BoardEvent>.broadcast();
  Timer? _reconnectTimer;

  int? _currentBoardId;
  bool _disposed = false;

  BoardStreamService({required Client client}) : _client = client;

  Stream<BoardEvent> get events => _eventController.stream;

  StreamStatus get status => _status;

  /// Connects to board stream with auto-reconnect
  Future<void> connect(int boardId) async {
    if (_disposed) return;

    _currentBoardId = boardId;
    _updateStatus(StreamStatus.connecting);

    await _startListening();
  }

  Future<void> _startListening() async {
    if (_disposed || _currentBoardId == null) return;

    try {
      // Subscribe to board updates
      final stream = _client.boardStream.subscribeToBoardUpdates(_currentBoardId!);

      _subscription = stream.listen(
        (event) {
          if (!_disposed) {
            _eventController.add(event);
          }
        },
        onError: (error) {
          debugPrint('[BoardStreamService] Stream error: $error');
          _handleDisconnection();
        },
        onDone: () {
          debugPrint('[BoardStreamService] Stream closed');
          _handleDisconnection();
        },
        cancelOnError: false,
      );

      _updateStatus(StreamStatus.connected);
      debugPrint('[BoardStreamService] Connected to board $_currentBoardId');
    } catch (e) {
      debugPrint('[BoardStreamService] Connection error: $e');
      _handleDisconnection();
    }
  }

  void _handleDisconnection() {
    if (_disposed) return;

    _updateStatus(StreamStatus.reconnecting);
    _subscription?.cancel();
    _subscription = null;

    // Retry after 3 seconds
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      if (!_disposed && _currentBoardId != null) {
        debugPrint('[BoardStreamService] Attempting reconnect...');
        _startListening();
      }
    });
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
    statusNotifier.dispose();
  }
}
