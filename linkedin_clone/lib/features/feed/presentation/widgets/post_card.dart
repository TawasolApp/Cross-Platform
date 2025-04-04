import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'post_header.dart';
import 'post_content.dart';
import 'post_footer.dart';
import '../../domain/entities/post_entity.dart';
import '../provider/feed_provider.dart';
import '../../../../core/Navigation/route_names.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final updatedPost = Provider.of<FeedProvider>(
      context,
    ).posts.firstWhere((p) => p.id == post.id, orElse: () => post);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.push('/post_details', extra: updatedPost.id);
      },
      child: Container(
        width: screenWidth,
        color:
            isDarkMode ? const Color.fromARGB(255, 29, 34, 38) : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 6),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PostHeader(
                        profileImage: updatedPost.authorPicture ?? '',
                        authorName: updatedPost.authorName,
                        authorTitle: updatedPost.authorBio,
                        postTime: timeago.format(updatedPost.timestamp),
                        postId: updatedPost.id,
                        postContent: updatedPost.content,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                PostContent(
                  content: updatedPost.content,
                  imageUrl:
                      (updatedPost.media != null &&
                              updatedPost.media!.isNotEmpty)
                          ? post.media!.first
                          : null,
                ),
                const SizedBox(height: 8),
                PostFooter(
                  likes: updatedPost.likes,
                  comments: updatedPost.comments,
                  shares: updatedPost.shares,
                  post: updatedPost,
                  // onReact: (reactionName) {
                  //   Provider.of<FeedProvider>(context, listen: false).reactToPost(
                  //     postId: updatedPost.id,
                  //     reactions: {reactionName: true},
                  //   );
                  // },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
