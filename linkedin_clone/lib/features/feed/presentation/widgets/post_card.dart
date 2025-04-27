import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import 'post_header.dart';
import 'post_content.dart';
import 'reaction_bar.dart';
import 'post_footer.dart';
import 'mini_post_card.dart';

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
  final String? profileImage;
  final String profileName;
  final String? profileTitle;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.profileImage,
    required this.profileName,
    required this.profileTitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isSilentRepost =
        post.isSilentRepost == true && post.parentPost != null;
    final isRepostWithThoughts =
        post.isSilentRepost == false && post.parentPost != null;

    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSilentRepost)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "${post.authorName} reposted",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[300] : Colors.grey,
                  ),
                ),
              ),
            if (!isSilentRepost)
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
            // if (isSilentRepost && post.parentPost != null)
            //   PostCard(
            //     post: post.parentPost!,
            //     currentUserId: currentUserId,
            //     profileImage: post.parentPost!.authorPicture ?? '',
            //     profileName: post.parentPost!.authorName,
            //     profileTitle: post.parentPost!.authorBio,
            //   ),
            if (!isSilentRepost)
              PostContent(
                content: post.content,
                imageUrl:
                    post.media != null && post.media!.isNotEmpty
                        ? post.media!.first
                        : null,
              ),
            if (isRepostWithThoughts)
              MiniPostCard(post: post, currentUserId: currentUserId),
            const SizedBox(height: 8),
            ReactionSummaryBar(post: post),
            const Divider(height: 2, color: Colors.grey),
            PostFooter(
              post: post,
              comments: post.comments,
              shares: post.shares,
              profileImage: profileImage,
              profileName: profileName,
              profileTitle: profileTitle,
            ),
          ],
        ),
      ),
    );
  }
}
