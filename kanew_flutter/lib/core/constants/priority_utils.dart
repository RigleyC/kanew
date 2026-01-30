import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';

extension CardPriorityExtension on CardPriority {
  String get label => switch (this) {
        CardPriority.none => 'Nenhuma',
        CardPriority.low => 'Baixa',
        CardPriority.medium => 'Média',
        CardPriority.high => 'Alta',
        CardPriority.urgent => 'Urgente',
      };

  Color get color => switch (this) {
        CardPriority.none => const Color(0xFF9E9E9E),
        CardPriority.low => const Color(0xFF4CAF50),
        CardPriority.medium => const Color(0xFFFFC107),
        CardPriority.high => const Color(0xFFE53935),
        CardPriority.urgent => const Color(0xFFB71C1C),
      };

  String? get iconPath => switch (this) {
        CardPriority.none => 'assets/icons/priority_none.svg',
        CardPriority.low => 'assets/icons/priority_low.svg',
        CardPriority.medium => 'assets/icons/priority_medium.svg',
        CardPriority.high => 'assets/icons/priority_high.svg',
        CardPriority.urgent => 'assets/icons/priority_urgent.svg',
      };


}
