import 'package:flutter/material.dart';

class PostCreationTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(List<String>?) onTagsChanged;

  const PostCreationTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onTagsChanged,
  });
  List<String> extractTaggedUsernames(String content) {
    final regex = RegExp(r'@([a-zA-Z0-9_]+)');
    return regex.allMatches(content).map((m) => m.group(1)!).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return TextField(
      controller: controller,
      onChanged: (value) {
        onChanged(value);
        onTagsChanged(extractTaggedUsernames(value));
      },
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "What do you want to talk about?",
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
    );
  }
}
