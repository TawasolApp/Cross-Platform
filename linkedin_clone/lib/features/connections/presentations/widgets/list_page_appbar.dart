import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
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
      key: const Key('list_page_appbar_main_column'),
      children: [
        Divider(
          key: const Key('list_page_appbar_top_divider'),
          height: 1,
          thickness: 1,
          color: Theme.of(context).dividerColor,
        ),
        Padding(
          key: const Key('list_page_appbar_outer_padding'),
          padding: EdgeInsets.symmetric(
            vertical:
                MediaQuery.of(context).size.width * 0.02 > 8
                    ? 8
                    : MediaQuery.of(context).size.width * 0.02,
          ),

          child: Row(
            key: const Key('list_page_appbar_main_row'),
            children: [
              Padding(
                key: const Key('list_page_appbar_title_outer_padding'),
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  key: const Key('list_page_appbar_title_inner_padding'),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    pageType == PageType.connections
                        ? '$count Connections'
                        : pageType == PageType.manageMyNetwork
                        ? "Manage my network "
                        : '$count People',
                    key: const Key('list_page_appbar_title_text'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              Spacer(key: const Key('list_page_appbar_spacer')),
              if (pageType == PageType.connections)
                IconButton(
                  key: const Key('search_list_page_button'),
                  icon: Icon(
                    Icons.search,
                    key: const Key('list_page_appbar_search_icon'),
                    size: 25,
                  ),
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  onPressed: () {
                    //placeholder for now
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        key: const Key('list_page_appbar_snackbar'),
                        content: Text(
                          'Routing to search page',
                          key: const Key('list_page_appbar_snackbar_text'),
                        ),
                      ),
                    );
                    //TODO: route to search page
                  },
                ),
              if (pageType == PageType.connections)
                PopUpMenuSortBy(
                  key: const Key('list_page_appbar_sort_menu'),
                  connectionsProvider: connectionsProvider,
                ),
            ],
          ),
        ),
        Divider(
          key: const Key('list_page_appbar_bottom_divider'),
          height: 1,
          thickness: 1,
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }
}
