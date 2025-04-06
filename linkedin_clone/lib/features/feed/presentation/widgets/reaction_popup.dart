import 'package:flutter/material.dart';
import 'reaction_icon.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/core/utils/reaction_type.dart';
import 'package:linkedin_clone/features/feed/presentation/provider/feed_provider.dart';

class ReactionPopup extends StatelessWidget {
  final String postId;

  const ReactionPopup({Key? key, required this.postId}) : super(key: key);

  void _handleReaction(BuildContext context, ReactionType reaction) {
    final provider = Provider.of<FeedProvider>(context, listen: false);
    provider.reactToPost(postId, {reaction.name: true}, "Post");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            ReactionType.values
                .where((reaction) => reaction != ReactionType.none)
                .map((reaction) {
                  return GestureDetector(
                    onTap: () => _handleReaction(context, reaction),
                    child: Column(
                      children: [
                        Icon(reaction.icon, color: reaction.color, size: 36),
                        Text(
                          reaction.name,
                          style: TextStyle(color: reaction.color, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                })
                .toList(),
      ),
    );
  }
}
