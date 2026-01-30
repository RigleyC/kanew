import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../../core/constants/priority_utils.dart';
import '../../../../core/widgets/searchable_list_content.dart';

class PriorityPicker extends StatelessWidget {
  final CardPriority currentPriority;
  final Function(CardPriority) onSelect;
  final VoidCallback? onClose;

  const PriorityPicker({
    super.key,
    required this.currentPriority,
    required this.onSelect,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SearchableListContent<CardPriority>(
      items: CardPriority.values.toList(),
      selectedItems: [currentPriority],
      labelBuilder: (p) => p.label,
      leadingBuilder: (p) => SvgPicture.asset(
        p.iconPath!,
        width: 16,
        height: 16,
        colorFilter: ColorFilter.mode(
          p.color,
          BlendMode.srcIn,
        ),
      ),
      onSelect: onSelect,
      onClose: onClose,
      closeOnSelect: true,
      isEqual: (a, b) => a == b,
      searchHint: 'Buscar prioridade...',
    );
  }
}
