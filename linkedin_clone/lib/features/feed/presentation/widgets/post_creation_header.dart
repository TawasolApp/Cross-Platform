import 'package:flutter/material.dart';

class PostCreationHeader extends StatelessWidget {
  final String profileImage;
  final String authorName;
  final String authorTitle;
  final String visibility;
  final Function(String) onVisibilityChanged;

  const PostCreationHeader({
    super.key,
    required this.profileImage,
    required this.authorName,
    required this.authorTitle,
    required this.visibility,
    required this.onVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundImage: NetworkImage(profileImage), radius: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                authorTitle,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              PopupMenuButton<String>(
                onSelected: onVisibilityChanged,
                padding: EdgeInsets.zero,
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: "Public",
                        child: Text("🌍 Public"),
                      ),
                      const PopupMenuItem(
                        value: "Connections",
                        child: Text("👥 Connections"),
                      ),
                      const PopupMenuItem(
                        value: "Only Me",
                        child: Text("🔒 Only Me"),
                      ),
                    ],
                child: Row(
                  children: [
                    Text(
                      _getVisibilityText(visibility),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getVisibilityText(String visibility) {
    switch (visibility) {
      case "Connections":
        return "👥 Connections";
      case "Only Me":
        return "🔒 Only Me";
      default:
        return "🌍 Public";
    }
  }
}
