import 'package:flutter/material.dart';

class LabelCard extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const LabelCard({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Theme.of(context).colorScheme.onSecondary,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              color: Theme.of(context).iconTheme.color,
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
