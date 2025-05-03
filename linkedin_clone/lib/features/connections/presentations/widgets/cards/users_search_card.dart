import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/user_card.dart';

import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';

class UserSearchCard extends StatelessWidget {
  final List<ConnectionsUserEntity> users;

  const UserSearchCard({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final displayedUsers = users.length > 3 ? users.sublist(0, 3) : users;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: Text(
              "People",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children:
                  displayedUsers.map((user) {
                    return Column(
                      children: [
                        Divider(color: Theme.of(context).dividerColor),
                        UserCard(
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
        ],
      ),
    );
  }
}
