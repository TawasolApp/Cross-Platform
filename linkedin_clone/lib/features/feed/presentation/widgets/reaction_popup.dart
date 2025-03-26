import 'package:flutter/material.dart';
import 'reaction_icon.dart';

class ReactionPopup extends StatefulWidget {
  final void Function(String label) onReactionSelected;

  const ReactionPopup({super.key, required this.onReactionSelected});

  @override
  State<ReactionPopup> createState() => _ReactionPopupState();
}

class _ReactionPopupState extends State<ReactionPopup> {
  int? hoveredIndex;

  final List<Map<String, dynamic>> reactions = [
    {'icon': Icons.thumb_up, 'label': 'Like', 'color': Colors.blue},
    {'icon': Icons.celebration, 'label': 'Celebrate', 'color': Colors.green},
    {'icon': Icons.favorite, 'label': 'Love', 'color': Colors.red},
    {'icon': Icons.lightbulb, 'label': 'Insightful', 'color': Colors.amber},
    {'icon': Icons.emoji_emotions, 'label': 'Funny', 'color': Colors.cyan},
    {
      'icon': Icons.volunteer_activism,
      'label': 'Support',
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(reactions.length, (index) {
            final item = reactions[index];
            return GestureDetector(
              onPanUpdate: (details) {
                RenderBox box = context.findRenderObject() as RenderBox;
                Offset local = box.globalToLocal(details.globalPosition);
                int i = (local.dx / 60).floor().clamp(0, reactions.length - 1);
                if (hoveredIndex != i) setState(() => hoveredIndex = i);
              },
              onTap: () {
                widget.onReactionSelected(item['label']);
              },
              child: ReactionIconWidget(
                icon: item['icon'],
                label: item['label'],
                color: item['color'],
                isHighlighted: index == hoveredIndex,
              ),
            );
          }),
        ),
      ),
    );
  }
}
