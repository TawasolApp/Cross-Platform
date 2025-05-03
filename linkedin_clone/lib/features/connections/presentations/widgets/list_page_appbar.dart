import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/enums.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/dialogs/pop_up_menu_sort_by.dart';

class ListPageAppBar extends StatelessWidget {
  final PageType pageType;
  final int count;
  ConnectionsProvider? connectionsProvider;
  ListPageAppBar({
    super.key,
    required this.pageType,
    required this.count,
    this.connectionsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, thickness: 1, color: Theme.of(context).dividerColor),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical:
                MediaQuery.of(context).size.width * 0.02 > 8
                    ? 8
                    : MediaQuery.of(context).size.width * 0.02,
          ),

          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    pageType == PageType.connections
                        ? '$count Connections'
                        : pageType == PageType.manageMyNetwork
                        ? "Manage my network "
                        : '$count People',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              Spacer(),
              if (pageType == PageType.connections)
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
              if (pageType == PageType.connections)
                PopUpMenuSortBy(connectionsProvider: connectionsProvider),
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: Theme.of(context).dividerColor),
      ],
    );
  }
}
