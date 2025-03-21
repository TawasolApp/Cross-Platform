import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  final String bio;

  const AboutSection({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensures full width
      color: Colors.white, // Matches LinkedIn's background
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          const Text(
            'About',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Bio Content
          Text(
            bio.isNotEmpty ? bio : "No bio available",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
