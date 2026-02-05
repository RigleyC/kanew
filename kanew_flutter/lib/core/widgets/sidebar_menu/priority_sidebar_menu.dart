import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../constants/priority_utils.dart';
import 'index.dart';

class PrioritySidebarMenu extends StatelessWidget {
  final CardPriority currentPriority;
  final Function(CardPriority) onSelect;

  const PrioritySidebarMenu({
    super.key,
    required this.currentPriority,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SidebarMenuAnchor(
      trigger: Icon(
        Icons.keyboard_arrow_down,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      items: CardPriority.values.map((priority) {
        return SidebarMenuItem(
          leading: SvgPicture.asset(
            priority.iconPath!,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              priority.color,
              BlendMode.srcIn,
            ),
          ),
          title: Text(
            priority.label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          trailing: priority == currentPriority
              ? Icon(
                  Icons.check,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
          onTap: () => onSelect(priority),
        );
      }).toList(),
    );
  }
}
