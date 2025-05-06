import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/feed/domain/entities/post_entity.dart';
import 'package:linkedin_clone/features/feed/presentation/provider/feed_provider.dart';
import 'package:linkedin_clone/features/feed/presentation/widgets/post_header.dart';
import 'package:linkedin_clone/features/feed/presentation/widgets/post_content.dart';
import 'package:linkedin_clone/features/feed/presentation/widgets/reaction_bar.dart';
import 'package:linkedin_clone/features/feed/presentation/widgets/post_footer.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class UserPostCard extends StatelessWidget {
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
  const UserPostCard({
    super.key,
    required this.post,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SizedBox(
        height: 300, // Fixed height for horizontal ListView
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
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
                  profileImage: post.authorPicture ?? '',
                  profileName: post.authorName,
                  profileTitle: post.authorBio,
                  showRepostButton: post.authorId == currentUserId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserPostsPreview extends StatelessWidget {
  const UserPostsPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    // Ensure we have loaded posts for this user
    if (feedProvider.userPosts.isEmpty) {
      feedProvider.fetchUserPosts(profileProvider.userId!, forceRefresh: true);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal post list
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "User posts",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth * 0.8;

                  if (feedProvider.isLoading &&
                      feedProvider.userPosts.isEmpty) {
                    return const SizedBox(
                      height: 300,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (feedProvider.userPosts.isEmpty) {
                    return SizedBox(
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No posts yet',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: feedProvider.userPosts.length.clamp(0, 4),
                      itemBuilder: (context, index) {
                        final post = feedProvider.userPosts[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: SizedBox(
                            width: itemWidth,
                            child: UserPostCard(
                              post: post,
                              currentUserId: profileProvider.userId!,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Show all posts button
        Center(
          child: SizedBox(
            width: double.infinity, // Take full width
            child: TextButton(
              onPressed: () {
                // Navigate to user posts page
                Navigator.pushNamed(
                  context,
                  '/user-posts',
                  arguments: profileProvider.userId,
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Show all posts",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(width: 5),
                  Icon(Icons.arrow_forward, color: Colors.grey[700]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
