// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/feed_provider.dart';
// import 'add_comment_field.dart';
// import 'reaction_popup.dart';
// import 'package:linkedin_clone/core/utils/reaction_type.dart';

// class CommentActionsFooter extends StatelessWidget {
//   final String commentId;
//   final String postId;
//   final String authorId;
//   final String currentUserId;
//   final String commentContent;

//   const CommentActionsFooter({
//     super.key,
//     required this.commentId,
//     required this.postId,
//     required this.authorId,
//     required this.currentUserId,
//     required this.commentContent,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           _buildActionText(context, "Like", () {
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (_) {
//                         return ReactionPopup(
//                           postId: commentId,
//                           postType: "Comment",
//                           onReactionSelected: (reaction) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('Reacted with $reaction')),
//                             );
//                           },
//                         );
//                       },
//                     );
//                   },
//                   child: Row(
//                     children: [
//                       Icon(
//                         getReactionIcon(
//                           Provider.of<FeedProvider>(
//                                 context,
//                                 listen: false,
//                               ).getCommentById(commentId)?.reactType ??
//                               '',
//                         ),
//                         size: 14,
//                         color: getReactionColor(
//                           Provider.of<FeedProvider>(
//                                 context,
//                                 listen: false,
//                               ).getCommentById(commentId)?.reactType ??
//                               '',
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         Provider.of<FeedProvider>(context)
//                                     .getCommentById(commentId)
//                                     ?.reactType
//                                     ?.isNotEmpty ==
//                                 true
//                             ? Provider.of<FeedProvider>(
//                               context,
//                               listen: false,
//                             ).getCommentById(commentId)!.reactType
//                             : "Like",
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.grey[800],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }),
//           _buildSeparator(),
//           _buildActionText(context, "Reply", () async {
//             print(
//               "👈 Reply tapped for comment: $commentId",
//             ); // Add this for debug

//             await showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               backgroundColor: Colors.transparent,
//               builder:
//                   (_) => Padding(
//                     padding: EdgeInsets.only(
//                       bottom: MediaQuery.of(context).viewInsets.bottom,
//                       left: 8,
//                       right: 8,
//                     ),
//                     child: Material(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Row(
//                             children: [
//                               const SizedBox(width: 8),
//                               Icon(
//                                 Icons.reply,
//                                 size: 16,
//                                 color: Colors.blue[400],
//                               ),
//                               const SizedBox(width: 6),
//                               Text(
//                                 "Replying...",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.blue[400],
//                                 ),
//                               ),
//                               const Spacer(),
//                               IconButton(
//                                 icon: const Icon(Icons.close),
//                                 onPressed:
//                                     () =>
//                                         Navigator.of(
//                                           context,
//                                         ).pop(), // ✳️ Stable close
//                               ),
//                             ],
//                           ),
//                           AddCommentField(
//                             key: ValueKey(
//                               "reply-$commentId",
//                             ), // Ensures rebuild only on change
//                             postId: postId,
//                             replyToCommentId: commentId,
//                             isReply: true,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//             );
//           }),

//           // _buildActionText(context, "Reply", () {
//           //   showModalBottomSheet(
//           //     context: context,
//           //     isScrollControlled: true,
//           //     builder:
//           //         (_) => Padding(
//           //           padding: EdgeInsets.only(
//           //             bottom: MediaQuery.of(context).viewInsets.bottom,
//           //             left: 16,
//           //             right: 16,
//           //             top: 12,
//           //           ),

//           //           child: AddCommentField(
//           //             key: ValueKey("reply-${commentId}"), // ✅ Force rebuild

//           //             postId: postId,
//           //             replyToCommentId: commentId,
//           //             isReply: true,
//           //           ),
//           //         ),
//           //   );
//           // }),
//           if (authorId == currentUserId) _buildSeparator(),
//           if (authorId == currentUserId)
//             _buildActionText(context, "Edit", () {
//               _showEditDialog(context);
//             }),

//           if (authorId == currentUserId) _buildSeparator(),
//           if (authorId == currentUserId)
//             _buildActionText(context, "Delete", () async {
//               await Provider.of<FeedProvider>(
//                 context,
//                 listen: false,
//               ).deleteComment(postId, commentId);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Comment deleted successfully")),
//               );
//             }),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionText(
//     BuildContext context,
//     String label,
//     VoidCallback onTap,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Text(
//         label,
//         style: const TextStyle(
//           fontSize: 12,
//           color: Colors.grey,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget _buildSeparator() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.0),
//       child: Text('|', style: TextStyle(fontSize: 12, color: Colors.grey)),
//     );
//   }

//   void _showEditDialog(BuildContext context) {
//     final controller = TextEditingController(text: commentContent);

//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           title: const Text("Edit Comment"),
//           content: TextField(
//             controller: controller,
//             maxLines: null,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: "Update your comment",
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () async {
//                 final updatedText = controller.text.trim();
//                 if (updatedText.isNotEmpty && updatedText != commentContent) {
//                   await Provider.of<FeedProvider>(
//                     context,
//                     listen: false,
//                   ).editComment(
//                     commentId: commentId,
//                     updatedContent: updatedText,
//                     isReply: false,
//                   );

//                   Navigator.pop(context);

//                   // ScaffoldMessenger.of(context).showSnackBar(
//                   //   const SnackBar(
//                   //     content: Text("Comment updated successfully"),
//                   //   ),
//                   // );
//                 } else {
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import 'add_comment_field.dart';
import 'reaction_popup.dart';
import 'package:linkedin_clone/core/utils/reaction_type.dart';

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
    // final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    // final comment = feedProvider.getCommentById(commentId);
    // final reactType = comment?.reactType ?? '';

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Consumer<FeedProvider>(
            builder: (context, feedProvider, _) {
              final comment = feedProvider.getCommentById(commentId);
              final reactType = comment?.reactType ?? '';
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return ReactionPopup(
                        postId: commentId,
                        postType: "Comment",
                        onReactionSelected: (reaction) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Reacted with $reaction')),
                          );
                        },
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      getReactionIcon(reactType),
                      size: 14,
                      color: getReactionColor(reactType),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      reactType.isNotEmpty ? reactType : "Like",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

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
                }
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
