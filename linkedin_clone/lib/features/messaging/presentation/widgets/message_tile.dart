import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/messaging/domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isMe ? Colors.lightBlue[200] : Colors.grey[300];
    final textColor = isMe ? Colors.white : Colors.black87;
    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final borderRadius = isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          );

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
              if (message.media.isNotEmpty) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    message.media.first, // ✅ Display first image
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Text('Failed to load image'),
                  ),
                ),
              ],

            const SizedBox(height: 4),
            if (isMe && message.status == 'Read') ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.done_all, size: 16, color: Colors.blue),
                  SizedBox(width: 4),
                  Text('Read', style: TextStyle(fontSize: 10, color: Colors.blue)),
                ],
              )
            ] else if (isMe && message.status == 'Delivered') ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.done_all, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('Delivered', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}
