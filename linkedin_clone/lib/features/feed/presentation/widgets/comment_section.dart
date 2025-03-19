import 'package:flutter/material.dart';
import '/../../core/themes/color_scheme.dart';
import '/../../core/themes/text_styles.dart'; // Import for text styles

class Comment {
  final String id;
  final String userId;
  final String text;

  Comment({required this.id, required this.userId, required this.text});
}

class CommentSection extends StatelessWidget {
  final List<Comment> comments;
  final Function(String text) onComment;

  CommentSection({required this.comments, required this.onComment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display existing comments
        if (comments.isNotEmpty)
          Container(
            height: 200.0, // Set a fixed height for the comments list
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        child: Text(comment.userId[0].toUpperCase()),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.userId,
                              style:
                                  linkedinTextTheme
                                      .titleSmall, // Use imported text styles
                            ),
                            Text(
                              comment.text,
                              style:
                                  linkedinTextTheme
                                      .bodySmall, // Use imported text styles
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        // Add a comment input
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://example.com/profile.jpg',
                ),
                radius: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    hintText: "Leave your thoughts here...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onSubmitted: (text) => onComment(text), // Fix function call
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: Icon(
                  Icons.alternate_email,
                  color: linkedinLightColorScheme.primary,
                ),
                onPressed: () {
                  // Handle mention functionality
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
