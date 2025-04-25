import 'package:flutter/material.dart';
import 'add_comment_field.dart';
import 'comment_list.dart';

class CommentSection extends StatelessWidget {
  final String postId;
  final String currentUserId;
  const CommentSection({
    super.key,
    required this.postId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddCommentField(postId: postId),
        const Divider(),
        CommentList(
          postId: postId,
          currentUserId: currentUserId,
        ), // Replace with actual current user ID
      ],
    );
  }
}
