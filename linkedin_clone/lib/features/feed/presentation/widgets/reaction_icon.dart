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
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isHighlighted ? 38 : 18, color: color),
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

IconData getReactionIcon(String reactionType) {
  switch (reactionType) {
    case 'Like':
      return Icons.thumb_up;
    case 'Love':
      return Icons.favorite;
    case 'Celebrate':
      return Icons.celebration;
    case 'Support':
      return Icons.volunteer_activism;
    case 'Insightful':
      return Icons.lightbulb;
    case 'Funny':
      return Icons.emoji_emotions;
    default:
      return Icons.thumb_up_off_alt;
  }
}

Color getReactionColor(String reactionType) {
  switch (reactionType) {
    case 'Like':
      return Colors.blue;
    case 'Love':
      return Colors.red;
    case 'Celebrate':
      return const Color.fromARGB(255, 63, 131, 65);

    case 'Support':
      return const Color.fromARGB(255, 190, 98, 206);
    case 'Insightful':
      return Colors.amber;
    case 'Funny':
      return Colors.teal;
    default:
      return Colors.grey;
  }
}
