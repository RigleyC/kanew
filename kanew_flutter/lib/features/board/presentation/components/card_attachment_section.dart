import 'package:flutter/material.dart' hide Card;
import '../controllers/card_detail_controller.dart';
import '../widgets/attachment_card.dart';
import '../../../../core/utils/ui_helpers.dart';

/// Section that displays and manages card attachments.
///
/// Shows a list of attachments with upload button and feedback.
class CardAttachmentSection extends StatelessWidget {
  final CardDetailPageController controller;

  const CardAttachmentSection({
    super.key,
    required this.controller,
  });

  Future<void> _handleUpload() async {
    final result = await controller.uploadAttachment();

    if (result == null) {
      // User cancelled - no feedback needed
      return;
    }

    if (result) {
      showSuccessToast(title: 'Arquivo enviado com sucesso!');
    } else {
      final errorMessage = controller.lastUploadError ?? 'Erro desconhecido';
      showErrorToast(
        title: 'Falha no upload',
        description: errorMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final attachments = controller.attachments;
    final isUploading = controller.isUploading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.attach_file,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Anexos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    attachments.length.toString(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            isUploading
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    onPressed: _handleUpload,
                    icon: const Icon(Icons.add, size: 16),
                    style: IconButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
          ],
        ),
        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            mainAxisExtent: 64,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: attachments.length,
          itemBuilder: (context, index) {
            final attachment = attachments[index];
            return AttachmentCard(
              attachment: attachment,
              onDelete: () => controller.deleteAttachment(attachment.id!),
            );
          },
        ),
      ],
    );
  }
}
