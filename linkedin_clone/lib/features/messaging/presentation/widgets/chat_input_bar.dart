import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatInputBar extends StatefulWidget {
  final void Function(String) onSend; // ✅ KEEPING THIS
  final void Function(String) onTyped;

  const ChatInputBar({
    super.key,
    required this.onSend,
    required this.onTyped,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  void _handleSend() {
    final text = _controller.text.trim();

    // Send text (even if no image selected)
    if (text.isNotEmpty || _selectedImage != null) {
      widget.onSend(text); // ✅ Use callback for text send
    }

    _controller.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _handleImagePick() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedImage != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_selectedImage!.path),
                    height: 100,
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedImage = null),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image, color: Colors.green),
                onPressed: _handleImagePick,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onTyped,
                  decoration: const InputDecoration(
                    hintText: "Write a message...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: _handleSend,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
