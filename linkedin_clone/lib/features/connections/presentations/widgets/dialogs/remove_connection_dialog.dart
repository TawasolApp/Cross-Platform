// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../provider/connections_provider.dart';
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
      key: const Key('key_removeconnection_dialog'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ), // Makes edges sharp
      child: Padding(
        key: const Key('key_removeconnection_padding'),
        padding: const EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 10.0,
          bottom: 10.0,
        ),
        child: Column(
          key: const Key('key_removeconnection_column'),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Remove Connection?",
              key: const Key('key_removeconnection_title_text'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(
              key: const Key('key_removeconnection_spacer1'),
              height: 10,
            ),
            Text(
              "Are you sure you want to remove $userName from your connections?",
              key: const Key('key_removeconnection_message_text'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              key: const Key('key_removeconnection_spacer2'),
              height: 14,
            ),
            Row(
              key: const Key('key_removeconnection_buttons_row'),
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  key: const Key('key_removeconnection_cancel_button'),
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close pop-up menu
                  },
                  child: Text(
                    "Cancel",
                    key: const Key('key_removeconnection_cancel_text'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(
                  key: const Key('key_removeconnection_remove_button'),
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
                                Navigator.pop(context);
                              },
                            ),
                      );
                    }
                  },
                  child: Text(
                    "Remove",
                    key: const Key('key_removeconnection_remove_text'),
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
