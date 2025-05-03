import 'package:flutter/material.dart';

class PostCreationFooter extends StatelessWidget {
  const PostCreationFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
            children: [
            Icon(Icons.auto_awesome, color: isDarkMode ? Colors.orange.shade200 : Colors.orange),
            const SizedBox(width: 5),
            Text(
              "Rewrite with AI",
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.image_outlined),
          onPressed: () {
            // TODO: Implement image picker
          },
        ),
      ],
    );
  }
}
