import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/routing_functions.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/user_avatar.dart';

class GeneralSearchCard extends StatelessWidget {
  final ConnectionsUserEntity user;
  final SearchProvider provider;

  const GeneralSearchCard({
    super.key,
    required this.provider,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    double elementSize = MediaQuery.of(context).size.width * 0.05;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          provider.isSearching = false;
          provider.addToRecentSearchesUsers(user);
          goToProfile(context, userId: user.userId);
        },
        child: SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: elementSize,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${user.firstName} ${user.lastName}',
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (user.headLine.isNotEmpty)
                      Flexible(
                        child: Text(
                          '  •  $user.headLine',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              UserAvatar(
                profilePicture: user.profilePicture,
                isOnline: false,
                cardType: PageType.connections,
                avatarSize:
                    MediaQuery.of(context).size.width * 0.05 > 30
                        ? 30
                        : MediaQuery.of(context).size.width * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
