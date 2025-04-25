import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import 'post_header.dart';
import 'post_content.dart';
import 'reaction_bar.dart';
import 'post_footer.dart';

class PostCard extends StatelessWidget {
  String formatTimeAgo(DateTime timestamp) {
    final duration = DateTime.now().difference(timestamp);
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h';
    } else if (duration.inDays < 30) {
      return '${duration.inDays}d';
    } else if (duration.inDays < 365) {
      return '${(duration.inDays / 30).floor()}mon';
    } else {
      return '${(duration.inDays / 365).floor()}y';
    }
  }

  final PostEntity post;
  final String currentUserId;
  const PostCard({super.key, required this.post, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
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
              postTime: formatTimeAgo(post.timestamp),
              postId: post.id,
              postContent: post.content,
              visibility: post.visibility,
              authorId: post.authorId,
              currentUserId: currentUserId,
              authorType: post.authorType,
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
