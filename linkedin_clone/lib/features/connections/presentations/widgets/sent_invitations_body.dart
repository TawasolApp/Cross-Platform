import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/invitation_card.dart';
import 'no_internet_connection.dart';
import '../../../../core/utils/time_formatter.dart';

class SentInvitationsBody extends StatefulWidget {
  const SentInvitationsBody({super.key});

  @override
  State<SentInvitationsBody> createState() => _SentInvitationsBodyState();
}

class _SentInvitationsBodyState extends State<SentInvitationsBody> {
  // @override
  // void initState() {
  //   super.initState();
  //   final connectionsProvider = Provider.of<ConnectionsProvider>(
  //     context,
  //     listen: false,
  //   );
  //   connectionsProvider.getSentConnectionRequests(isInitial: true);
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionsProvider>(
      builder: (context, connectionsProvider, _) {
        return RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () async {
            await connectionsProvider.getSentConnectionRequests(
              isInitial: true,
            );
          },
          child: Consumer<ConnectionsProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              } else if (provider.hasErrorSecondary) {
                if (provider.errorSecondary?.contains('Request Timeout') ??
                    false) {
                  return NoInternetConnection(
                    onRetry: () {
                      connectionsProvider.getInvitations(
                        isInitsent: true,
                        isInitRec: true,
                        refreshRec: true,
                        refreshSent: true,
                      );
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
              } else
                return ListView.builder(
                  itemCount: provider.sentConnectionRequestsList!.length,
                  itemBuilder: (context, index) {
                    final request = provider.sentConnectionRequestsList![index];
                    return InvitationCard(
                      userId: request.userId,
                      firstName: request.firstName,
                      lastName: request.lastName,
                      headLine: request.headLine,
                      profilePicture: request.profilePicture,
                      mutualConnections: '0',
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
