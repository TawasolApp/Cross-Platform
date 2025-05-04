// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dialogs/error_dialog.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';

class PendingRequestsActions extends StatelessWidget {
  final ConnectionsProvider connectionsProvider;
  final String userId;

  const PendingRequestsActions({
    super.key,
    required this.connectionsProvider,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize =
        MediaQuery.of(context).size.width * 0.1 > 50
            ? 50
            : MediaQuery.of(context).size.width * 0.1;
    return Row(
      key: Key('pending_requests_actions_row_$userId'),
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          key: Key('pending_requests_ignore_button_$userId'),
          icon: Icon(
            Icons.cancel_outlined,
            key: Key('pending_requests_ignore_icon_$userId'),
            size: double.tryParse(iconSize.toString()),
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () async {
            final result = await connectionsProvider.ignoreConnectionRequest(
              userId,
            );
            if (!result) {
              showDialog(
                context: context,
                builder:
                    (context) => ErrorDialog(
                      key: Key('pending_requests_ignore_error_dialog_$userId'),
                      title: 'Error',
                      message: 'Failed to ignore connection request.',
                      buttonText: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
              );
            } else {
              connectionsProvider.getReceivedConnectionRequests(
                isInitial: true,
              );
            }
          },
        ),
        IconButton(
          key: Key('pending_requests_accept_button_$userId'),
          icon: Icon(
            Icons.check_circle_outline,
            key: Key('pending_requests_accept_icon_$userId'),
            size: double.tryParse(iconSize.toString()),
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
          onPressed: () async {
            final result = await connectionsProvider.acceptConnectionRequest(
              userId,
            );
            if (!result) {
              showDialog(
                context: context,
                builder:
                    (context) => ErrorDialog(
                      key: Key('pending_requests_accept_error_dialog_$userId'),
                      title: 'Error',
                      message: 'Failed to accept connection request.',
                      buttonText: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
              );
            } else {
              connectionsProvider.getReceivedConnectionRequests(
                isInitial: true,
              );
            }
          },
        ),
      ],
    );
  }
}
