import 'package:flutter/material.dart';
import 'reaction_popup.dart';
import 'package:linkedin_clone/features/feed/domain/entities/post_entity.dart';
import '../../../../core/utils/reaction_type.dart';

class LikeButton extends StatelessWidget {
  final PostEntity post;

  const LikeButton({super.key, required this.post});

  void _showReactionPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => ReactionPopup(
            postId: post.id,
            postType: "Post",
            onReactionSelected: (String) {},
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentReaction =
        post.reactions?.entries
            .firstWhere(
              (e) => e.value == true,
              orElse: () => const MapEntry('', false),
            )
            .key;

    final hasReacted = currentReaction != null && currentReaction.isNotEmpty;
    final reactionType = getReactionTypeFromName(currentReaction ?? '');

    final icon = hasReacted ? reactionType.icon : Icons.thumb_up_off_alt;

    final color = hasReacted ? reactionType.color : Colors.grey;

    final label = hasReacted ? reactionType.name : "Like";

    return GestureDetector(
      onTap: () => _showReactionPopup(context),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
