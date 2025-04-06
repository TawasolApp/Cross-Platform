import 'package:flutter/material.dart';
import 'reaction_popup.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final String postId;

  const LikeButton({Key? key, required this.isLiked, required this.postId})
    : super(key: key);

  void _showReactionPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ReactionPopup(postId: postId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showReactionPopup(context),
      onLongPress:
          () => _showReactionPopup(context), // Long press triggers the popup
      child: Row(
        children: [
          Icon(
            isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
            color: isLiked ? Colors.blue : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            "Like",
            style: TextStyle(color: isLiked ? Colors.blue : Colors.grey),
          ),
        ],
      ),
    );
  }
}
