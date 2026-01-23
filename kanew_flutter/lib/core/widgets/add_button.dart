import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final double size;

  const AddButton({
    super.key,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(Icons.add, size: size),
    );
  }
}
