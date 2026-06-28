import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/Navigation/route_names.dart'; // Update the path if needed
import 'post_actions_bottom_sheet.dart';

class PostHeader extends StatelessWidget {
  final String profileImage;
  final String authorName;
  final String authorTitle;
  final String postTime;
  final String postId;
  final String postContent;
  final String visibility;
  final String authorId;
  final String currentUserId;
  final String authorType;
  final bool isMiniPostCard;
  const PostHeader({
    super.key,
    required this.profileImage,
    required this.authorName,
    required this.authorTitle,
    required this.postTime,
    required this.postId,
    required this.postContent,
    required this.visibility,
    required this.authorId,
    required this.currentUserId,
    required this.authorType,
    this.isMiniPostCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (authorType == "User") {
              context.push(RouteNames.profile, extra: authorId);
            } else {
              context.push(RouteNames.companyPage, extra: authorId);
            }
          },
          child:
              authorType == "User"
                  ? CircleAvatar(
                    backgroundImage: NetworkImage(profileImage),
                    radius: isMiniPostCard ? 16 : 22,
                  )
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      profileImage,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => const Icon(Icons.business, size: 40),
                    ),
                  ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isMiniPostCard ? 14 : 16,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                authorTitle,
                style: TextStyle(
                  fontSize: isMiniPostCard ? 11 : 12,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                postTime,
                style: TextStyle(
                  fontSize: isMiniPostCard ? 10 : 12,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        if (!isMiniPostCard)
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder:
                    (_) => PostActionsBottomSheet(
                      postId: postId,
                      postContent: postContent,
                      authorImage: profileImage,
                      authorName: authorName,
                      authorTitle: authorTitle,
                      visibility: visibility,
                      authorId: authorId,
                      currentUserId: currentUserId,
                      rootContext: context,
                    ),
              );
            },
          ),
      ],
    );
  }
}
