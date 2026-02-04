import 'dart:developer' as developer;

import 'package:flutter/material.dart' hide Card;
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/background/dot_background.dart';
import '../../../../core/widgets/reconnecting_toast.dart';
import '../../data/board_stream_service.dart';
import '../controllers/board_view_controller.dart';
import '../widgets/board_header.dart';
import '../widgets/kanban_board.dart';

class BoardViewPage extends StatefulWidget {
  final String workspaceSlug;
  final String boardSlug;

  const BoardViewPage({
    super.key,
    required this.workspaceSlug,
    required this.boardSlug,
  });

  @override
  State<BoardViewPage> createState() => _BoardViewPageState();
}

class _BoardViewPageState extends State<BoardViewPage> {
  late final BoardViewPageController _controller;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _controller = getIt<BoardViewPageController>();
    _loadBoard();
  }

  Future<void> _loadBoard() async {
    // Carrega diretamente usando slugs da URL - sem depender do WorkspaceController
    await _controller.load(widget.workspaceSlug, widget.boardSlug);
  }

  @override
  void dispose() {
    developer.log('BoardViewPage disposed', name: 'board_view_page');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        // Handle board deleted
        if (_controller.boardDeleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Board foi deletado')),
            );
          });
        }

        if (_localError != null) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(title: const Text('Erro')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    _localError!,
                    style: TextStyle(color: colorScheme.error),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: context.pop,
                    child: const Text('Voltar'),
                  ),
                ],
              ),
            ),
          );
        }

        final board = _controller.board;
        if (board == null && !_controller.isLoading) {
          // Only show not found if done loading
          if (_controller.error != null) {
            return _buildNotFoundPage(context, colorScheme);
          }
          // Initial loading state
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (board == null) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              const Positioned.fill(
                child: PatternedBackground(),
              ),
              Column(
                children: [
                  BoardHeader(
                    board: board,
                    workspaceSlug: widget.workspaceSlug,
                    onBack: context.pop,
                    onTitleChanged: (newTitle) async {
                      await _controller.updateBoard(board.id!, newTitle);
                    },
                  ),
                  Expanded(
                    child: KanbanBoard(
                      controller: _controller,
                      workspaceSlug: widget.workspaceSlug,
                      boardSlug: widget.boardSlug,
                      board: board,
                    ),
                  ),
                ],
              ),
              // Reconnecting toast
              ValueListenableBuilder<StreamStatus>(
                valueListenable: _controller.streamStatus,
                builder: (context, status, _) {
                  if (status == StreamStatus.reconnecting) {
                    return const Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(child: ReconnectingToast()),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        );
      },
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
        title: const Text('Board não encontrado'),
      ),
      body: Center(
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
              'Board não encontrado',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'O board "${widget.boardSlug}" não existe ou foi removido.',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
