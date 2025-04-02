import 'package:flutter/material.dart';
import '../provider/connections_provider.dart';

class InvitationCard extends StatelessWidget {
  final String userId;
  final String userName;
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
    required this.userName,
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        /// **Name**
                        Text(
                          userName,
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

                        const SizedBox(height: 5),

                        /// **Connection Time**
                        Text(
                          receivedInvitation
                              ? int.parse(mutualConnections) == 1
                                  ? '1 mutual connection'
                                  : int.parse(mutualConnections) == 0
                                  ? " "
                                  : '$mutualConnections mutual connections'
                              : "",
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                                    if (result) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Connection removed!'),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Failed to remove connection.',
                                          ),
                                        ),
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
                                    if (result) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Connection accepted!'),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Failed to accept connection.',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            )
                            : TextButton(
                              onPressed: () async {
                                bool result = await connectionsProvider
                                    .removeConnection(userId);
                                if (result) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Connection removed!'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to remove connection.',
                                      ),
                                    ),
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
