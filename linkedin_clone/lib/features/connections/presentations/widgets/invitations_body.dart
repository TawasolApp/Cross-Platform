import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/page_type_enum.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/user_card.dart';
import 'package:provider/provider.dart';
import '../provider/connections_provider.dart';
import 'no_internet_connection.dart';

class InvitationsBody extends StatefulWidget {
  final PageType cardType;
  final ConnectionsProvider connectionsProvider;

  const InvitationsBody({
    super.key,
    required this.cardType,
    required this.connectionsProvider,
  });

  @override
  State<InvitationsBody> createState() => _InvitationsBodyState();
}

class _InvitationsBodyState extends State<InvitationsBody> {
  late ScrollController _scrollController;
  late ConnectionsProvider connectionsProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    connectionsProvider = widget.connectionsProvider;

    if (widget.cardType == PageType.pending) {
      connectionsProvider.getReceivedConnectionRequests(isInitial: true);
    } else if (widget.cardType == PageType.sent) {
      connectionsProvider.getSentConnectionRequests(isInitial: true);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !connectionsProvider.isBusy &&
        connectionsProvider.hasMoreSecondary) {
      if (widget.cardType == PageType.pending) {
        connectionsProvider.getReceivedConnectionRequests();
      } else if (widget.cardType == PageType.sent) {
        connectionsProvider.getSentConnectionRequests();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () async {
        if (widget.cardType == PageType.pending) {
          await connectionsProvider.getReceivedConnectionRequests(
            isInitial: true,
          );
        } else if (widget.cardType == PageType.sent) {
          await connectionsProvider.getSentConnectionRequests(isInitial: true);
        }
      },
      child: Consumer<ConnectionsProvider>(
        builder: (context, provider, _) {
          final isLoading = provider.isLoading;
          final hasError = provider.hasErrorMain;
          final errorText = provider.errorMain ?? '';
          final list =
              widget.cardType == PageType.pending
                  ? provider.receivedConnectionRequestsList
                  : provider.sentConnectionRequestsList;

          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (hasError) {
            if (errorText.contains('Request Timeout')) {
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
              return _emptyPlaceholder();
            }
          } else if (list == null || list.isEmpty) {
            return _emptyPlaceholder(
              child: Center(
                child: Text(
                  widget.cardType == PageType.pending
                      ? 'No Pending Connection Requests'
                      : 'No Sent Connection Requests',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          } else {
            return ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length + 1,
              itemBuilder: (context, index) {
                if (index < list.length) {
                  final request = list[index];
                  return Column(
                    children: [
                      UserCard(
                        userId: request.userId,
                        firstName: request.firstName,
                        lastName: request.lastName,
                        headLine: request.headLine,
                        profilePicture: request.profilePicture,
                        connectionsProvider: connectionsProvider,
                        time: request.time,
                        cardType: widget.cardType,
                      ),
                      Divider(height: 1, color: Theme.of(context).dividerColor),
                    ],
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
          }
        },
      ),
    );
  }

  Widget _emptyPlaceholder({Widget? child}) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        width: MediaQuery.of(context).size.width,
        child: child,
      ),
    );
  }
}
