import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/invitation_card.dart';
import 'no_internet_connection.dart';
import '../../../../core/utils/time_formatter.dart';
import 'linkedin_iconic_button.dart'; // Adjust the path if necessary

class SentInvitationsBody extends StatelessWidget {
  @override
  const SentInvitationsBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionsProvider>(
      builder: (context, connectionsProvider, _) {
        return RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () async {
            {
              await connectionsProvider.getReceivedConnectionRequests();
              await connectionsProvider.getSentConnectionRequests();
            }
          },
          child: Consumer<ConnectionsProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const SizedBox();
              } else if (provider.hasError) {
                if (provider.error == 'Request Timeout') {
                  return NoInternetConnection(
                    onRetry: () {
                      connectionsProvider.getReceivedConnectionRequests();
                      connectionsProvider.getSentConnectionRequests();
                    },
                  );
                } else {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height:
                          MediaQuery.of(context).size.height - kToolbarHeight,
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                }
              } else if (provider.sentConnectionRequestsList!.isEmpty) {
                return Center(
                  child: Text(
                    'No Sent Connection Requests',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }
              return ListView.builder(
                itemCount: provider.sentConnectionRequestsList!.length,
                itemBuilder: (context, index) {
                  final request = provider.sentConnectionRequestsList![index];
                  return InvitationCard(
                    userId: request.userId,
                    userName: request.firstName,
                    headLine: request.headLine,
                    profilePicture: request.profilePicture,
                    mutualConnections:
                        '5', // Replace with actual data if available
                    connectionsProvider: connectionsProvider,
                    receivedInvitation: false,
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
