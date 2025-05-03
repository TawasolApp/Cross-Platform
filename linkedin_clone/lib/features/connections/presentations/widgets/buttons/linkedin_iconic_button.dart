import 'package:flutter/material.dart';

class LinkedInIconicButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double width;

  const LinkedInIconicButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 16,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('linkedin_iconic_button'),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: width),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
        visualDensity: VisualDensity.compact,
      ),
      child: Text(
        label,
        key: const Key('linkedin_iconic_button_text'),
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
