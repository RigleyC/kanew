import 'package:flutter/material.dart' hide Card;
import 'package:go_router/go_router.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:kanew_flutter/features/board/presentation/components/card_title_editor.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/sidebar/sidebar.dart';
import '../controllers/card_detail_controller.dart';
import '../components/card_activity_section.dart';
import '../components/card_detail_header.dart';
import '../components/card_detail_sidebar.dart';
import '../components/card_description_editor.dart';
import '../components/card_comment_input.dart';
import '../components/card_attachment_section.dart';
import '../widgets/checklist_widget.dart';

/// Card Detail Page - Two-column layout following kan.bn design
///
/// Refactored to use dedicated components for Header, Sidebar, Editors, etc.
class CardDetailPage extends StatefulWidget {
  final String workspaceSlug;
  final String boardSlug;
  final String cardUuid;

  const CardDetailPage({
    super.key,
    required this.workspaceSlug,
    required this.boardSlug,
    required this.cardUuid,
  });

  @override
  State<CardDetailPage> createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  late final CardDetailPageController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = getIt<CardDetailPageController>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _loadCard();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadCard() async {
    // Carrega diretamente pelo cardUuid
    await _controller.load(widget.cardUuid);
  }

  String _getListName(int listId) {
    return _controller.list?.title ?? 'Lista';
  }

  void _showAddChecklistDialog(BuildContext context) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar checklist'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Título da checklist',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _controller.createChecklist(value);
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                _controller.createChecklist(title);
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = SidebarProvider.maybeOf(context);
    final isMobile = provider?.isMobile ?? false;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final card = _controller.selectedCard;

        if (_controller.isLoading && card == null) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (card == null) {
          // Only show not found if not loading
          if (_controller.isLoading) {
            return Scaffold(
              backgroundColor: colorScheme.surface,
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          return _buildNotFoundPage(context, colorScheme);
        }

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: Column(
            children: [
              CardDetailHeader(
                workspaceSlug: widget.workspaceSlug,
                boardSlug: widget.boardSlug,
                listName: _getListName(card.listId),
                isMobile: isMobile,
                onClose: () => context.go(
                  RoutePaths.boardView(widget.workspaceSlug, widget.boardSlug),
                ),
              ),
              Expanded(
                child: isMobile
                    ? _buildMobileLayout(colorScheme, card)
                    : _buildDesktopLayout(colorScheme, card),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(ColorScheme colorScheme, Card card) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: _buildMainContent(colorScheme, card),
          ),
        ),

        // Sidebar
        VerticalDivider(width: 1, color: colorScheme.outlineVariant),
        SizedBox(
          width: 280,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: CardDetailSidebar(
              card: card,
              listName: _getListName(card.listId),
              boardLists: _controller.boardLists,
              labels: _controller.labels,
              boardLabels: _controller.boardLabels,
              onAddChecklist: () => _showAddChecklistDialog(context),
              onDueDateChanged: (date) {
                _controller.updateCard(dueDate: date);
              },
              onToggleLabel: (labelId) {
                if (_controller.labels.any((l) => l.id == labelId)) {
                  _controller.detachLabel(labelId);
                } else {
                  _controller.attachLabel(labelId);
                }
              },
              onCreateLabel: (name, color) {
                _controller.createLabel(name, color);
              },
              onListChanged: (newListId) {
                _controller.moveCardToList(newListId);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(ColorScheme colorScheme, Card card) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainContent(colorScheme, card),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          CardDetailSidebar(
            card: card,
            listName: _getListName(card.listId),
            boardLists: _controller.boardLists,
            labels: _controller.labels,
            boardLabels: _controller.boardLabels,
            onAddChecklist: () => _showAddChecklistDialog(context),
            onDueDateChanged: (date) {
              _controller.updateCard(dueDate: date);
            },
            onToggleLabel: (labelId) {
              if (_controller.labels.any((l) => l.id == labelId)) {
                _controller.detachLabel(labelId);
              } else {
                _controller.attachLabel(labelId);
              }
            },
            onCreateLabel: (name, color) {
              _controller.createLabel(name, color);
            },
            onListChanged: (newListId) {
              _controller.moveCardToList(newListId);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(ColorScheme colorScheme, Card card) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        CardTitleEditor(
          initialTitle: card.title,
          onSave: (newTitle) => _controller.updateCard(title: newTitle),
        ),
        const SizedBox(height: 24),

        // Description
        CardDescriptionEditor(
          initialDescription: card.descriptionDocument,
          onSave: (newDesc) => _controller.updateCard(description: newDesc),
        ),
        const SizedBox(height: 32),

        // Checklists
        if (_controller.checklists.isNotEmpty) ...[
          ..._controller.checklists.map(
            (checklist) => ChecklistWidget(
              checklist: checklist,
              items: _controller.getItemsForChecklist(checklist.id!),
              controller: _controller,
            ),
          ),
          const SizedBox(height: 32),
        ],

        // Attachments
        CardAttachmentSection(controller: _controller),
        const SizedBox(height: 32),

        // Activity
        CardActivitySection(controller: _controller),
        const SizedBox(height: 24),

        // Comment input
        CardCommentInput(
          onSubmit: (text) => _controller.createComment(text),
        ),
      ],
    );
  }

  Widget _buildNotFoundPage(BuildContext context, ColorScheme colorScheme) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: context.pop,
        ),
        title: const Text('Card não encontrado'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Card não encontrado',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'O card pode ter sido excluído ou você não tem permissão.',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go(
                RoutePaths.boardView(widget.workspaceSlug, widget.boardSlug),
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar ao Board'),
            ),
          ],
        ),
      ),
    );
  }
}
