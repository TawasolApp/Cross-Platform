import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import 'comment_item.dart';

class CommentList extends StatelessWidget {
  final String postId;

  const CommentList({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (context, feedProvider, child) {
        if (feedProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (feedProvider.comments.isEmpty) {
          return const Center(child: Text("No comments yet."));
        }

        return Container(
          color: Colors.white, // Set the background color to white
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: feedProvider.comments.length,
            itemBuilder: (context, index) {
              final comment = feedProvider.comments[index];
              return CommentItem(comment: comment);
            },
          ),
        );
      },
    );
  }
}
