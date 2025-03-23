import 'package:flutter/material.dart';

class PostCreationTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const PostCreationTextField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "What do you want to talk about?",
      ),
    );
  }
}
