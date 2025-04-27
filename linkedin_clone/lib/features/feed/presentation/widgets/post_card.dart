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
            if (isSilentRepost || isRepostWithThoughts)
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
            if (!isSilentRepost)
              PostContent(
                content: post.content,
                imageUrl:
                    post.media != null && post.media!.isNotEmpty
                        ? post.media!.first
                        : null,
              ),
            if (isRepostWithThoughts)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
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
                            Text(
                              post.parentPost!.authorName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              post.parentPost!.content,
                              style: const TextStyle(fontSize: 13),
                            ),
                            if (post.parentPost!.media!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    post.parentPost!.media!.first,
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
            const SizedBox(height: 8),
            ReactionSummaryBar(post: post),
            const Divider(height: 2),
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

// /////////////
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../domain/entities/post_entity.dart';
// import '../provider/feed_provider.dart';
// import 'post_header.dart';
// import 'post_content.dart';
// import 'reaction_bar.dart';
// import 'post_footer.dart';

// class PostCard extends StatefulWidget {
//   final PostEntity post;
//   final String currentUserId;
//   final String? profileImage;
//   final String profileName;
//   final String? profileTitle;

//   const PostCard({
//     super.key,
//     required this.post,
//     required this.currentUserId,
//     required this.profileImage,
//     required this.profileName,
//     required this.profileTitle,
//   });

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   PostEntity? _parentPost;
//   bool _isLoadingParent = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchParentPost();
//   }

//   Future<void> _fetchParentPost() async {
//     if (widget.post.parentPostId != null &&
//         widget.post.parentPostId!.isNotEmpty) {
//       setState(() {
//         _isLoadingParent = true;
//       });
//       final feedProvider = Provider.of<FeedProvider>(context, listen: false);
//       final fetchedParent = await feedProvider.fetchPostById(
//         widget.post.parentPostId!,
//       );
//       print("Fetched parent post: $fetchedParent");
//       print("Fetched parent post id: ${widget.post.parentPostId}");
//       if (mounted) {
//         setState(() {
//           _parentPost = fetchedParent;
//           _isLoadingParent = false;
//         });
//       }
//     } else {
//       print("No parent post ID found for this post.");
//     }
//   }

//   String formatTimeAgo(DateTime timestamp) {
//     final duration = DateTime.now().difference(timestamp);
//     if (duration.inSeconds < 60) {
//       return '${duration.inSeconds}s';
//     } else if (duration.inMinutes < 60) {
//       return '${duration.inMinutes}m';
//     } else if (duration.inHours < 24) {
//       return '${duration.inHours}h';
//     } else if (duration.inDays < 30) {
//       return '${duration.inDays}d';
//     } else if (duration.inDays < 365) {
//       return '${(duration.inDays / 30).floor()}mon';
//     } else {
//       return '${(duration.inDays / 365).floor()}y';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final isSilentRepost =
//         widget.post.isSilentRepost == true && widget.post.parentPostId != null;
//     final isRepostWithThoughts =
//         widget.post.isSilentRepost == false && widget.post.parentPostId != null;

//     return Card(
//       color: isDarkMode ? Colors.grey[900] : Colors.white,
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (isSilentRepost || isRepostWithThoughts)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: Text(
//                   "${widget.post.authorName} reposted",
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: isDarkMode ? Colors.grey[300] : Colors.grey,
//                   ),
//                 ),
//               ),
//             PostHeader(
//               profileImage: widget.post.authorPicture ?? '',
//               authorName: widget.post.authorName,
//               authorTitle: widget.post.authorBio,
//               postTime: formatTimeAgo(widget.post.timestamp),
//               postId: widget.post.id,
//               postContent: widget.post.content,
//               visibility: widget.post.visibility,
//               authorId: widget.post.authorId,
//               currentUserId: widget.currentUserId,
//               authorType: widget.post.authorType,
//             ),
//             const SizedBox(height: 8),

//             if (!isSilentRepost)
//               PostContent(
//                 content: widget.post.content,
//                 imageUrl:
//                     widget.post.media != null && widget.post.media!.isNotEmpty
//                         ? widget.post.media!.first
//                         : null,
//               ),

//             if ((isSilentRepost || isRepostWithThoughts) && !_isLoadingParent)
//               _parentPost != null
//                   ? _buildParentPostPreview(context)
//                   : const Text(
//                     "⚠️ Original post unavailable",
//                     style: TextStyle(fontSize: 13, color: Colors.red),
//                   ),

//             if (_isLoadingParent)
//               const Center(child: CircularProgressIndicator()),

//             const SizedBox(height: 8),
//             ReactionSummaryBar(post: widget.post),
//             const Divider(height: 2),
//             PostFooter(
//               post: widget.post,
//               comments: widget.post.comments,
//               shares: widget.post.shares,
//               profileImage: widget.profileImage,
//               profileName: widget.profileName,
//               profileTitle: widget.profileTitle,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildParentPostPreview(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       margin: const EdgeInsets.only(top: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             _parentPost!.authorName,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//           ),
//           const SizedBox(height: 4),
//           Text(_parentPost!.content, style: const TextStyle(fontSize: 13)),
//           if (_parentPost!.media != null && _parentPost!.media!.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(top: 8),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   _parentPost!.media!.first,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
