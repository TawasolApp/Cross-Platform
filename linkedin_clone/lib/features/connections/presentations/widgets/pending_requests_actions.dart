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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          key: const ValueKey('ignore_pending_request_button'),

          icon: Icon(
            Icons.cancel_outlined,
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
          key: const ValueKey('accept_pending_request_button'),
          icon: Icon(
            Icons.check_circle_outline,
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
