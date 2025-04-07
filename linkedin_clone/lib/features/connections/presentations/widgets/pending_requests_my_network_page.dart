import 'package:flutter/material.dart';
import "../provider/connections_provider.dart";
import '../../../../../../core/utils/time_formatter.dart';
import "invitation_card.dart";

class PendingRequestTile extends StatelessWidget {
  final ConnectionsProvider connectionsProvider;

  const PendingRequestTile({super.key, required this.connectionsProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          connectionsProvider.receivedConnectionRequestsList == null ||
                  connectionsProvider.receivedConnectionRequestsList!.isEmpty
              ? [SizedBox.shrink()]
              : connectionsProvider.receivedConnectionRequestsList!
                  .take(2)
                  .map(
                    (request) => InvitationCard(
                      userId: request.userId,
                      firstName: request.firstName,
                      lastName: request.lastName,
                      headLine: request.headLine,
                      profilePicture: request.profilePicture,
                      mutualConnections: '0',
                      connectionsProvider: connectionsProvider,
                      receivedInvitation: true,
                      time: formatTime(request.time),
                    ),
                  )
                  .toList(),
    );
  }
}
