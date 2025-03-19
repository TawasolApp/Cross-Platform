import 'package:flutter/material.dart';
import '/../../core/themes/color_scheme.dart';
import '/../../core/themes/text_styles.dart';
import 'like_button.dart';

class ReactionBar extends StatelessWidget {
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onRepost;
  final VoidCallback onSend;

  ReactionBar({
    required this.onLike,
    required this.onComment,
    required this.onRepost,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(Icons.thumb_up_alt_outlined, 'Like', onLike),
        _buildActionButton(Icons.comment_outlined, 'Comment', onComment),
        _buildActionButton(Icons.share_outlined, 'Repost', onRepost),
        _buildActionButton(Icons.send_outlined, 'Send', onSend),
      ],
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 24, color: Colors.grey[700]),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
