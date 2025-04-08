import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/pop_up_menu_sort_by.dart';
import '../provider/connections_provider.dart';

/// AppBar for the View Connections Page
/// icon buttons for search and filtering connections
class ViewConnectionsAppBar extends StatelessWidget {
  final ConnectionsProvider connectionsProvider;
  final int connectionsCount;

  const ViewConnectionsAppBar({
    required this.connectionsCount,
    super.key,
    required this.connectionsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, thickness: 1, color: Theme.of(context).dividerColor),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '$connectionsCount connections',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.search, size: 25),
              color: Theme.of(context).textTheme.bodyMedium?.color,
              onPressed: () {
                //placeholder for now
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Routing to search page')),
                );
                //TODO: route to search page
              },
            ),
            PopUpMenuSortBy(connectionsProvider: connectionsProvider),
          ],
        ),
        Divider(height: 1, thickness: 1, color: Theme.of(context).dividerColor),
      ],
    );
  }
}
