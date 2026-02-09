import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../../core/services/file_picker_service.dart';
import '../../data/card_repository.dart';
import '../../data/checklist_repository.dart';
import '../../data/comment_repository.dart';
import '../../data/activity_repository.dart';
import '../../data/label_repository.dart';
import '../../data/attachment_repository.dart';
import '../store/board_store.dart';

class CardDetailPageController extends ChangeNotifier {
  final CardRepository _repository;
  final ChecklistRepository _checklistRepo;
  final CommentRepository _commentRepo;
  final ActivityRepository _activityRepo;
  final LabelRepository _labelRepo;
  final AttachmentRepository _attachmentRepo;
  final FilePickerService _filePicker;
  final BoardStore _boardStore;

  Card? _card;
  CardList? _list;
  List<Checklist> _checklists = [];
  final Map<int, List<ChecklistItem>> _checklistItems = {};
  List<Comment> _comments = [];
  List<CardActivity> _activities = [];
  List<LabelDef> _labels = []; // Labels attached to this card
  List<Attachment> _attachments = [];

  bool _isLoading = false;
  bool _isUploading = false;
  bool _isDisposed = false;
  String? _error;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  CardDetailPageController({
    required CardRepository repository,
    required ChecklistRepository checklistRepo,
    required CommentRepository commentRepo,
    required ActivityRepository activityRepo,
    required LabelRepository labelRepo,
    required AttachmentRepository attachmentRepo,
    required FilePickerService filePicker,
    required BoardStore boardStore,
  }) : _repository = repository,
       _checklistRepo = checklistRepo,
       _commentRepo = commentRepo,
       _activityRepo = activityRepo,
       _labelRepo = labelRepo,
       _attachmentRepo = attachmentRepo,
       _filePicker = filePicker,
       _boardStore = boardStore;

  // Getters - delegate to BoardStore for shared context
  Card? get selectedCard => _card;
  CardList? get list => _list;
  List<Checklist> get checklists => _checklists;
  Map<int, List<ChecklistItem>> get checklistItems => _checklistItems;
  List<Comment> get comments => _comments;
  List<CardActivity> get activities => _activities;
  List<LabelDef> get labels => _labels;
  List<LabelDef> get boardLabels => _boardStore.labels;
  List<Attachment> get attachments => _attachments;
  List<CardList> get boardLists => _boardStore.lists;
  List<WorkspaceMember> get members => _boardStore.members;
  Board? get board => _boardStore.board;
  Workspace? get workspace => _boardStore.workspace;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get error => _error;

  List<ChecklistItem> getItemsForChecklist(int checklistId) {
    return _checklistItems[checklistId] ?? [];
  }

  Future<void> load(String cardUuid) async {
    _isLoading = true;
    _error = null;
    _safeNotify();

    final result = await _repository.getCardDetailByUuid(cardUuid);

    result.fold(
      (f) => _error = f.message,
      (detail) {
        if (detail != null) {
          _card = detail.card;
          _list = detail.currentList;

          // Checklists and items
          _checklists = detail.checklists.map((c) => c.checklist).toList();
          _checklistItems.clear();
          for (final c in detail.checklists) {
            if (c.checklist.id != null) {
              _checklistItems[c.checklist.id!] = c.items;
            }
          }

          _attachments = detail.attachments;
          _labels = detail.cardLabels;
          _comments = detail.recentComments;
          _activities = detail.recentActivities;

          // Cache CardDetail in BoardStore
          _boardStore.cacheCardDetail(detail);
        } else {
          _error = 'Card não encontrado';
        }
      },
    );

    _isLoading = false;
    _safeNotify();
  }

  Future<void> _loadActivities(int cardId) async {
    final result = await _activityRepo.getLog(cardId);
    result.fold(
      (f) => _error = f.message, // Non-fatal
      (activities) => _activities = activities,
    );
  }

  Future<void> createComment(String content) async {
    if (_card == null) return;

    final result = await _commentRepo.createComment(_card!.id!, content);
    result.fold(
      (f) => _error = f.message,
      (comment) {
        _comments.insert(0, comment);
        // Reload activity to show the "commented" log
        _loadActivities(_card!.id!);
        _safeNotify();
      },
    );
  }

  Future<void> deleteComment(int commentId) async {
    final result = await _commentRepo.deleteComment(commentId);
    result.fold(
      (f) => _error = f.message,
      (_) {
        _comments.removeWhere((c) => c.id == commentId);
        _safeNotify();
      },
    );
  }

  Future<void> createChecklist(String title) async {
    if (_card == null) return;

    final result = await _checklistRepo.createChecklist(_card!.id!, title);
    result.fold(
      (f) => _error = f.message,
      (checklist) {
        _checklists.add(checklist);
        _checklistItems[checklist.id!] = [];
        _safeNotify();
      },
    );
  }

  Future<void> deleteChecklist(int checklistId) async {
    final result = await _checklistRepo.deleteChecklist(checklistId);
    result.fold(
      (f) => _error = f.message,
      (_) {
        _checklists.removeWhere((c) => c.id == checklistId);
        _checklistItems.remove(checklistId);
        _safeNotify();
      },
    );
  }

  Future<void> addItem(int checklistId, String title) async {
    final result = await _checklistRepo.addItem(checklistId, title);
    result.fold(
      (f) => _error = f.message,
      (item) {
        final items = _checklistItems[checklistId] ?? [];
        items.add(item);
        _checklistItems[checklistId] = items;
        _safeNotify();
      },
    );
  }

  Future<void> toggleItem(int checklistId, int itemId, bool isChecked) async {
    // Optimistic update
    final items = _checklistItems[checklistId];
    if (items == null) return;

    final index = items.indexWhere((i) => i.id == itemId);
    if (index == -1) return;

    final oldItem = items[index];
    items[index] = oldItem.copyWith(isChecked: isChecked);
    _safeNotify();

    final result = await _checklistRepo.updateItem(
      itemId,
      isChecked: isChecked,
    );
    result.fold(
      (f) {
        // Revert
        items[index] = oldItem;
        _error = f.message;
        _safeNotify();
      },
      (updatedItem) {
        // Confirm
        items[index] = updatedItem;
        _safeNotify();
      },
    );
  }

  Future<void> deleteItem(int checklistId, int itemId) async {
    // Optimistic update
    final items = _checklistItems[checklistId];
    if (items == null) return;

    final originalItems = List<ChecklistItem>.from(items);
    items.removeWhere((i) => i.id == itemId);
    _safeNotify();

    final result = await _checklistRepo.deleteItem(itemId);
    result.fold(
      (f) {
        // Revert
        _checklistItems[checklistId] = originalItems;
        _error = f.message;
        _safeNotify();
      },
      (_) {}, // Success
    );
  }

  Future<void> attachLabel(int labelId) async {
    if (_card == null) return;

    // Check if already attached locally
    if (_labels.any((l) => l.id == labelId)) return;

    // Optimistic update
    final labelToAdd = boardLabels.firstWhere((l) => l.id == labelId);
    _labels.add(labelToAdd);
    _safeNotify();

    final result = await _labelRepo.attachLabel(_card!.id!, labelId);
    result.fold(
      (f) {
        _labels.removeWhere((l) => l.id == labelId);
        _error = f.message;
        _safeNotify();
      },
      (_) => _loadActivities(_card!.id!), // Reload activity to show label added
    );
  }

  Future<void> detachLabel(int labelId) async {
    if (_card == null) return;

    // Optimistic update
    final labelToRemove = _labels.firstWhere((l) => l.id == labelId);
    _labels.removeWhere((l) => l.id == labelId);
    _safeNotify();

    final result = await _labelRepo.detachLabel(_card!.id!, labelId);
    result.fold(
      (f) {
        _labels.add(labelToRemove);
        _error = f.message;
        _safeNotify();
      },
      (_) =>
          _loadActivities(_card!.id!), // Reload activity to show label removed
    );
  }

  Future<void> createLabel(String name, String colorHex) async {
    if (_card == null) return;

    final result = await _labelRepo.createLabel(_card!.boardId, name, colorHex);
    result.fold(
      (f) => _error = f.message,
      (label) {
        // Note: boardLabels is from BoardStore, we can't modify it directly
        // The label will be available after next load
        // Automatically attach the newly created label
        attachLabel(label.id!);
      },
    );
  }

  /// Result of the last upload operation.
  /// null = no upload yet, true = success, false = failed
  bool? _lastUploadResult;
  String? _lastUploadError;

  bool? get lastUploadResult => _lastUploadResult;
  String? get lastUploadError => _lastUploadError;

  /// Uploads an attachment and returns success status.
  /// Returns: true if upload succeeded, false if failed, null if cancelled
  Future<bool?> uploadAttachment() async {
    if (_card == null) return null;

    _lastUploadResult = null;
    _lastUploadError = null;

    final file = await _filePicker.pickFile();

    if (file == null) return null; // User cancelled

    _isUploading = true;
    _safeNotify();

    final uploadResult = await _attachmentRepo.uploadAttachment(
      _card!.id!,
      file,
    );

    _isUploading = false;

    return uploadResult.fold(
      (f) {
        _lastUploadError = f.message;
        _lastUploadResult = false;
        _safeNotify();
        return false;
      },
      (attachment) {
        _attachments.insert(0, attachment);
        _lastUploadResult = true;
        _loadActivities(_card!.id!);
        _safeNotify();
        return true;
      },
    );
  }

  Future<void> deleteAttachment(int attachmentId) async {
    if (_card == null) return;

    // Optimistic update
    final originalList = List<Attachment>.from(_attachments);
    _attachments.removeWhere((a) => a.id == attachmentId);
    _safeNotify();

    final result = await _attachmentRepo.deleteAttachment(attachmentId);
    result.fold(
      (f) {
        _attachments = originalList;
        _error = f.message;
        _safeNotify();
      },
      (_) => _loadActivities(_card!.id!),
    );
  }

  Future<Card?> updateCard({
    String? title,
    String? description,
    DateTime? dueDate,
    CardPriority? priority,
  }) async {
    if (_card == null || _card?.id == null) return null;

    final result = await _repository.updateCard(
      _card!.id!,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
    );

    return result.fold(
      (f) {
        _error = f.message;
        _safeNotify();
        return null;
      },
      (card) {
        _card = card;
        _boardStore.updateCard(card); // Update store!
        _safeNotify();
        return card;
      },
    );
  }

  Future<Card?> loadCardByUuid(String uuid) async {
    await load(uuid);
    return _card;
  }

  Future<void> moveCardToList(int newListId) async {
    if (_card == null) return;

    // Optimistic update
    final oldList = _list;
    final newList = boardLists.firstWhere((l) => l.id == newListId);

    _list = newList;
    _card = _card!.copyWith(listId: newListId);
    _boardStore.updateCard(_card!); // Update store!
    _safeNotify();

    final result = await _repository.moveCard(_card!.id!, newListId);

    result.fold(
      (f) {
        // Revert
        _list = oldList;
        _card = _card!.copyWith(listId: oldList?.id ?? 0);
        _boardStore.updateCard(_card!); // Revert store!
        _error = f.message;
        _safeNotify();
      },
      (card) {
        // Update with server data just in case
        _card = card;
        _boardStore.updateCard(card); // Confirm store!
        _loadActivities(card.id!);
        _safeNotify();
      },
    );
  }
}
