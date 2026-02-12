import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service responsável por broadcast de eventos do Board em tempo real
class BoardBroadcastService {
  /// Retorna o nome do canal para um board específico
  static String channelName(UuidValue boardId) => 'board_$boardId';

  /// Broadcast genérico de evento
  static void broadcast(
    Session session, {
    required BoardEvent event,
  }) {
    final useGlobal = session.serverpod.redisController != null;
    session.messages.postMessage(
      channelName(event.boardId),
      event,
      global: useGlobal,
    );

    session.log(
      '[BoardBroadcast] ${event.eventType.name} on board ${event.boardId} (global=$useGlobal)',
    );
  }

  // === CARD EVENTS ===

  static void cardCreated(
    Session session, {
    required UuidValue boardId,
    required UuidValue listId,
    required UuidValue cardId,
    required UuidValue actorId,
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
    required UuidValue boardId,
    required UuidValue listId,
    required UuidValue cardId,
    required UuidValue actorId,
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
    required UuidValue boardId,
    required UuidValue oldListId,
    required UuidValue newListId,
    required UuidValue cardId,
    required UuidValue actorId,
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
    required UuidValue boardId,
    required UuidValue listId,
    required UuidValue cardId,
    required UuidValue actorId,
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
    required UuidValue boardId,
    required UuidValue listId,
    required UuidValue actorId,
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
    required UuidValue boardId,
    required UuidValue listId,
    required UuidValue actorId,
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
    required UuidValue boardId,
    required UuidValue actorId,
    required List<UuidValue> orderedListIds,
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
    required UuidValue boardId,
    required UuidValue listId,
    required UuidValue actorId,
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
    required UuidValue boardId,
    required UuidValue actorId,
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
    required UuidValue boardId,
    required UuidValue actorId,
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

  // === LABEL EVENTS ===

  static void labelCreated(
    Session session, {
    required UuidValue boardId,
    required UuidValue labelId,
    required UuidValue actorId,
    required LabelDef label,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.labelCreated,
        boardId: boardId,
        actorId: actorId,
        payload: jsonEncode({
          'label': label.toJson(),
        }),
        timestamp: DateTime.now(),
      ),
    );
  }

  static void labelUpdated(
    Session session, {
    required UuidValue boardId,
    required UuidValue labelId,
    required UuidValue actorId,
    required LabelDef label,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.labelUpdated,
        boardId: boardId,
        actorId: actorId,
        payload: jsonEncode({
          'label': label.toJson(),
        }),
        timestamp: DateTime.now(),
      ),
    );
  }

  static void labelDeleted(
    Session session, {
    required UuidValue boardId,
    required UuidValue labelId,
    required UuidValue actorId,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.labelDeleted,
        boardId: boardId,
        actorId: actorId,
        payload: jsonEncode({
          'labelId': labelId,
        }),
        timestamp: DateTime.now(),
      ),
    );
  }

  static void cardLabelsUpdated(
    Session session, {
    required UuidValue boardId,
    required UuidValue cardId,
    required UuidValue listId,
    required UuidValue actorId,
    required List<LabelDef> labels,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        eventType: BoardEventType.cardLabelsUpdated,
        boardId: boardId,
        cardId: cardId,
        listId: listId,
        actorId: actorId,
        payload: jsonEncode({
          'labels': labels.map((l) => l.toJson()).toList(),
        }),
        timestamp: DateTime.now(),
      ),
    );
  }

  static void checklistItemsReordered(
    Session session, {
    required UuidValue boardId,
    required UuidValue checklistId,
    required UuidValue actorId,
    required List<UuidValue> orderedItemIds,
  }) {
    broadcast(
      session,
      event: BoardEvent(
        // Use boardUpdated for backwards compatibility with clients that
        // don't know checklistItemsReordered yet.
        eventType: BoardEventType.boardUpdated,
        boardId: boardId,
        actorId: actorId,
        payload: jsonEncode({
          'event': 'checklistItemsReordered',
          'checklistId': checklistId.toString(),
          'orderedItemIds': orderedItemIds.map((id) => id.toString()).toList(),
        }),
        timestamp: DateTime.now(),
      ),
    );
  }
}
