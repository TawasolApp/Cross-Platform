import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';

class CommentActionsBottomSheet extends StatelessWidget {
  final String commentId;
  final String postId;
  final String commentContent;

  const CommentActionsBottomSheet({
    super.key,
    required this.commentId,
    required this.postId,
    required this.commentContent,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(height: 4, width: 40, color: Colors.grey[300]),
          const SizedBox(height: 16),

          // Edit Comment Action
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Comment'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController _controller =
                      TextEditingController(text: commentContent);
                  return AlertDialog(
                    title: const Text('Edit Comment'),
                    content: TextField(
                      controller: _controller,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: 'Update your comment',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // final updatedContent = _controller.text.trim();
                          // if (updatedContent.isNotEmpty) {
                          //   await Provider.of<FeedProvider>(
                          //     context,
                          //     listen: false,
                          //   ).editComment(
                          //     commentId: commentId,
                          //     content: updatedContent,
                          //     taggedUsers:
                          //         [], // Replace with actual tagged users if needed
                          //     isReply: false, // Update this if editing a reply
                          //   );
                          //   Navigator.pop(context);
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //       content: Text("Comment updated successfully"),
                          //     ),
                          //   );
                          // } else {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //       content: Text(
                          //         "Comment content cannot be empty",
                          //       ),
                          //       backgroundColor: Colors.red,
                          //     ),
                          //   );
                          // }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          // Delete Comment Action
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text("Delete Comment"),
            onTap: () {
              Navigator.pop(context); // Close bottom sheet first
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Delete Comment'),
                      content: const Text(
                        'Are you sure you want to delete this comment?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // await Provider.of<FeedProvider>(
                            //   context,
                            //   listen: false,
                            // ).deleteComment(postId, commentId);
                            // Navigator.pop(context); // Close confirmation dialog
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text("Comment deleted successfully"),
                            //   ),
                            // );
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
