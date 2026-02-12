import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../../core/constants/label_colors.dart';

class LabelChip extends StatelessWidget {
  final String name;
  final String colorHex;
  final VoidCallback? onTap;
  final bool showDelete;
  final VoidCallback? onDelete;

  const LabelChip({
    super.key,
    required this.name,
    required this.colorHex,
    this.onTap,
    this.showDelete = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = LabelColors.parseHex(colorHex);

    return RawChip(
      labelPadding: const EdgeInsets.only(left: 2, right: 4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      avatar: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: labelColor,
        ),
      ),
      label: Text(
        name,
        style: Theme.of(context).textTheme.labelMedium,
      ),

      deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white70),
      onDeleted: onDelete,
    );
  }
}
