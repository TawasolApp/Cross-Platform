import 'package:flutter/material.dart';
import 'post_actions_bottom_sheet.dart';

class PostHeader extends StatelessWidget {
  final String profileImage;
  final String authorName;
  final String authorTitle;
  final String postTime;
  final String postId;

  const PostHeader({
    super.key,
    required this.profileImage,
    required this.authorName,
    required this.authorTitle,
    required this.postTime,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(backgroundImage: NetworkImage(profileImage), radius: 22),
        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                authorTitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                postTime,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),

        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (_) => PostActionsBottomSheet(postId: postId),
            );
          },
        ),
      ],
    );
  }
}
