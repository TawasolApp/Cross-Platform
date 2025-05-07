import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/routing_functions.dart';
import '../provider/feed_provider.dart';
import '../pages/create_post_page.dart';
import 'delete_post_dialog.dart';
import '../../domain/entities/post_entity.dart';

class PostActionsBottomSheet extends StatefulWidget {
  final String postId;
  final String postContent;
  final String authorImage;
  final String authorName;
  final String authorTitle;
  final String visibility;
  final BuildContext rootContext;
  final String authorId;
  final String currentUserId;

  const PostActionsBottomSheet({
    super.key,
    required this.postId,
    required this.postContent,
    required this.authorImage,
    required this.authorName,
    required this.authorTitle,
    required this.visibility,
    required this.rootContext,
    required this.authorId,
    required this.currentUserId,
  });

  @override
  State<PostActionsBottomSheet> createState() => _PostActionsBottomSheetState();
}

class _PostActionsBottomSheetState extends State<PostActionsBottomSheet> {
  late Future<PostEntity?> _postFuture;

  @override
  void initState() {
    super.initState();
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    _postFuture = feedProvider.fetchPostById(
      widget.currentUserId,
      widget.postId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostEntity?>(
      future: _postFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          Navigator.pop(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(widget.rootContext).showSnackBar(
              const SnackBar(
                content: Text("Post data not found"),
                backgroundColor: Colors.red,
              ),
            );
          });
          return const SizedBox.shrink();
        }

        final post = snapshot.data!;
        final isSaved = post.isSaved;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(height: 4, width: 40, color: Colors.grey[300]),
              const SizedBox(height: 16),

              ListTile(
                leading: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved ? Colors.grey : null,
                ),
                title: Text(isSaved ? "Unsave" : "Save"),
                onTap: () async {
                  Navigator.pop(context);
                  final feedProvider = Provider.of<FeedProvider>(
                    context,
                    listen: false,
                  );
                  if (isSaved) {
                    await feedProvider.unsavePost(widget.postId);
                    ScaffoldMessenger.of(widget.rootContext).showSnackBar(
                      const SnackBar(
                        content: Text("Post unsaved successfully"),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  } else {
                    await feedProvider.savePost(widget.postId);
                    ScaffoldMessenger.of(widget.rootContext).showSnackBar(
                      const SnackBar(
                        content: Text("Post saved successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),

              if (widget.authorId == widget.currentUserId) ...[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => PostCreationPage(
                              postId: widget.postId,
                              initialContent: widget.postContent,
                              visibility: widget.visibility,
                              authorImage: widget.authorImage,
                              authorName: widget.authorName,
                              authorTitle: widget.authorTitle,
                            ),
                      ),
                    );
                  },
                ),
              ],

              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  goToReportPost(context, postId: widget.postId);
                },
              ),

              if (widget.authorId == widget.currentUserId) ...[
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text("Delete post"),
                  onTap: () {
                    Navigator.pop(context);
                    showDeletePostDialog(
                      context: context,
                      onDelete: () async {
                        final feedProvider = Provider.of<FeedProvider>(
                          context,
                          listen: false,
                        );
                        await feedProvider.deletePost(widget.postId);
                        final message = feedProvider.errorMessage;
                        ScaffoldMessenger.of(widget.rootContext).showSnackBar(
                          SnackBar(
                            content: Text(
                              message ?? 'Post deleted successfully',
                            ),
                            backgroundColor:
                                message == null ? Colors.green : Colors.red,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
