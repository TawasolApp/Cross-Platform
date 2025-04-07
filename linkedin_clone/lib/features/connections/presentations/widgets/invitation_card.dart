// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/connections_provider.dart';
import "error_dialog.dart";

class InvitationCard extends StatelessWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final String headLine;
  final String profilePicture;
  final ConnectionsProvider connectionsProvider;
  final String mutualConnections; // Default value
  final bool receivedInvitation; // Default value
  final String time;
  // Default value

  const InvitationCard({
    super.key,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.headLine,
    required this.profilePicture,
    required this.connectionsProvider,
    required this.mutualConnections,
    required this.receivedInvitation,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Routing to Messaging page')));
      },
      child: Container(
        color: Theme.of(context).colorScheme.onSecondary,
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Column(
          children: [
            // Divider(
            //   height: 1,
            //   thickness: 1,
            //   color: Theme.of(context).dividerColor,
            //),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          profilePicture != 'not available'
                              ? NetworkImage(profilePicture)
                              : null,
                      backgroundColor: Color.fromARGB(
                        255,
                        214,
                        210,
                        200,
                      ), // Optional background color
                      child:
                          profilePicture == 'not available'
                              ? Icon(
                                Icons.person,
                                size: 40,
                                color: Theme.of(context).primaryColor,
                              )
                              : null,
                    ),
                  ),

                  /// **User Details**
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /// **Name**
                        Text(
                          "$firstName $lastName",
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),

                        /// **Headline**
                        Text(
                          headLine,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        SizedBox(height: 5),
                        // Text(
                        //   receivedInvitation
                        //       ? int.parse(mutualConnections) == 1
                        //           ? '1 mutual connection'
                        //           : int.parse(mutualConnections) == 0
                        //           ? ""
                        //           : '$mutualConnections mutual connections'
                        //       : "",
                        //   style: Theme.of(context).textTheme.bodySmall,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                        Text(
                          receivedInvitation ? time : "Sent $time",
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  /// **Accept/Decline Button**
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child:
                        receivedInvitation
                            ? Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    size: 40,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () async {
                                    bool result = await connectionsProvider
                                        .ignoreConnectionRequest(userId);
                                    if (!result) {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => ErrorDialog(
                                              title: 'Error',
                                              message:
                                                  'Failed to ignore connection request.',
                                              buttonText: 'Cancel',
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                      );
                                    } else {
                                      connectionsProvider
                                          .getReceivedConnectionRequests(
                                            isInitial: true,
                                          );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.check_circle_outline,
                                    size: 40,
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.titleLarge?.color,
                                  ),
                                  onPressed: () async {
                                    bool result = await connectionsProvider
                                        .acceptConnectionRequest(userId);
                                    if (!result) {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => ErrorDialog(
                                              title: 'Error',
                                              message:
                                                  'Failed to accept connection request.',
                                              buttonText: 'Cancel',
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                      );
                                    } else {
                                      connectionsProvider
                                          .getReceivedConnectionRequests(
                                            isInitial: true,
                                          );
                                    }
                                  },
                                ),
                              ],
                            )
                            : TextButton(
                              onPressed: () async {
                                bool result = await connectionsProvider
                                    .withdrawConnectionRequest(userId);
                                if (!result) {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => ErrorDialog(
                                          title: 'Error',
                                          message:
                                              'Failed to withdraw connection request.',
                                          buttonText: 'Cancel',
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                  );
                                } else {
                                  connectionsProvider.getSentConnectionRequests(
                                    isInitial: true,
                                  );
                                }
                              },
                              child: Text(
                                "Withdraw",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
