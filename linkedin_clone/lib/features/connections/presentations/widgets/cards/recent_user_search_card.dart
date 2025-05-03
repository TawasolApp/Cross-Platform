import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/user_avatar.dart';

class RecentUserSearchCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String userId;
  final String profilePricture;
  final VoidCallback onTap;
  const RecentUserSearchCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.profilePricture,
    required this.userId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double elementSize = MediaQuery.of(context).size.width * 0.05;
    return InkWell(
      key: const Key('key_recentusersearch_inkwell'),
      onTap: onTap,
      child: Padding(
        key: const Key('key_recentusersearch_padding'),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          key: const Key('key_recentusersearch_main_column'),
          children: [
            Flexible(
              key: const Key('key_recentusersearch_flexible'),
              fit: FlexFit.tight,
              child: Column(
                key: const Key('key_recentusersearch_inner_column'),
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  UserAvatar(
                    key: const Key('key_recentusersearch_avatar'),
                    profilePicture: profilePricture,
                    isOnline: false,
                    cardType: PageType.connections,
                    avatarSize: elementSize,
                  ),
                  const SizedBox(
                    key: Key('key_recentusersearch_spacer'),
                    width: 4,
                  ),
                  SizedBox(
                    key: const Key('key_recentusersearch_text_container'),
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Text(
                      key: const Key('key_recentusersearch_name_text'),
                      '$firstName $lastName',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
