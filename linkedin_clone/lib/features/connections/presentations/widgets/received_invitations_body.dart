// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures

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
  late ScrollController _scrollController;
  late ConnectionsProvider connectionsProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    connectionsProvider = Provider.of<ConnectionsProvider>(
      context,
      listen: false,
    );
    connectionsProvider.getReceivedConnectionRequests(isInitial: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !connectionsProvider.isBusy &&
        connectionsProvider.hasMoreSecondary) {
      connectionsProvider.getReceivedConnectionRequests();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
              if (provider.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              } else if (provider.hasErrorMain) {
                if (provider.errorMain?.contains('Request Timeout') ?? false) {
                  return NoInternetConnection(
                    onRetry: () async {
                      await connectionsProvider.getInvitations(
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
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount:
                      provider.receivedConnectionRequestsList!.length + 1,
                  itemBuilder: (context, index) {
                    if (index <
                        provider.receivedConnectionRequestsList!.length) {
                      final request =
                          provider.receivedConnectionRequestsList![index];
                      return InvitationCard(
                        userId: request.userId,
                        firstName: request.firstName,
                        lastName: request.lastName,
                        headLine: request.headLine,
                        profilePicture: request.profilePicture,
                        mutualConnections: '0',
                        connectionsProvider: connectionsProvider,
                        receivedInvitation: true,
                        time: formatTime(request.time),
                      );
                    } else {
                      return provider.isBusy
                          ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                          : const SizedBox.shrink();
                    }
                  },
                );
            },
          ),
        );
      },
    );
  }
}
