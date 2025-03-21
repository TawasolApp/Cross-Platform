import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'post_header.dart';
import 'post_content.dart';
import 'post_footer.dart';
import '../../domain/entities/post_entity.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(
            profileImage: post.authorPicture ?? '',
            authorName: post.authorName,
            authorTitle: post.authorBio,
            postTime: timeago.format(post.timestamp),
          ),
          const SizedBox(height: 8),

          PostContent(
            content: post.content,
            imageUrl:
                (post.media != null && post.media!.isNotEmpty)
                    ? post.media!.first
                    : null,
          ),
          const SizedBox(height: 8),

          PostFooter(
            likes: post.likes,
            comments: post.comments,
            shares: post.shares,
          ),
        ],
      ),
    );
  }
}
