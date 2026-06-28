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
      key: const Key('key_generalsearch_padding'),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        key: const Key('key_generalsearch_inkwell'),
        onTap: () {
          provider.isSearching = false;
          provider.addToRecentSearchesUsers(user);
          goToProfile(context, userId: user.userId);
        },
        child: SizedBox(
          key: const Key('key_generalsearch_container'),
          width: double.infinity,
          child: Row(
            key: const Key('key_generalsearch_main_row'),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                key: const Key('key_generalsearch_search_icon'),
                Icons.search,
                size: elementSize,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              const SizedBox(
                key: Key('key_generalsearch_icon_spacer'),
                width: 8,
              ),
              Expanded(
                key: const Key('key_generalsearch_content_expanded'),
                child: Row(
                  key: const Key('key_generalsearch_text_row'),
                  children: [
                    Flexible(
                      key: const Key('key_generalsearch_name_flexible'),
                      child: Text(
                        '${user.firstName} ${user.lastName}',
                        key: const Key('key_generalsearch_name_text'),
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (user.headLine.isNotEmpty)
                      Flexible(
                        key: const Key('key_generalsearch_headline_flexible'),
                        child: Text(
                          '  •  $user.headLine',
                          key: const Key('key_generalsearch_headline_text'),
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(
                key: Key('key_generalsearch_avatar_spacer'),
                width: 8,
              ),
              UserAvatar(
                key: const Key('key_generalsearch_avatar'),
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
