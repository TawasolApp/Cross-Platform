import 'package:flutter/material.dart';

Future<void> showDeletePostDialog({
  required BuildContext context,
  required VoidCallback onDelete,
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Delete post',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to permanently remove this post from LinkedIn?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              onDelete(); // Trigger delete action
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
