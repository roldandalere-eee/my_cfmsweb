import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String label;

  const StatusChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (label.toUpperCase()) {
      case 'AVAILABLE':
      case 'RESOLVED':
      case 'COMPLETED':
        bg = const Color(0xFFD1F2D9);
        fg = const Color(0xFF1B5E20);
        break;
      case 'ON TASK':
      case 'PENDING':
      case 'IN PROGRESS':
        bg = const Color(0xFFFFF3CD);
        fg = const Color(0xFF856404);
        break;
      default:
        bg = const Color(0xFFE2E3E5);
        fg = const Color(0xFF383D41);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
