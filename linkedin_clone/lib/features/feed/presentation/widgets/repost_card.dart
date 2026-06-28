import 'package:flutter/material.dart';
import 'post_content.dart';

class RepostCard extends StatelessWidget {
  final String authorName;
  final String content;
  final String? imageUrl;

  const RepostCard({
    super.key,
    required this.authorName,
    required this.content,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          PostContent(content: content, imageUrl: imageUrl),
        ],
      ),
    );
  }
}
