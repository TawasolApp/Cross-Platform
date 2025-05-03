import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import 'post_header.dart';
import 'post_content.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/Navigation/route_names.dart';

class MiniPostCard extends StatelessWidget {
  final PostEntity post;
  final String currentUserId;

  const MiniPostCard({
    super.key,
    required this.post,
    required this.currentUserId,
  });

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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.push(RouteNames.postDetails, extra: post.parentPost!.id);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        child:
            post.parentPost != null
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostHeader(
                      profileImage: post.parentPost!.authorPicture ?? '',
                      authorName: post.parentPost!.authorName,
                      authorTitle: post.parentPost!.authorBio,
                      postTime: formatTimeAgo(post.parentPost!.timestamp),
                      postId: post.parentPost!.id,
                      postContent: post.parentPost!.content,
                      visibility: post.parentPost!.visibility,
                      authorId: post.parentPost!.authorId,
                      currentUserId: currentUserId,
                      authorType: post.parentPost!.authorType,
                      isMiniPostCard:
                          true, // You might want to add a flag in PostHeader to shrink margin slightly.
                    ),
                    const SizedBox(height: 8),
                    PostContent(
                      content: post.parentPost!.content,
                      imageUrl:
                          (post.parentPost!.media != null &&
                                  post.parentPost!.media!.isNotEmpty)
                              ? post.parentPost!.media!.first
                              : null,
                    ),
                  ],
                )
                : Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      "Original post unavailable",
                      style: TextStyle(
                        color: Colors.red[400],
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
