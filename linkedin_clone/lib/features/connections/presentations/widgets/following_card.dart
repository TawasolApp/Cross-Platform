import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import "unfollow_dialog.dart";

/// **Follow Card** includes user data
/// - User Data includes user image, name, headline, and online status
class FollowCard extends StatelessWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final String headLine;
  final String profilePicture;
  final bool isOnline;
  final NetworksProvider networksProvider;

  const FollowCard({
    super.key,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.headLine,
    required this.isOnline,
    required this.profilePicture,
    required this.networksProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Routing to user profile page')),
              ), // TODO: Navigate to user profile
          borderRadius: BorderRadius.circular(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// **Profile Image with Online Indicator**
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                          right: 8,
                          left: 8,
                        ),
                        child: Stack(
                          children: [
                            /// **Profile Picture**
                            CircleAvatar(
                              radius: 28,
                              backgroundImage:
                                  profilePicture != 'notavailable'
                                      ? NetworkImage(profilePicture)
                                      : null,
                              backgroundColor: const Color.fromARGB(
                                255,
                                214,
                                210,
                                200,
                              ),
                              child:
                                  profilePicture == 'notavailable'
                                      ? Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Theme.of(context).primaryColor,
                                      )
                                      : null,
                            ),

                            /// **Online Indicator**
                            if (isOnline)
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    /// **Larger Green Dot**
                                    Container(
                                      width: 14,
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 43, 109, 46),
                                        shape: BoxShape.circle,
                                      ),
                                    ),

                                    /// **Smaller White Dot on Top**
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      /// **User Details**
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            /// **Name**
                            Text(
                              '$firstName $lastName',
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                            ),

                            /// **Headline**
                            Text(
                              headLine,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),

                      /// **Following Button**
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => UnfollowDialog(
                                  firstName: firstName,
                                  lastName: lastName,
                                  networksProvider: networksProvider,
                                  userId: userId,
                                ),
                          );
                        },
                        child: Text(
                          'Following',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
