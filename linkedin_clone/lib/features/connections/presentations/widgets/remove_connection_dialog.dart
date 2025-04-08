// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../provider/connections_provider.dart';
import "error_dialog.dart";

class RemoveConnectionDialog extends StatelessWidget {
  final String userId;
  final String userName;
  final ConnectionsProvider connectionsProvider;
  const RemoveConnectionDialog({
    super.key,
    required this.userId,
    required this.userName,
    required this.connectionsProvider,
  });

  @override
  Widget build(BuildContext context) {
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
                    Navigator.pop(context); // Close pop-up menu
                  },
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (await connectionsProvider.removeConnection(userId)) {
                      Navigator.pop(context); // Close remove connection dialog
                      Navigator.pop(context); // Close pop-up menu
                    } else {
                      showDialog(
                        context: context,
                        builder:
                            (context) => ErrorDialog(
                              title: "Couldn't remove connection",
                              message:
                                  "Failed to remove connection, Please try again.",
                              buttonText: "Cancel",
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                                Navigator.pop(
                                  context,
                                ); // Close remove connection dialog
                              },
                            ),
                      );
                    }
                  },
                  child: Text(
                    "Remove",
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
