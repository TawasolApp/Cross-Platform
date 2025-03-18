import 'package:flutter/material.dart';
import 'features/feed/posts.dart'; // Fixed import path

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkedIn Clone',
      theme: ThemeData.light(), // Use light theme for now
      home: const FeedScreen(),
    );
  }
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a dummy LinkedInPost instance
    final dummyPost = LinkedInPost(
      id: "user123",
      content: "This is a dummy post for testing the LinkedInPostWidget.",
      mediaUrls: ["https://via.placeholder.com/200"], // Example image URL
      taggedUsers: ["user456", "user789"],
      comments: [
        Comment(id: "comment1", userId: "user456", text: "Great post!"),
        Comment(id: "comment2", userId: "user789", text: "Thanks for sharing."),
      ],
      likes: {"user123": "like", "user456": "celebrate"},
      isSaved: false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Feed")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LinkedInPostWidget(
          post: dummyPost,
          onLike: (userId, reaction) {
            // Handle like functionality
            print("User $userId reacted with $reaction");
          },
          onToggleSave: (userId) {
            // Handle save/unsave functionality
            print("Post saved/unsaved by $userId");
          },
          onComment: (userId, text) {
            // Handle adding a comment
            print("User $userId commented: $text");
          },
        ),
      ),
    );
  }
}
