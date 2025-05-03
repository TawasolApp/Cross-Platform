// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/feed_provider.dart';

// class AddCommentField extends StatefulWidget {
//   final String postId;
//   final String? replyToCommentId;
//   final bool isReply;
//   const AddCommentField({
//     super.key,
//     required this.postId,
//     this.replyToCommentId,
//     required this.isReply,
//   });

//   @override
//   _AddCommentFieldState createState() => _AddCommentFieldState();
// }

// class _AddCommentFieldState extends State<AddCommentField> {
//   final TextEditingController _controller = TextEditingController();
//   bool _isTyping = false;

//   void _addComment(BuildContext context) async {
//     final content = _controller.text.trim();
//     if (content.isNotEmpty) {
//       try {
//         final String commentingId;
//         if (widget.isReply) {
//           commentingId = widget.replyToCommentId!;
//         } else {
//           commentingId = widget.postId;
//         }
//         print("Commenting ID: $commentingId, isReply: ${widget.isReply}");
//         await context.read<FeedProvider>().addComment(
//           commentingId,
//           content,
//           widget.isReply,
//         );
//         _controller.clear();
//         setState(() {
//           _isTyping = false;
//         });
//         FocusScope.of(context).unfocus(); // 🟢 Close keyboard

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Comment added successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } catch (e) {
//         // Show error message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to add comment: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//       child: Row(
//         children: [
//           // Profile Picture
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: CircleAvatar(
//               radius: 18,
//               backgroundImage: NetworkImage(
//                 "https://example.com/profile-picture.jpg",
//               ),
//             ),
//           ),
//           // Comment Input Field
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               textInputAction: TextInputAction.send,
//               onChanged: (value) {
//                 setState(() {
//                   _isTyping = value.isNotEmpty;
//                 });
//               },
//               //onSubmitted: (_) => _addComment(context),
//               decoration: InputDecoration(
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 hintText: "Leave your thoughts here...",
//                 hintStyle: TextStyle(color: Colors.grey[600]),
//                 filled: true,
//                 fillColor: Colors.grey[100],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           // Dynamic Send Button
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: GestureDetector(
//               onTap: _isTyping ? () => _addComment(context) : null,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 100),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: _isTyping ? Colors.blue[600] : Colors.grey[400],
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   _isTyping ? "Comment" : "",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/feed_provider.dart';

class AddCommentField extends StatefulWidget {
  final String postId;
  final String? replyToCommentId;
  final bool isReply;

  const AddCommentField({
    super.key,
    required this.postId,
    this.replyToCommentId,
    required this.isReply,
  });

  @override
  _AddCommentFieldState createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<AddCommentField> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    print(
      "🛠️ AddCommentField → isReply: ${widget.isReply}, "
      "replyTo: ${widget.replyToCommentId}, postId: ${widget.postId}",
    );
  }

  void _addComment(BuildContext context) async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    try {
      final String commentingId =
          widget.isReply ? widget.replyToCommentId! : widget.postId;
      print("postId: ${widget.postId}");
      print("replyToCommentId: ${widget.replyToCommentId}");

      print("✅ Sending comment → ID: $commentingId, reply: ${widget.isReply}");

      await context.read<FeedProvider>().addComment(
        commentingId,
        content,
        widget.isReply,
      );

      _controller.clear();
      setState(() => _isTyping = false);
      FocusScope.of(context).unfocus();

      //if (widget.isReply) Navigator.pop(context); // Close reply modal

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add comment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          /// Profile Picture (static placeholder for now)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                "https://example.com/profile-picture.jpg",
              ),
            ),
          ),

          /// Text input field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isReply)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 2),
                    child: Text(
                      "Replying...",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[400],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                TextField(
                  key: ValueKey("commentField-${widget.isReply}"),
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onChanged:
                      (value) => setState(() => _isTyping = value.isNotEmpty),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    hintText: "Leave your thoughts here...",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Send Button
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: GestureDetector(
              onTap: _isTyping ? () => _addComment(context) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _isTyping ? Colors.blue[600] : Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isTyping ? "Comment" : "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
