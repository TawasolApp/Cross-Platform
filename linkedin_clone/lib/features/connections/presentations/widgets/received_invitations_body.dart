// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/invitation_card.dart';
import 'no_internet_connection.dart';
import '../../../../core/utils/time_formatter.dart';

class ReceivedInvitationsBody extends StatefulWidget {
  const ReceivedInvitationsBody({super.key});

  @override
  State<ReceivedInvitationsBody> createState() =>
      _ReceivedInvitationsBodyState();
}

class _ReceivedInvitationsBodyState extends State<ReceivedInvitationsBody> {
  // @override
  // void initState() {
  //   super.initState();
  //   final connectionsProvider = Provider.of<ConnectionsProvider>(
  //     context,
  //     listen: false,
  //   );
  //   connectionsProvider.getReceivedConnectionRequests(isInitial: true);
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionsProvider>(
      builder: (context, connectionsProvider, _) {
        return RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () async {
            await connectionsProvider.getReceivedConnectionRequests(
              isInitial: true,
            );
          },
          child: Consumer<ConnectionsProvider>(
            builder: (context, provider, _) {
              print(
                'ReceivedInvitationsBody: isLoading: ${provider.isLoading}',
              );
              print(
                'ReceivedInvitationsBody: hasErrorMain: ${provider.hasErrorMain}',
              );
              print(
                'ReceivedInvitationsBody: receivedConnectionRequestsList: ${provider.receivedConnectionRequestsList}',
              );
              if (provider.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              } else if (provider.hasErrorMain) {
                print('ReceivedInvitationsBody: Error: ${provider.errorMain}');
                if (provider.errorMain?.contains('Request Timeout') ?? false) {
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
              } else if (provider.receivedConnectionRequestsList!.isEmpty) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - kToolbarHeight,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        'No Pending Connection Requests',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                );
              } else
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: provider.receivedConnectionRequestsList!.length,
                  itemBuilder: (context, index) {
                    final request =
                        provider.receivedConnectionRequestsList![index];
                    return InvitationCard(
                      userId: request.userId,
                      firstName: request.firstName,
                      lastName: request.lastName,
                      headLine: request.headLine,
                      profilePicture: request.profilePicture,
                      mutualConnections: '5',
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
