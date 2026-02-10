import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../core/di/injection.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/widgets/sidebar/sidebar.dart';
import '../../../core/widgets/base/button.dart';
import '../../board/presentation/controllers/boards_page_controller.dart';

class BoardsPage extends StatefulWidget {
  final String workspaceSlug;

  const BoardsPage({super.key, required this.workspaceSlug});

  @override
  State<BoardsPage> createState() => _BoardsPageState();
}

class _BoardsPageState extends State<BoardsPage> {
  late final BoardsPageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = getIt<BoardsPageController>();
    _controller.loadBoards(widget.workspaceSlug);
  }

  @override
  void didUpdateWidget(covariant BoardsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.workspaceSlug != oldWidget.workspaceSlug) {
      _controller.loadBoards(widget.workspaceSlug);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = SidebarProvider.maybeOf(context);
    final isMobile = provider?.isMobile ?? false;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            leading: isMobile ? const SidebarTrigger() : null,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: _buildContent(_controller),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BoardsPageController controller) {
    if (controller.isLoading && controller.boards.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.error != null && controller.boards.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            controller.error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: 16),
          KanbnButton(
            label: 'Tentar novamente',
            variant: ButtonVariant.secondary,
            onPressed: () => _controller.loadBoards(widget.workspaceSlug),
          ),
        ],
      );
    }

    if (controller.boards.isEmpty) {
      return _buildEmptyState(controller);
    }

    return _buildBoardsGrid(controller);
  }

  Widget _buildEmptyState(BoardsPageController controller) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dashboard_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum board ainda',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crie seu primeiro board para comecar a organizar suas tarefas',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          KanbnButton(
            label: 'Criar primeiro board',
            variant: ButtonVariant.primary,
            iconLeft: const Icon(FIcons.plus),
            onPressed: () => _showCreateBoardDialog(context, controller),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardsGrid(BoardsPageController controller) {
    return RefreshIndicator(
      onRefresh: () => _controller.loadBoards(widget.workspaceSlug),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ...controller.boards.map(
              (board) => _BoardCard(
                board: board,
                onTap: () {
                  final boardId = board.id;
                  context.go(
                    RoutePaths.boardView(widget.workspaceSlug, board.slug),
                    extra: boardId == null ? null : {'boardId': boardId},
                  );
                },
              ),
            ),
            _NewBoardCard(
              onTap: () => _showCreateBoardDialog(context, controller),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateBoardDialog(
    BuildContext context,
    BoardsPageController controller,
  ) async {
    final titleController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Board'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Nome do board',
              hintText: 'Ex: Marketing Q1, Desenvolvimento, etc.',
            ),
            autofocus: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'O nome do board e obrigatorio';
              }
              return null;
            },
            onFieldSubmitted: (_) {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(context).pop(true);
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );

    if (result == true && titleController.text.trim().isNotEmpty) {
      await controller.createBoard(titleController.text.trim());
    }

    titleController.dispose();
  }
}

// ============================================================================
// BOARD CARDS
// ============================================================================

class _BoardCard extends StatelessWidget {
  final Board board;
  final VoidCallback? onTap;

  const _BoardCard({
    required this.board,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 200,
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                board.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                board.slug,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewBoardCard extends StatelessWidget {
  final VoidCallback? onTap;

  const _NewBoardCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 200,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outlineVariant,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FIcons.plus,
                size: 24,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                'Novo Board',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
