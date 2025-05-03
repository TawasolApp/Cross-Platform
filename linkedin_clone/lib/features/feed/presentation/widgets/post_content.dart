import 'package:flutter/material.dart';

class PostContent extends StatelessWidget {
  final String content;
  final String? imageUrl;

  const PostContent({super.key, required this.content, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content,
          style: TextStyle(
            fontSize: 15,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),

        if (imageUrl != null) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.grey,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}
