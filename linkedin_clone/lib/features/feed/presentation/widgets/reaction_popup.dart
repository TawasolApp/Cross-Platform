import 'package:flutter/material.dart';
import 'reaction_icon.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/core/utils/reaction_type.dart';
import 'package:linkedin_clone/features/feed/presentation/provider/feed_provider.dart';

class ReactionPopup extends StatelessWidget {
  final String userId;
  final String postId;
  final Function(String) onReactionSelected;

  const ReactionPopup({
    Key? key,
    required this.userId,
    required this.postId,
    required this.onReactionSelected,
  }) : super(key: key);

  void _handleReaction(BuildContext context, ReactionType selectedReaction) {
    final provider = Provider.of<FeedProvider>(context, listen: false);
    final reactions = {
      for (var r in ReactionType.values.where((r) => r != ReactionType.none))
        r.name: r == selectedReaction,
    };
    provider.reactToPost(userId, postId, reactions, "Post");
    onReactionSelected(selectedReaction.name);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                ReactionType.values
                    .where((reaction) => reaction != ReactionType.none)
                    .map((reaction) {
                      return GestureDetector(
                        onTap: () {
                          _handleReaction(context, reaction);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.transparent,
                                child: Icon(
                                  reaction.icon,
                                  color: reaction.color,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                    .toList(),
          ),
        ),
      ),
    );
  }
}
