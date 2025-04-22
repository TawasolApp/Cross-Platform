import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';

class CommentActionsFooter extends StatelessWidget {
  final String commentId;
  final String postId;
  final String authorId;
  final String currentUserId;
  final String commentContent;

  const CommentActionsFooter({
    super.key,
    required this.commentId,
    required this.postId,
    required this.authorId,
    required this.currentUserId,
    required this.commentContent,
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
          if (authorId == currentUserId) _buildSeparator(),
          if (authorId == currentUserId)
            _buildActionText(context, "Edit", () {
              _showEditDialog(context);
            }),

          if (authorId == currentUserId) _buildSeparator(),
          if (authorId == currentUserId)
            _buildActionText(context, "Delete", () async {
              await Provider.of<FeedProvider>(
                context,
                listen: false,
              ).deleteComment(currentUserId, postId, commentId);
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

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: commentContent);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Edit Comment"),
          content: TextField(
            controller: controller,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Update your comment",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final updatedText = controller.text.trim();
                if (updatedText.isNotEmpty && updatedText != commentContent) {
                  await Provider.of<FeedProvider>(
                    context,
                    listen: false,
                  ).editComment(
                    currentUserId,
                    commentId: commentId,
                    updatedContent: updatedText,
                    isReply: false,
                  );

                  Navigator.pop(context);

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text("Comment updated successfully"),
                  //   ),
                  // );
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
