import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  final String profileImage;
  final String authorName;
  final String authorTitle;
  final String postTime;

  const PostHeader({
    super.key,
    required this.profileImage,
    required this.authorName,
    required this.authorTitle,
    required this.postTime,
  });

  @override
  Widget build(BuildContext context) {
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
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                authorTitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                postTime,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),

        IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
      ],
    );
  }
}
