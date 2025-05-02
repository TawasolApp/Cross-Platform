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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: searchProvider?.recentSearchesUsers[0].length,
            itemBuilder: (context, index) {
              return RecentUserSearchCard(
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
