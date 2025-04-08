// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'error_dialog.dart';
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
        MediaQuery.of(context).size.width * 0.08 > 40
            ? 40
            : MediaQuery.of(context).size.width * 0.08;
    return Row(
      children: [
        Flexible(
          child: IconButton(
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
        ),
        Flexible(
          child: IconButton(
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
        ),
      ],
    );
  }
}
