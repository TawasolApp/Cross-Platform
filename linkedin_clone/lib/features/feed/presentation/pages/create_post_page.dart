import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:provider/provider.dart';
import '../widgets/post_creation_header.dart';
import '../widgets/post_creation_textfield.dart';
import '../widgets/post_creation_footer.dart';
import '../provider/feed_provider.dart';

class PostCreationPage extends StatefulWidget {
  final String? initialContent;
  final String? postId; // If null → creating, if not null → editing
  final String? authorName;
  final String? authorTitle;
  final String? authorImage;
  final String? visibility;
  const PostCreationPage({
    super.key,
    this.initialContent,
    this.postId,
    this.authorName,
    this.authorTitle,
    this.authorImage,
    this.visibility,
  });

  @override
  PostCreationPageState createState() => PostCreationPageState();
}

class PostCreationPageState extends State<PostCreationPage> {
  late final TextEditingController _postCreationController;
  bool _isPostCreationButtonActive = false;

  @override
  void initState() {
    super.initState();
    _postCreationController = TextEditingController(
      text: widget.initialContent ?? '',
    );
    _isPostCreationButtonActive =
        widget.initialContent?.trim().isNotEmpty ?? false;

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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        actions: [
          TextButton(
            onPressed:
                _isPostCreationButtonActive
                    ? () async {
                      final content = _postCreationController.text.trim();
                      if (widget.postId != null) {
                        await feedProvider.editPost(
                          postId: widget.postId!,
                          content: content,
                        );
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Post updated successfully'),
                          ),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Post updated successfully'),
                            ),
                          );
                          context.go(RouteNames.main);
                        }
                        //context.go(RouteNames.main);
                      } else {
                        feedProvider.createPost(
                          content: content,
                          visibility: feedProvider.visibility,
                        );

                        if (feedProvider.errorMessage != null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(feedProvider.errorMessage!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Post created successfully!'),
                              ),
                            );
                            context.go(RouteNames.main);
                          }
                        }
                      }
                    }
                    : null,
            child: Text(
              widget.postId != null ? "Save" : "Post",
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
              profileImage: widget.authorImage ?? feedProvider.profileImage,
              authorName: widget.authorName ?? feedProvider.authorName,
              authorTitle: widget.authorTitle ?? feedProvider.authorTitle,
              visibility: widget.visibility ?? feedProvider.visibility,
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
