import 'package:flutter/material.dart';
import '../../domain/entities/comment_entity.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comment;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(comment.authorPicture),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.authorName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(comment.content),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${comment.reactCount} likes • ${comment.timestamp}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    // const SizedBox(width: 10),
                    // Text(
                    //   comment.timestamp.toString(),
                    //   style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
