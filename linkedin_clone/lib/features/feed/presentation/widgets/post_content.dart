import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PostContent extends StatelessWidget {
  final String content;
  final String? imageUrl;

  const PostContent({super.key, required this.content, this.imageUrl});

  bool _isDocument(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.pdf') ||
        lower.endsWith('.doc') ||
        lower.endsWith('.docx');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content,
          style: TextStyle(
            fontSize: 15,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),

        if (imageUrl != null) ...[
          const SizedBox(height: 8),
          _isDocument(imageUrl!)
              ? GestureDetector(
                onTap: () async {
                  final uri = Uri.parse(imageUrl!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Could not open document")),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color:
                        isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.insert_drive_file,
                        size: 40,
                        color: Colors.blue.shade400,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          imageUrl!.split('/').last,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.open_in_new,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              )
              : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                ),
              ),
        ],
      ],
    );
  }
}
