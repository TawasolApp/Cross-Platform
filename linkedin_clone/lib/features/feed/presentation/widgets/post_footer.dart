import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostFooter extends StatelessWidget {
  final int likes;
  final int comments;
  final int shares;

  const PostFooter({
    super.key,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.thumbsUp,
                  color: Colors.blue,
                  size: 18,
                ),
                const SizedBox(width: 5),
                Text('$likes'),
              ],
            ),
            Text('$comments comments • $shares shares'),
          ],
        ),
        const Divider(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAction(FontAwesomeIcons.thumbsUp, "Like"),
            _buildAction(FontAwesomeIcons.comment, "Comment"),
            _buildAction(FontAwesomeIcons.retweet, "Repost"),
            _buildAction(FontAwesomeIcons.paperPlane, "Send"),
          ],
        ),
      ],
    );
  }

  Widget _buildAction(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, color: const Color.fromARGB(255, 78, 78, 78), size: 16),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: const Color.fromARGB(255, 78, 78, 78),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
