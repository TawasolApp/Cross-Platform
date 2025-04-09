import 'package:flutter/material.dart';

class ReactionIconWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isHighlighted;

  const ReactionIconWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isHighlighted ? 38 : 28, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isHighlighted ? 12 : 10,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
