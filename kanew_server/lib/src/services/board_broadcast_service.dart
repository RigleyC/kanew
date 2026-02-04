import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service responsável por broadcast de eventos do Board em tempo real
class BoardBroadcastService {
  /// Retorna o nome do canal para um board específico
  static String channelName(int boardId) => 'board_$boardId';

  /// Broadcast genérico de evento
  static void broadcast(
    Session session, {
    required BoardEvent event,
  }) {
    session.messages.postMessage(
      channelName(event.boardId),
      event,
      global: true,
    );

    session.log(
      '[BoardBroadcast] ${event.eventType.name} on board ${event.boardId}',
    );
  }

  // === CARD EVENTS ===

  static void cardCreated(
    Session session, {
    required int boardId,
    required int listId,
    required int cardId,
    required int actorId,
    required CardSummary cardSummary,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.cardCreated,
        boardId: boardId,
        listId: listId,
        cardId: cardId,
        actorId: actorId,
        payload: jsonEncode({
          'card': cardSummary.toJson(),
        }),
        timestamp: DateTime.now(),
      ),
    );
  }

  static void cardUpdated(
    Session session, {
    required int boardId,
    required int listId,
    required int cardId,
    required int actorId,
    required Card card,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.cardUpdated,
        boardId: boardId,
        listId: listId,
        cardId: cardId,
        actorId: actorId,
        payload: jsonEncode({
          'card': card.toJson(),
        }),
        timestamp: DateTime.now(),
      ),
    );
  }

  static void cardMoved(
    Session session, {
    required int boardId,
    required int oldListId,
    required int newListId,
    required int cardId,
    required int actorId,
    required String newRank,
    required String priority,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.cardMoved,
        boardId: boardId,
        listId: newListId,
        cardId: cardId,
        actorId: actorId,
        payload: jsonEncode({
          'oldListId': oldListId,
          'newListId': newListId,
          'newRank': newRank,
          'priority': priority,
        }),
        timestamp: DateTime.now(),
      ),
    );
  }

  static void cardDeleted(
    Session session, {
    required int boardId,
    required int listId,
    required int cardId,
    required int actorId,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.cardDeleted,
        boardId: boardId,
        listId: listId,
        cardId: cardId,
        actorId: actorId,
        timestamp: DateTime.now(),
      ),
    );
  }

  // === LIST EVENTS ===

  static void listCreated(
    Session session, {
    required int boardId,
    required int listId,
    required int actorId,
    required CardList cardList,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.listCreated,
        boardId: boardId,
        listId: listId,
        actorId: actorId,
        payload: jsonEncode({
          'list': cardList.toJson(),
        }),
        timestamp: DateTime.now(),
      ),
    );
  }

  static void listUpdated(
    Session session, {
    required int boardId,
    required int listId,
    required int actorId,
    required CardList cardList,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.listUpdated,
        boardId: boardId,
        listId: listId,
        actorId: actorId,
        payload: jsonEncode({
          'list': cardList.toJson(),
        }),
        timestamp: DateTime.now(),
      ),
    );
  }

  static void listReordered(
    Session session, {
    required int boardId,
    required int actorId,
    required List<int> orderedListIds,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.listReordered,
        boardId: boardId,
        actorId: actorId,
        payload: jsonEncode({
          'orderedListIds': orderedListIds,
        }),
        timestamp: DateTime.now(),
      ),
    );
  }

  static void listDeleted(
    Session session, {
    required int boardId,
    required int listId,
    required int actorId,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.listDeleted,
        boardId: boardId,
        listId: listId,
        actorId: actorId,
        timestamp: DateTime.now(),
      ),
    );
  }

  // === BOARD EVENTS ===

  static void boardUpdated(
    Session session, {
    required int boardId,
    required int actorId,
    required Board board,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.boardUpdated,
        boardId: boardId,
        actorId: actorId,
        payload: jsonEncode({
          'board': board.toJson(),
        }),
        timestamp: DateTime.now(),
      ),
    );
  }

  static void boardDeleted(
    Session session, {
    required int boardId,
    required int actorId,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.boardDeleted,
        boardId: boardId,
        actorId: actorId,
        timestamp: DateTime.now(),
      ),
    );
  }
}
