import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import 'comment_item.dart';

class CommentList extends StatelessWidget {
  final String postId;
  final String currentUserId;
  const CommentList({
    super.key,
    required this.postId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (context, feedProvider, child) {
        final comments =
            feedProvider.comments
                .where((comment) => comment.postId == postId)
                .toList();
        if (feedProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (feedProvider.errorMessage != null) {
          return Center(
            child: Text(
              feedProvider.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (comments.isEmpty) {
          return const Center(
            child: Text(
              'No comments yet',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return Container(
          color: Colors.white, // Set the background color to white
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: feedProvider.comments.length,
            itemBuilder: (context, index) {
              final comment = feedProvider.comments[index];
              return CommentItem(
                comment: comment,
                currentUserId: currentUserId,
              );
            },
          ),
        );
      },
    );
  }
}
