import 'package:flutter/material.dart';

class LabelCard extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const LabelCard({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('label_card_gesture_detector'),
      onTap: onTap,
      child: Material(
        key: const Key('label_card_material'),
        color: Theme.of(context).colorScheme.onSecondary,
        child: Row(
          key: const Key('label_card_row'),
          children: [
            Padding(
              key: const Key('label_card_text_padding'),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                label,
                key: const Key('label_card_text'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Spacer(key: const Key('label_card_spacer')),
            IconButton(
              key: const Key('label_card_forward_button'),
              icon: Icon(
                Icons.arrow_forward,
                key: const Key('label_card_forward_icon'),
              ),
              color: Theme.of(context).iconTheme.color,
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
