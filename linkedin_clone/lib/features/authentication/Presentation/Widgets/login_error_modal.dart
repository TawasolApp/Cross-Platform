import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/navigation/route_names.dart';

class CustomAuthErrorDialog extends StatelessWidget {
  final String message;

  const CustomAuthErrorDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
            ),
            const SizedBox(height: 16),
            Divider(color: isDark ? Colors.white24 : Colors.black12),
            TextButton(
              onPressed: () {
                context.go(RouteNames.register); // Navigate to register
              },
              child: const Text("Create an account"),
            ),
            Divider(color: isDark ? Colors.white24 : Colors.black12),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Try again"),
            ),
          ],
        ),
      ),
    );
  }
}
