import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'post_header.dart';
import 'post_content.dart';
import 'post_footer.dart';
import '../../domain/entities/post_entity.dart';
import '../provider/feed_provider.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final updatedPost = Provider.of<FeedProvider>(
      context,
    ).posts.firstWhere((p) => p.id == post.id, orElse: () => post);
    return Container(
      width: screenWidth,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PostHeader(
                  profileImage: post.authorPicture ?? '',
                  authorName: post.authorName,
                  authorTitle: post.authorBio,
                  postTime: timeago.format(post.timestamp),
                  postId: post.id,
                ),
              ),
            ],
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
            likes: updatedPost.likes,
            comments: updatedPost.comments,
            shares: updatedPost.shares,
            post: updatedPost,
          ),
        ],
      ),
    );
  }
}
