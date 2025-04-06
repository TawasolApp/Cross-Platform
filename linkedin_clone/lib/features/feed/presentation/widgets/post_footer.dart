import 'package:flutter/material.dart';
import 'like_button.dart';
import '../../domain/entities/post_entity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostFooter extends StatelessWidget {
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
  Widget build(BuildContext context) {
    bool isLiked = post.reactType == 'Like';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        LikeButton(isLiked: isLiked, postId: post.id),
        Row(
          children: [
            const Icon(Icons.comment, color: Colors.grey, size: 20),
            const SizedBox(width: 4),
            Text("Comment", style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.loop, color: Colors.grey, size: 20),
            const SizedBox(width: 4),
            Text("Repost", style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.send, color: Colors.grey, size: 20),
            const SizedBox(width: 4),
            Text("Send", style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }
}
