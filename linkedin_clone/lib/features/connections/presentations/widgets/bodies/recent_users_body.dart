// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/recent_user_search_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/routing_functions.dart';

class RecentUsersBody extends StatelessWidget {
  SearchProvider? searchProvider;
  RecentUsersBody({super.key, required this.searchProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('key_recentusers_main_column'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          key: const Key('key_recentusers_title_container'),
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Text(
            'Recent Searches',
            key: const Key('key_recentusers_title_text'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          key: const Key('key_recentusers_list_container'),
          height: MediaQuery.of(context).size.height * 0.15,
          child: ListView.builder(
            key: const Key('key_recentusers_list'),
            scrollDirection: Axis.horizontal,
            itemCount: searchProvider?.recentSearchesUsers[0].length,
            itemBuilder: (context, index) {
              return RecentUserSearchCard(
                key: Key('key_recentusers_card_$index'),
                firstName: searchProvider!.recentSearchesUsers[0][index],
                lastName: searchProvider!.recentSearchesUsers[1][index],
                profilePricture: searchProvider!.recentSearchesUsers[2][index],
                userId: searchProvider!.recentSearchesUsers[3][index],
                onTap: () {
                  goToProfile(
                    context,
                    userId: searchProvider!.recentSearchesUsers[3][index],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
