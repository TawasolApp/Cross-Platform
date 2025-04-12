import 'package:flutter/material.dart';

enum ReactionType { like, celebrate, love, insightful, funny, support, none }

extension ReactionTypeExtension on ReactionType {
  String get name {
    switch (this) {
      case ReactionType.like:
        return 'Like';
      case ReactionType.celebrate:
        return 'Celebrate';
      case ReactionType.love:
        return 'Love';
      case ReactionType.insightful:
        return 'Insightful';
      case ReactionType.funny:
        return 'Funny';
      case ReactionType.support:
        return 'Support';
      case ReactionType.none:
      default:
        return 'None';
    }
  }

  IconData get icon {
    switch (this) {
      case ReactionType.like:
        return Icons.thumb_up;
      case ReactionType.celebrate:
        return Icons.celebration;
      case ReactionType.love:
        return Icons.favorite;
      case ReactionType.insightful:
        return Icons.lightbulb;
      case ReactionType.funny:
        return Icons.emoji_emotions;
      case ReactionType.support:
        return Icons.volunteer_activism;
      case ReactionType.none:
      default:
        return Icons.thumb_up_off_alt;
    }
  }

  Color get color {
    switch (this) {
      case ReactionType.like:
        return Colors.blue;
      case ReactionType.celebrate:
        return const Color.fromARGB(255, 63, 131, 65);
      case ReactionType.love:
        return Colors.red;
      case ReactionType.insightful:
        return Colors.amber;
      case ReactionType.funny:
        return Colors.teal;
      case ReactionType.support:
        return const Color.fromARGB(255, 190, 98, 206);
      case ReactionType.none:
      default:
        return Colors.grey;
    }
  }
}
