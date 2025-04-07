import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import 'post_header.dart';
import 'post_content.dart';
import 'reaction_bar.dart';
import 'post_footer.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(
              profileImage: post.authorPicture ?? '',
              authorName: post.authorName,
              authorTitle: post.authorBio,
              postTime: post.timestamp.toString(),
              postId: post.id,
              postContent: post.content,
              visibility: post.visibility ?? 'Public',
            ),
            const SizedBox(height: 8),
            PostContent(
              content: post.content,
              imageUrl:
                  post.media != null && post.media!.isNotEmpty
                      ? post.media!.first
                      : null,
            ),
            const SizedBox(height: 8),
            ReactionSummaryBar(post: post),
            const Divider(height: 2),
            PostFooter(
              post: post,
              comments: post.comments,
              shares: post.shares,
            ),
          ],
        ),
      ),
    );
  }
}
