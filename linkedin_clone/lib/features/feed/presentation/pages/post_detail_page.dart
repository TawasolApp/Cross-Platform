import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/add_comment_field.dart';
import '../widgets/comment_list.dart';
import '../../../profile/presentation/provider/profile_provider.dart';
import '../widgets/reaction_summary_bar.dart';

class PostDetailsPage extends StatefulWidget {
  final String postId;

  const PostDetailsPage({super.key, required this.postId});

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      final profile = Provider.of<ProfileProvider>(context, listen: false);
      profile.fetchProfile("");
      feedProvider.fetchComments(widget.postId);
      feedProvider.getPostReactions(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final profile = Provider.of<ProfileProvider>(context);
    final myId = profile.userId;
    final post =
        feedProvider.posts.firstWhereOrNull((p) => p.id == widget.postId) ??
        feedProvider.userPosts.firstWhereOrNull((p) => p.id == widget.postId);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Post Details"),
        backgroundColor: isDarkMode ? Colors.black : Colors.blue,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0.5,
      ),
      body:
          post == null
              ? Center(
                child: Text(
                  "Post not found",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              )
              : Column(
                children: [
                  // Display the post using PostCard
                  PostCard(
                    post: post,
                    currentUserId: myId ?? '',
                    profileImage: profile.profilePicture,
                    profileName: profile.fullName,
                    profileTitle: profile.headline,
                  ),
                  ReactionSummaryBar(postId: widget.postId),
                  //const Divider(height: 1),

                  // Comments Section
                  Expanded(
                    child: Consumer<FeedProvider>(
                      builder: (context, feedProvider, child) {
                        if (feedProvider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (feedProvider.errorMessage != null) {
                          return Center(
                            child: Text(feedProvider.errorMessage!),
                          );
                        }

                        print("myId: $myId");
                        print("${profile.profilePicture}");

                        return CommentList(
                          postId: widget.postId,
                          currentUserId: profile.userId ?? '',
                        );
                      },
                    ),
                  ),

                  // Add Comment Field
                  SafeArea(child: AddCommentField(postId: widget.postId)),
                ],
              ),
    );
  }
}
