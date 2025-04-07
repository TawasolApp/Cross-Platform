// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../provider/connections_provider.dart';
import "error_dialog.dart";

class UnfollowDialog extends StatelessWidget {
  final String userId;
  final String userName;
  final ConnectionsProvider connectionsProvider;

  const UnfollowDialog({
    super.key,
    required this.userId,
    required this.userName,
    required this.connectionsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
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
              "Unfollow $userName?",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Text(
              "Are you sure you want to unfollow $userName?",
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
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    //await connectionsProvider.unfollowUser(userId)
                    if (true) {
                      Navigator.pop(context); // Close unfollow dialog
                    } else {
                      showDialog(
                        context: context,
                        builder:
                            (context) => ErrorDialog(
                              title: "Error",
                              message: "Failed to unfollow user",
                              buttonText: "OK",
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pop(); // Close error dialog
                              },
                            ),
                      );
                    }
                  },
                  child: Text(
                    "Unfollow",
                    style: Theme.of(context).textTheme.bodyMedium,
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
