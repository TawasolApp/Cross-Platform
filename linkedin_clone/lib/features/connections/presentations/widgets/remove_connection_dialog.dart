import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/connections_provider.dart';

class RemoveConnectionDialog extends StatelessWidget {
  final String userId;
  final String userName;

  const RemoveConnectionDialog({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final connectionsProvider = Provider.of<ConnectionsProvider>(
      context,
      listen: false,
    );
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ), // Makes edges sharp
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 10.0,
          bottom: 10.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Remove Connection?",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Text(
              "Are you sure you want to remove $userName from your connections?",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                  },
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color.fromARGB(255, 113, 113, 113),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    connectionsProvider.removeConnection(
                      userId,
                    ); //TODO: Implement  Lw failed hy3mel eh
                    Navigator.pop(context); // Close dialog
                  },
                  child: Text(
                    "Remove",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color.fromARGB(255, 113, 113, 113),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
