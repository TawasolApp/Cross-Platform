import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/app_theme.dart';

class ReactionBar extends StatelessWidget {
  final int likes;
  final int comments;
  final int shares;

  const ReactionBar({
    super.key,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$likes Likes", style: Theme.of(context).textTheme.bodySmall),
        Text(
          "$comments Comments",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text("$shares Shares", style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
