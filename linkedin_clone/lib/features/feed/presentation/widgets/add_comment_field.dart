// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/comment_entity.dart';
import '../provider/feed_provider.dart';

class AddCommentField extends StatefulWidget {
  final String postId;

  const AddCommentField({super.key, required this.postId});

  @override
  _AddCommentFieldState createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<AddCommentField> {
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(feedProvider.profileImage),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged:
                  (value) => setState(() {
                    _isFocused = value.isNotEmpty;
                  }),
              decoration: InputDecoration(
                hintText: "Leave your thoughts here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          if (_isFocused)
            TextButton(
              onPressed: () {
                feedProvider.addComment(widget.postId, _controller.text);
                _controller.clear();
                setState(() {
                  _isFocused = false;
                });
              },
              child: const Text("Comment"),
            ),
        ],
      ),
    );
  }
}
