import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/auth_helper.dart';
import '../services/permission_service.dart';
import '../services/board_broadcast_service.dart';

/// Endpoint para streaming de eventos do Board em tempo real
class BoardStreamEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Subscreve para receber atualizações em tempo real do board.
  /// Requer: board.read permission
  ///
  /// O cliente recebe eventos sempre que:
  /// - Um card é criado, atualizado, movido ou deletado
  /// - Uma lista é criada, atualizada, reordenada ou deletada
  /// - O board é atualizado ou deletado
  Stream<BoardEvent> subscribeToBoardUpdates(
    Session session,
    int boardId,
  ) async* {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    // Buscar board para validar e obter workspaceId
    final board = await Board.db.findById(session, boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    // Validar permissão
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.read',
    );

    if (!hasPermission) {
      throw Exception('Permission denied');
    }

    // Log de conexão
    session.log(
      '[BoardStream] User $userId subscribed to board $boardId',
    );

    // Detectar desconexão para cleanup
    session.addWillCloseListener((context) {
      session.log(
        '[BoardStream] User $userId disconnected from board $boardId',
      );
    });

    // Criar stream para o canal do board
    final channelName = BoardBroadcastService.channelName(boardId);
    final updateStream = session.messages.createStream<BoardEvent>(channelName);

    // Retransmitir todos os eventos para o cliente
    await for (final event in updateStream) {
      yield event;
    }
  }
}
