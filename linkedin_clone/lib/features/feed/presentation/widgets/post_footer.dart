import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import '../../domain/entities/post_entity.dart';
import 'reaction_popup.dart';
import 'package:linkedin_clone/core/utils/reaction_type.dart';
import 'package:go_router/go_router.dart';

class PostFooter extends StatefulWidget {
  final PostEntity post;
  final int comments;
  final int shares;

  const PostFooter({
    super.key,
    required this.post,
    required this.comments,
    required this.shares,
  });

  @override
  _PostFooterState createState() => _PostFooterState();
}

ReactionType getReactionTypeByName(String name) {
  return ReactionType.values.firstWhere(
    (reaction) => reaction.name.toLowerCase() == name.toLowerCase(),
    orElse: () => ReactionType.like, // Default to "Like" if not found
  );
}

class _PostFooterState extends State<PostFooter> {
  String currentReactionName = 'Like';

  void _showReactionPopup(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => ReactionPopup(
            postId: widget.post.id,
            onReactionSelected: (reactionName) {
              setState(() {
                currentReactionName = reactionName;
              });
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current reaction type based on the name
    ReactionType currentReaction = getReactionTypeByName(currentReactionName);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                currentReactionName = 'Like';
              });
            },
            onLongPress: () => _showReactionPopup(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  currentReaction.icon,
                  size: 22,
                  color: currentReaction.color,
                ),
                const SizedBox(height: 2),
                Text(
                  currentReaction.name,
                  style: TextStyle(color: currentReaction.color, fontSize: 12),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap:
                () =>
                    context.push(RouteNames.postDetails, extra: widget.post.id),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.comment_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(height: 2),
                Text(
                  "Comment",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.loop, size: 20, color: Colors.grey),
              const SizedBox(height: 2),
              Text(
                "Repost",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.send_outlined, size: 20, color: Colors.grey),
              const SizedBox(height: 2),
              Text(
                "Send",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
