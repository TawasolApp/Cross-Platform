import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onTap;

  const LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
            color:
                isLiked ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            "Like",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:
                  isLiked ? Theme.of(context).colorScheme.primary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
