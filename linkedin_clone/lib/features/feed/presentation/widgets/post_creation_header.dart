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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
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
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                authorTitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () => _showVisibilityBottomSheet(context),
                child: Row(
                  children: [
                    Text(
                      _getVisibilityText(visibility),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black,
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

  void _showVisibilityBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(height: 4, width: 40, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "Who can see your post?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: const Icon(Icons.public),
              title: Text(
                "Anyone",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                "Anyone on or off LinkedIn",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey,
                ),
              ),
              trailing:
                  visibility == "Public"
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
              onTap: () {
                Navigator.pop(context);
                onVisibilityChanged("Public");
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text(
                "Connections only",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                "Only your connections",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey,
                ),
              ),
              trailing:
                  visibility == "Connections"
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
              onTap: () {
                Navigator.pop(context);
                onVisibilityChanged("Connections");
              },
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  String _getVisibilityText(String visibility) {
    switch (visibility) {
      case "Connections":
        return "👥 Connections only";
      default:
        return "🌍 Anyone";
    }
  }
}
