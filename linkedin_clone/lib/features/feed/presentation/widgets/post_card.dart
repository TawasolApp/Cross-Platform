import 'package:flutter/cupertino.dart';
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
  final bool isEmbedded; // Add this line to define the isEmbedded variable
  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.profileImage,
    required this.profileName,
    required this.profileTitle,
    this.isEmbedded =
        false, // Add this line to initialize the isEmbedded variable
  });
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isSilentRepost =
        post.isSilentRepost == true && post.parentPost != null;
    final isRepostWithThoughts =
        post.isSilentRepost == false && post.parentPost != null;

    final mainContent = Padding(
      padding:
          isSilentRepost || isEmbedded
              ? EdgeInsets.only(top: 8)
              : const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSilentRepost)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: Text(
                "${post.authorName} reposted this",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey,
                ),
              ),
            ),
          if (isSilentRepost)
            const Divider(
              color: CupertinoColors.lightBackgroundGray,
              height: 2,
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
          if (isSilentRepost && post.parentPost != null)
            PostCard(
              post: post.parentPost!,
              currentUserId: currentUserId,
              profileImage: post.parentPost!.authorPicture ?? '',
              profileName: post.parentPost!.authorName,
              profileTitle: post.parentPost!.authorBio,
              isEmbedded: false,
            ),
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
          if (!isSilentRepost && !isEmbedded) ReactionSummaryBar(post: post),
          if (!isSilentRepost) const Divider(height: 2, color: Colors.grey),
          if ((!isSilentRepost || post.parentPostId == null) && !isEmbedded)
            PostFooter(
              post: post,
              comments: post.comments,
              shares: post.shares,
              profileImage: profileImage,
              profileName: profileName,
              profileTitle: profileTitle,
              showRepostButton: post.authorId == currentUserId && !isEmbedded,
              // (post.authorId == currentUserId ||
              //     post.isSilentRepost == true) &&
              // post.parentPost != null,
            ),
        ],
      ),
    );

    if (isEmbedded) {
      return mainContent;
    }

    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: mainContent,
    );
  }

  //   return Card(
  //     color: isDarkMode ? Colors.grey[900] : Colors.white,
  //     margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     child: Padding(
  //       padding: isSilentRepost ? EdgeInsets.zero : EdgeInsets.all(10),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           if (isSilentRepost)
  //             Padding(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 12,
  //                 vertical: 2,
  //               ),
  //               child: Text(
  //                 "${post.authorName} reposted",
  //                 style: TextStyle(
  //                   fontSize: 13,
  //                   color: isDarkMode ? Colors.grey[300] : Colors.grey,
  //                 ),
  //               ),
  //             ),
  //           if (!isSilentRepost)
  //             PostHeader(
  //               profileImage: post.authorPicture ?? '',
  //               authorName: post.authorName,
  //               authorTitle: post.authorBio,
  //               postTime: formatTimeAgo(post.timestamp),
  //               postId: post.id,
  //               postContent: post.content,
  //               visibility: post.visibility,
  //               authorId: post.authorId,
  //               currentUserId: currentUserId,
  //               authorType: post.authorType,
  //             ),
  //           const SizedBox(height: 8),
  //           // if (isSilentRepost && post.parentPost != null)
  //           //   EmbeddedPostCard(
  //           //     post: post.parentPost!,
  //           //     currentUserId: currentUserId,
  //           //   ),
  //           if (!isSilentRepost)
  //             PostContent(
  //               content: post.content,
  //               imageUrl:
  //                   post.media != null && post.media!.isNotEmpty
  //                       ? post.media!.first
  //                       : null,
  //             ),
  //           if (isRepostWithThoughts)
  //             MiniPostCard(post: post, currentUserId: currentUserId),
  //           const SizedBox(height: 8),
  //           ReactionSummaryBar(post: post),
  //           if (!isSilentRepost) const Divider(height: 2, color: Colors.grey),
  //           if (!isSilentRepost)
  //             PostFooter(
  //               post: post,
  //               comments: post.comments,
  //               shares: post.shares,
  //               profileImage: profileImage,
  //               profileName: profileName,
  //               profileTitle: profileTitle,
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
