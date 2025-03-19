import 'package:flutter/material.dart';
import '/../../core/themes/color_scheme.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onPressed;

  LikeButton({required this.isLiked, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
        color:
            isLiked
                ? linkedinLightColorScheme.primary
                : linkedinLightColorScheme.onSurfaceVariant,
      ),
      onPressed: onPressed,
    );
  }
}
