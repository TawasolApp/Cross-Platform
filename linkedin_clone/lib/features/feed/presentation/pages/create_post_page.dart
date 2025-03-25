import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/post_creation_header.dart';
import '../widgets/post_creation_textfield.dart';
import '../widgets/post_creation_footer.dart';
import '../provider/feed_provider.dart';

class PostCreationPage extends StatefulWidget {
  const PostCreationPage({super.key});

  @override
  PostCreationPageState createState() => PostCreationPageState();
}

class PostCreationPageState extends State<PostCreationPage> {
  final TextEditingController _postCreationController = TextEditingController();
  bool _isPostCreationButtonActive = false;

  @override
  void initState() {
    super.initState();
    _postCreationController.addListener(() {
      setState(() {
        _isPostCreationButtonActive =
            _postCreationController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _postCreationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        actions: [
          TextButton(
            onPressed:
                _isPostCreationButtonActive
                    ? () {
                      feedProvider.createPost(
                        content: _postCreationController.text.trim(),
                        visibility: feedProvider.visibility,
                      );
                      Navigator.pop(context);
                    }
                    : null,
            child: Text(
              "Post",
              style: TextStyle(
                color: _isPostCreationButtonActive ? Colors.blue : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostCreationHeader(
              profileImage: feedProvider.profileImage,
              authorName: feedProvider.authorName,
              authorTitle: feedProvider.authorTitle,
              visibility: feedProvider.visibility,
              onVisibilityChanged: (newVisibility) {
                feedProvider.setVisibility(newVisibility);
              },
            ),
            const SizedBox(height: 10),
            PostCreationTextField(
              controller: _postCreationController,
              onChanged: (text) {
                setState(() {
                  _isPostCreationButtonActive = text.trim().isNotEmpty;
                });
              },
            ),
            const SizedBox(height: 20),
            const PostCreationFooter(),
          ],
        ),
      ),
    );
  }
}
