import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/reaction_model.dart';
import '../provider/feed_provider.dart';
import '../../../../core/utils/reaction_type.dart';

class ReactionSummaryBar extends StatelessWidget {
  final String postId;
  final String postType;

  const ReactionSummaryBar({
    super.key,
    this.postType = "Post",
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final reactions =
        postType == "Post"
            ? feedProvider.postReactions
            : feedProvider.commentReactions[postId] ?? [];

    //final reactions = feedProvider.postReactions;

    if (reactions.isEmpty) return const SizedBox();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Reactions',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () {
            context.push('/reactions', extra: postId);
          },
          child: SizedBox(
            height: 48, //56
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: reactions.length > 10 ? 10 : reactions.length,
              itemBuilder: (context, index) {
                final user = reactions[index];
                final type = getReactionTypeFromName(user.type);
                final color = getReactionColor(type.name);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.authorPicture),
                        radius: 20,
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Icon(type.icon, color: color, size: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  IconData _reactionIcon(String type) {
    switch (type) {
      case 'Like':
        return Icons.thumb_up_alt_rounded;
      case 'Celebrate':
        return Icons.emoji_events;
      case 'Funny':
        return Icons.emoji_emotions;
      case 'Love':
        return Icons.favorite;
      case 'Insightful':
        return Icons.lightbulb;
      case 'Support':
        return Icons.volunteer_activism;
      default:
        return Icons.thumb_up_off_alt;
    }
  }
}
