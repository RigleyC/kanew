import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';

/// Store for managing board filter state (client-side only).
/// Filters are applied locally and do not persist between reloads.
class BoardFilterStore extends ChangeNotifier {
  // Priority filter
  final Set<CardPriority> _priorities = {};

  // Label filter (for future use)
  final Set<int> _labelIds = {};

  // --- Getters ---

  Set<CardPriority> get priorities => Set.unmodifiable(_priorities);
  Set<int> get labelIds => Set.unmodifiable(_labelIds);

  /// Total count of active filters
  int get activeCount => _priorities.length + _labelIds.length;

  /// Whether any filter is active
  bool get hasActiveFilters => activeCount > 0;

  // --- Priority Operations ---

  void togglePriority(CardPriority priority) {
    if (_priorities.contains(priority)) {
      _priorities.remove(priority);
    } else {
      _priorities.add(priority);
    }
    notifyListeners();
  }

  bool isPrioritySelected(CardPriority priority) =>
      _priorities.contains(priority);

  // --- Label Operations ---

  void toggleLabel(int labelId) {
    if (_labelIds.contains(labelId)) {
      _labelIds.remove(labelId);
    } else {
      _labelIds.add(labelId);
    }
    notifyListeners();
  }

  bool isLabelSelected(int labelId) => _labelIds.contains(labelId);

  // --- Clear ---

  void clearAll() {
    _priorities.clear();
    _labelIds.clear();
    notifyListeners();
  }

  void clearPriorities() {
    _priorities.clear();
    notifyListeners();
  }

  void clearLabels() {
    _labelIds.clear();
    notifyListeners();
  }

  // --- Filter Logic ---

  /// Checks if a card passes all active filters.
  /// Within a category: OR logic (card matches ANY selected option)
  /// Between categories: AND logic (card must pass ALL categories)
  bool passesFilter(Card card) {
    // If no filters active, all cards pass
    if (!hasActiveFilters) return true;

    // Priority filter (OR within category)
    if (_priorities.isNotEmpty) {
      if (!_priorities.contains(card.priority)) {
        return false;
      }
    }

    // Label filter would go here (requires card.labels relationship)
    // if (_labelIds.isNotEmpty) {
    //   final cardLabelIds = card.labels?.map((l) => l.id).toSet() ?? {};
    //   if (_labelIds.intersection(cardLabelIds).isEmpty) {
    //     return false;
    //   }
    // }

    return true;
  }

  /// Filters a list of cards based on active filters
  List<Card> filterCards(List<Card> cards) {
    if (!hasActiveFilters) return cards;
    return cards.where(passesFilter).toList();
  }
}
