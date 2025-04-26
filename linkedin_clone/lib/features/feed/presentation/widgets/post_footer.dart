import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import '../../domain/entities/post_entity.dart';
import 'reaction_popup.dart';
import 'package:linkedin_clone/core/utils/reaction_type.dart';
import 'package:go_router/go_router.dart';
import '../provider/feed_provider.dart';
import 'package:provider/provider.dart';
import 'repost_bottom_sheet.dart';

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

class _PostFooterState extends State<PostFooter> {
  void _showReactionPopup(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => ReactionPopup(
            postId: widget.post.id,
            onReactionSelected: (reaction) {
              setState(() {});
            },
          ),
    );
  }

  void _handleTapReaction(BuildContext context) {
    final hasReacted =
        widget.post.reactType.isNotEmpty &&
        widget.post.reactType.toLowerCase() != 'none';

    final provider = Provider.of<FeedProvider>(context, listen: false);
    final reactionToSend = hasReacted ? 'none' : 'Like';

    provider.reactToPost(widget.post.id, {reactionToSend: true}, "Post");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasReacted =
        widget.post.reactType.isNotEmpty &&
        widget.post.reactType.toLowerCase() != 'none';
    final reaction = getReactionTypeFromName(widget.post.reactType);

    final icon = hasReacted ? reaction.icon : Icons.thumb_up_off_alt;
    final color = hasReacted ? reaction.color : Colors.grey;
    final label = hasReacted ? reaction.name : 'Like';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => _handleTapReaction(context),
            onLongPress: () => _showReactionPopup(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 22, color: color),
                const SizedBox(height: 2),
                Text(label, style: TextStyle(color: color, fontSize: 12)),
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

          GestureDetector(
            onTap: () {
              showRepostBottomSheet(context, widget.post.id);
            },

            child: Column(
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
