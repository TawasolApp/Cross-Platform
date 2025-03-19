import 'package:flutter/material.dart';
import 'features/feed/presentation/widgets/post_card.dart';
import 'features/feed/presentation/widgets/comment_section.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkedIn Clone',
      theme: ThemeData.light(),
      home: const FeedScreen(),
    );
  }
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for testing
    final comments = [
      Comment(id: "comment1", userId: "user456", text: "Great post!"),
      Comment(id: "comment2", userId: "user789", text: "Thanks for sharing."),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Feed")),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: PostCard(
                  postId: "user123",
                  content:
                      "This is a text-only post for testing the PostCard widget.",
                  mediaUrls: [], // No image URLs
                  comments: comments, // Pass comments correctly
                  likeCount: 10,
                  isLiked: false,
                  isSaved: false,
                  onLike: () {
                    // Handle like functionality
                    print("Post liked/unliked");
                  },
                  onCelebrate: () {
                    // Handle celebrate functionality
                    print("Celebrate reaction added");
                  },
                  onToggleSave: () {
                    // Handle save/unsave functionality
                    print("Post saved/unsaved");
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommentSection(
              comments: comments, // Pass comments correctly
              onComment: (text) {
                // Handle adding a comment
                print("New comment: $text");
              },
            ),
          ),
        ],
      ),
    );
  }
}
