import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/user_card.dart';

import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UserSearchCard extends StatelessWidget {
  final List<ConnectionsUserEntity> users;
  SearchProvider? _searchProvider;
  UserSearchCard({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    _searchProvider = Provider.of<SearchProvider>(context);
    final displayedUsers = users.length > 3 ? users.sublist(0, 3) : users;

    return Container(
      key: const Key('users_search_card_container'),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
      ),
      child: Column(
        key: const Key('users_search_card_main_column'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            key: const Key('users_search_card_title_padding'),
            padding: const EdgeInsets.only(top: 18.0, left: 16.0),
            child: Text(
              "People",
              key: const Key('users_search_card_title_text'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(
            key: Key('users_search_card_title_spacer'),
            height: 10,
          ),
          Padding(
            key: const Key('users_search_card_content_padding'),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              key: const Key('users_search_card_users_column'),
              children:
                  displayedUsers.map((user) {
                    final int index = displayedUsers.indexOf(user);
                    return Column(
                      key: Key('users_search_card_user_column_$index'),
                      children: [
                        Divider(
                          key: Key('users_search_card_divider_$index'),
                          color: Theme.of(context).dividerColor,
                        ),
                        UserCard(
                          key: Key('users_search_card_user_card_$index'),
                          userId: user.userId,
                          firstName: user.firstName,
                          lastName: user.lastName,
                          headLine: user.headLine,
                          profilePicture: user.profilePicture,
                          cardType: PageType.search,
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
          Center(
            key: const Key('users_search_card_button_center'),
            child: TextButton(
              key: const Key('users_search_card_see_all_button'),
              onPressed: () {
                _searchProvider?.filterType = FilterType.people;
              },
              child: Text(
                "See all people",
                key: const Key('users_search_card_see_all_text'),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
