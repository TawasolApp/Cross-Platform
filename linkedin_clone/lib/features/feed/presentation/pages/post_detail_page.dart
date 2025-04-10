import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/add_comment_field.dart';
import '../widgets/comment_list.dart';

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
    // Fetch comments when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      feedProvider.fetchComments(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final post = feedProvider.posts.firstWhereOrNull(
      (p) => p.id == widget.postId,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Post Details"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body:
          post == null
              ? const Center(child: Text("Post not found"))
              : Column(
                children: [
                  // Display the post using PostCard
                  PostCard(post: post),

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

                        return CommentList(postId: widget.postId);
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
  // @override
  // Widget build(BuildContext context) {
  //   final feedProvider = Provider.of<FeedProvider>(context);
  //   final post = feedProvider.posts.firstWhereOrNull(
  //     (p) => p.id == widget.postId,
  //   );

  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     //resizeToAvoidBottomInset: true,
  //     appBar: AppBar(
  //       title: const Text("Post Details"),
  //       backgroundColor: Colors.blue,
  //       foregroundColor: Colors.black,
  //       elevation: 0.5,
  //     ),
  //     body:
  //         post == null
  //             ? const Center(child: Text("Post not found"))
  //             : Column(
  //               children: [
  //                 // ✅ Scrollable area (post + comments)
  //                 Expanded(
  //                   child: ListView(
  //                     padding: const EdgeInsets.only(bottom: 8),
  //                     children: [
  //                       PostCard(post: post),
  //                       Consumer<FeedProvider>(
  //                         builder: (context, feedProvider, child) {
  //                           if (feedProvider.isLoading) {
  //                             return const Center(
  //                               child: Padding(
  //                                 padding: EdgeInsets.all(16),
  //                                 child: CircularProgressIndicator(),
  //                               ),
  //                             );
  //                           }

  //                           if (feedProvider.errorMessage != null) {
  //                             return Padding(
  //                               padding: const EdgeInsets.all(16),
  //                               child: Center(
  //                                 child: Text(feedProvider.errorMessage!),
  //                               ),
  //                             );
  //                           }

  //                           return CommentList(postId: widget.postId);
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ),

  //                 // ✅ Fixed safe comment field
  //                 const Divider(height: 1),
  //                 SafeArea(child: AddCommentField(postId: widget.postId)),
  //               ],
  //             ),
  //   );
  // }

