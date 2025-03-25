import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import '../../domain/entities/post_entity.dart';

class ReactionBar extends StatelessWidget {
  final PostEntity post;

  const ReactionBar({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Provider.of<FeedProvider>(
              context,
              listen: false,
            ).reactToPost(postId: post.id, reactions: {"Like": !post.isLiked});
          },
          child: Row(
            children: [
              Icon(
                post.isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                color:
                    post.isLiked
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                "${post.likes} Likes",
                style: TextStyle(
                  color:
                      post.isLiked
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Text(
          "${post.comments} Comments",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          "${post.shares} Shares",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
