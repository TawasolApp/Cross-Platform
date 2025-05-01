import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import 'add_comment_field.dart';

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
          _buildActionText(context, "Reply", () async {
            print(
              "👈 Reply tapped for comment: $commentId",
            ); // Add this for debug

            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder:
                  (_) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 8,
                      right: 8,
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              Icon(
                                Icons.reply,
                                size: 16,
                                color: Colors.blue[400],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Replying...",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue[400],
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed:
                                    () =>
                                        Navigator.of(
                                          context,
                                        ).pop(), // ✳️ Stable close
                              ),
                            ],
                          ),
                          AddCommentField(
                            key: ValueKey(
                              "reply-$commentId",
                            ), // Ensures rebuild only on change
                            postId: postId,
                            replyToCommentId: commentId,
                            isReply: true,
                          ),
                        ],
                      ),
                    ),
                  ),
            );
          }),

          // _buildActionText(context, "Reply", () {
          //   showModalBottomSheet(
          //     context: context,
          //     isScrollControlled: true,
          //     builder:
          //         (_) => Padding(
          //           padding: EdgeInsets.only(
          //             bottom: MediaQuery.of(context).viewInsets.bottom,
          //             left: 16,
          //             right: 16,
          //             top: 12,
          //           ),

          //           child: AddCommentField(
          //             key: ValueKey("reply-${commentId}"), // ✅ Force rebuild

          //             postId: postId,
          //             replyToCommentId: commentId,
          //             isReply: true,
          //           ),
          //         ),
          //   );
          // }),
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
