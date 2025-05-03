import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/user_card.dart';
import 'package:provider/provider.dart';
import '../../provider/connections_provider.dart';
import '../dialogs/no_internet_connection.dart';

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
      key: const Key('key_invitationsbody_refresh_indicator'),
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
        key: const Key('key_invitationsbody_consumer'),
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
              key: const Key('key_invitationsbody_loading_center'),
              child: CircularProgressIndicator(
                key: const Key('key_invitationsbody_loading_indicator'),
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (hasError) {
            if (errorText.contains('Request Timeout')) {
              return NoInternetConnection(
                key: const Key('key_invitationsbody_no_internet'),
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
              return _emptyPlaceholder(
                key: const Key('key_invitationsbody_error_placeholder'),
              );
            }
          } else if (list == null || list.isEmpty) {
            return _emptyPlaceholder(
              key: const Key('key_invitationsbody_empty_placeholder'),
              child: Center(
                key: const Key('key_invitationsbody_empty_center'),
                child: Text(
                  widget.cardType == PageType.pending
                      ? 'No Pending Connection Requests'
                      : 'No Sent Connection Requests',
                  key: const Key('key_invitationsbody_empty_text'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          } else {
            return ListView.builder(
              key: const Key('key_invitationsbody_list'),
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length + 1,
              itemBuilder: (context, index) {
                if (index < list.length) {
                  final request = list[index];
                  return Column(
                    key: Key('key_invitationsbody_item_column_$index'),
                    children: [
                      UserCard(
                        key: Key('key_invitationsbody_user_card_$index'),
                        userId: request.userId,
                        firstName: request.firstName,
                        lastName: request.lastName,
                        headLine: request.headLine,
                        profilePicture: request.profilePicture,
                        connectionsProvider: connectionsProvider,
                        time: request.time,
                        cardType: widget.cardType,
                      ),
                      Divider(
                        key: Key('key_invitationsbody_divider_$index'),
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    ],
                  );
                } else {
                  return provider.isBusy
                      ? Padding(
                        key: const Key(
                          'key_invitationsbody_loading_more_padding',
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          key: const Key(
                            'key_invitationsbody_loading_more_center',
                          ),
                          child: CircularProgressIndicator(
                            key: const Key(
                              'key_invitationsbody_loading_more_indicator',
                            ),
                          ),
                        ),
                      )
                      : const SizedBox.shrink(
                        key: Key('key_invitationsbody_list_end'),
                      );
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _emptyPlaceholder({Widget? child, Key? key}) {
    return SingleChildScrollView(
      key: key ?? const Key('key_invitationsbody_empty_scroll'),
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        key: const Key('key_invitationsbody_empty_container'),
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        width: MediaQuery.of(context).size.width,
        child: child,
      ),
    );
  }
}
