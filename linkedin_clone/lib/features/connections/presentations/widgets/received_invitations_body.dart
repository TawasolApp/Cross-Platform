import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/invitation_card.dart';
import 'no_internet_connection.dart';
import '../../../../core/utils/time_formatter.dart';

class ReceivedInvitationsBody extends StatelessWidget {
  @override
  const ReceivedInvitationsBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionsProvider>(
      builder: (context, connectionsProvider, _) {
        return RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () {
            return Future(() {
              connectionsProvider.getReceivedConnectionRequests();
              connectionsProvider.getSentConnectionRequests();
            });
          },
          child: Consumer<ConnectionsProvider>(
            builder: (context, provider, _) {
              if (provider.receivedConnectionRequestsList == null) {
                return NoInternetConnection(
                  onRetry: () {
                    provider.getReceivedConnectionRequests();
                    provider.getSentConnectionRequests();
                  },
                );
              } else if (provider.receivedConnectionRequestsList!.isEmpty) {
                return const SizedBox();
              }
              return ListView.builder(
                itemCount: provider.receivedConnectionRequestsList!.length,
                itemBuilder: (context, index) {
                  final request =
                      provider.receivedConnectionRequestsList![index];
                  return InvitationCard(
                    userId: request.userId,
                    userName: request.userName,
                    headLine: request.headLine,
                    profilePicture: request.profilePicture,
                    mutualConnections:
                        '5', // Replace with actual data if available
                    connectionsProvider: connectionsProvider,
                    receivedInvitation: true,
                    time: formatTime(request.time),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
