import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/label_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/enums.dart';
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
            children: [
              LabelCard(label: "People", onTap: () {}),
              Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor,
              ),
              widget.searchProvider!.searchResultsUsers.isNotEmpty
                  ? ListView.builder(
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final user = list[index];

                      return Column(
                        children: [
                          UserCard(
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
                  : const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}
