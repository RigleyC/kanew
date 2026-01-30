import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:url_launcher/url_launcher.dart';

class AttachmentCard extends StatelessWidget {
  final Attachment attachment;
  final VoidCallback onDelete;

  const AttachmentCard({
    super.key,
    required this.attachment,
    required this.onDelete,
  });

  Future<void> _download() async {
    if (attachment.fileUrl != null) {
      final uri = Uri.parse(attachment.fileUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

 

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: _download,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Image.network(attachment.fileUrl!),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  attachment.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  _formatSize(attachment.size),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onDelete,
              tooltip: 'Remover',
            ),
          ],
        ),
      ),
    );
  }
}
