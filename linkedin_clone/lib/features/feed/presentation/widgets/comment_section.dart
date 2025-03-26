import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/app_theme.dart';

class CommentSection extends StatelessWidget {
  final List<String> comments;

  const CommentSection({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          comments
              .map(
                (comment) => Text(
                  comment,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
              .toList(),
    );
  }
}
