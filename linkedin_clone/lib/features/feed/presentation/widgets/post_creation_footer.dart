import 'package:flutter/material.dart';

class PostCreationFooter extends StatelessWidget {
  const PostCreationFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.orange),
            SizedBox(width: 5),
            Text("Rewrite with AI"),
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
