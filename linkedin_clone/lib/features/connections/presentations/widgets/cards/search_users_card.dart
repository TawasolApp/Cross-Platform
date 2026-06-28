import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/label_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/user_card.dart';
import 'package:provider/provider.dart';
import '../misc/routing_functions.dart';

class SearchUsersCard extends StatefulWidget {
  final List<ConnectionsUserEntity> users;
  final SearchProvider? searchProvider;
  const SearchUsersCard({super.key, required this.users, this.searchProvider});

  @override
  State<SearchUsersCard> createState() => _SearchUsersCardState();
}

class _SearchUsersCardState extends State<SearchUsersCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('search_users_card_container'),
      color: Theme.of(context).colorScheme.onSecondary,
      child: Consumer<SearchProvider>(
        builder: (context, provider, _) {
          final list =
              widget.searchProvider!.searchResultsUsers.length >= 2
                  ? widget.searchProvider!.searchResultsUsers.sublist(0, 2)
                  : widget.searchProvider!.searchResultsUsers.length == 1
                  ? [widget.searchProvider!.searchResultsUsers[0]]
                  : [];
          return Column(
            key: const Key('search_users_card_main_column'),
            children: [
              LabelCard(
                key: const Key('search_users_card_label_card'),
                label: "People",
                onTap: () {},
              ),
              Divider(
                key: const Key('search_users_card_divider'),
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor,
              ),
              widget.searchProvider!.searchResultsUsers.isNotEmpty
                  ? ListView.builder(
                    key: const Key('search_users_card_listview'),
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final user = list[index];

                      return Column(
                        key: Key('search_users_card_user_column_$index'),
                        children: [
                          UserCard(
                            key: Key('search_users_card_user_$index'),
                            userId: user.userId,
                            firstName: user.firstName,
                            lastName: user.lastName,
                            headLine: user.headLine,
                            profilePicture: user.profilePicture,
                            isOnline: false,
                            time: user.time,
                            cardType: PageType.followers,
                          ),
                        ],
                      );
                    },
                  )
                  : const SizedBox.shrink(
                    key: Key('search_users_card_empty_state'),
                  ),
            ],
          );
        },
      ),
    );
  }
}
