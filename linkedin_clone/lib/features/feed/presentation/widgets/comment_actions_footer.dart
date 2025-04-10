import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';

class CommentActionsFooter extends StatelessWidget {
  final String commentId;
  final String postId;
  final String authorId;
  //final String currentUserId;

  const CommentActionsFooter({
    super.key,
    required this.commentId,
    required this.postId,
    required this.authorId,
    //required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildActionText(context, "Like", () {
            // Like functionality
          }),
          _buildSeparator(),
          _buildActionText(context, "Reply", () {
            // Reply functionality
          }),
          // if (authorId == currentUserId)
          _buildSeparator(),
          //if (authorId == currentUserId)
          _buildActionText(context, "Delete", () async {
            await Provider.of<FeedProvider>(
              context,
              listen: false,
            ).deleteComment(postId, commentId);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Comment deleted successfully")),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionText(
    BuildContext context,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text('|', style: TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }
}
