import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/enums.dart';
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
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  UserAvatar(
                    profilePicture: profilePricture,
                    isOnline: false,
                    cardType: PageType.connections,
                    avatarSize: elementSize,
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Text(
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
