import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import 'reaction_popup.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';
import '../../domain/entities/post_entity.dart';

class ReactionBar extends StatefulWidget {
  final PostEntity post;
  final void Function(String) onReact;

  const ReactionBar({super.key, required this.post, required this.onReact});

  @override
  State<ReactionBar> createState() => _ReactionBarState();
}

class _ReactionBarState extends State<ReactionBar> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  // void _showReactions(Offset globalPosition) {
  //   _overlayEntry = OverlayEntry(
  //     builder:
  //         // (context) => ReactionPopup(
  //         //   onSelect: (reactionName) {
  //         //     widget.onReact(reactionName);
  //         //     _hidePopup();
  //         //   },
  //         //   targetPosition: globalPosition,
  //         // ),
  //   );
  //   Overlay.of(context).insert(_overlayEntry!);
  // }

  void _hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            widget.onReact('Like');
          },
          onLongPressStart: (details) {
            // _showReactions(details.globalPosition);
          },
          child: Row(
            children: [
              Icon(
                widget.post.isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                color:
                    widget.post.isLiked
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                "Like",
                style: TextStyle(
                  color:
                      widget.post.isLiked
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(
          "${widget.post.likes} Likes",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(width: 8),
        Text(
          "${widget.post.comments} Comments",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(width: 8),
        Text(
          "${widget.post.shares} Shares",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
