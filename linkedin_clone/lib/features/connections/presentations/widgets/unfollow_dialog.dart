// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../provider/networks_provider.dart';
import "error_dialog.dart";

class UnfollowDialog extends StatelessWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final NetworksProvider networksProvider;

  const UnfollowDialog({
    super.key,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.networksProvider,
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
              "Unfollow $firstName $lastName?",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Text(
              "Are you sure you want to unfollow $firstName $lastName?",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close dialog
                  },
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (await networksProvider.unfollowUser(userId)) {
                      networksProvider.getFollowersList(isInitial: true);
                      Navigator.pop(context); // Close unfollow dialog
                    } else {
                      showDialog(
                        context: context,
                        builder:
                            (context) => ErrorDialog(
                              title: "Error",
                              message:
                                  "Failed to unfollow $firstName $lastName",
                              buttonText: "Cancel",
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Close error dialog
                                Navigator.of(context).pop();
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
