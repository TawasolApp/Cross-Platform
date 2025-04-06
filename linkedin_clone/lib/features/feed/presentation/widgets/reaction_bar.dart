import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';

class ReactionSummaryBar extends StatelessWidget {
  final PostEntity post;

  const ReactionSummaryBar({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    int totalReactions =
        post.reactCounts?.values.fold(0, (sum, count) => sum! + count) ?? 0;

    return Row(
      children: [
        Icon(Icons.thumb_up, color: Colors.blue, size: 16),
        const SizedBox(width: 4),
        Text(
          "$totalReactions reactions",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(width: 8),
        Text(
          "${post.comments} comments",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(width: 8),
        Text(
          "${post.shares} shares",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }
}
