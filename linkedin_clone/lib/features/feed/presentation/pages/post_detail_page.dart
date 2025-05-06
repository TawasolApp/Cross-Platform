import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/add_comment_field.dart';
import '../../../profile/presentation/provider/profile_provider.dart';
import '../widgets/reaction_summary_bar.dart';
import '../widgets/comment_list.dart';
import '../../domain/entities/post_entity.dart';

class PostDetailsPage extends StatefulWidget {
  final String postId;

  const PostDetailsPage({super.key, required this.postId});

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  late Future<PostEntity?> postFuture;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      final profile = Provider.of<ProfileProvider>(context, listen: false);
      profile.fetchProfile("");
      feedProvider.fetchComments(widget.postId);
      feedProvider.getPostReactions(widget.postId);
      final myId = profile.userId ?? '';
      postFuture = feedProvider.fetchPostById(myId, widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final profile = Provider.of<ProfileProvider>(context);
    final myId = profile.userId;
    final post = feedProvider.fetchPostById(myId ?? '', widget.postId);
    // feedProvider.posts.firstWhereOrNull((p) => p.id == widget.postId) ??
    // feedProvider.userPosts.firstWhereOrNull((p) => p.id == widget.postId);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (post == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Post Details")),
        body: Center(
          child: Text(
            "Post not found",
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Post Details"),
        backgroundColor: isDarkMode ? Colors.black : Colors.blue,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0.5,
      ),
      body: Stack(
        children: [
          // Scrollable post + comments
          Padding(
            padding: const EdgeInsets.only(
              bottom: 60,
            ), // leave room for AddCommentField
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      FutureBuilder<PostEntity?>(
                        future: postFuture, // your Future<PostEntity?>
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // or shimmer
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return const Text('Post not found');
                          } else {
                            final actualPost = snapshot.data!;
                            return PostCard(
                              post: actualPost,
                              currentUserId: myId ?? '',
                              profileImage: actualPost.authorPicture,
                              profileName: actualPost.authorName,
                              profileTitle: actualPost.authorBio,
                            );
                          }
                        },
                      ),
                      // PostCard(
                      //   post: postFuture as PostEntity,
                      //   currentUserId: myId ?? '',
                      //   profileImage: profile.profilePicture,
                      //   profileName: profile.fullName,
                      //   profileTitle: profile.headline,
                      // ),
                      ReactionSummaryBar(postId: widget.postId),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: Consumer<FeedProvider>(
                    builder: (context, feedProvider, child) {
                      if (feedProvider.errorMessage != null) {
                        return Center(child: Text(feedProvider.errorMessage!));
                      }

                      return CommentList(
                        postId: widget.postId,
                        currentUserId: profile.userId ?? '',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Fixed comment input at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: AddCommentField(
                key: const ValueKey("main-comment"),
                postId: widget.postId,
                isReply: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
