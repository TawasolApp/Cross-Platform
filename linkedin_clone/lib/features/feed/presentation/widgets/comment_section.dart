import 'package:flutter/material.dart';
import 'add_comment_field.dart';
import 'comment_list.dart';

class CommentSection extends StatelessWidget {
  final String postId;

  const CommentSection({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddCommentField(postId: postId),
        const Divider(),
        CommentList(postId: postId),
      ],
    );
  }
}
