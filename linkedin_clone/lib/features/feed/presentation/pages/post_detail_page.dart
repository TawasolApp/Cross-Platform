import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/add_comment_field.dart';
import '../widgets/comment_list.dart';
//import '../../domain/entities/post_entity.dart';

class PostDetailsPage extends StatelessWidget {
  final String postId;

  const PostDetailsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final String postId = ModalRoute.of(context)!.settings.arguments as String;
    // Fetch post details and comments on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      feedProvider.fetchComments(postId);
    });

    final post = feedProvider.posts.firstWhereOrNull((p) => p.id == postId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Details"),
        backgroundColor: Colors.white,
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

                  const Divider(height: 1),

                  // Comments Section
                  Expanded(
                    child:
                        feedProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : feedProvider.errorMessage != null
                            ? Center(child: Text(feedProvider.errorMessage!))
                            : CommentList(postId: postId),
                  ),

                  // Add Comment Field
                  AddCommentField(postId: postId),
                ],
              ),
    );
  }
}
