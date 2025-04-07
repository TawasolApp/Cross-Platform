import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';

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
    return GestureDetector(
      onTap:
          () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Routing to user profile page')),
          ), //TODO: Navigate to user profile
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          /// **Profile Picture**
                          CircleAvatar(
                            radius: 28,
                            backgroundImage:
                                profilePicture != 'not available'
                                    ? NetworkImage(profilePicture)
                                    : null,
                            backgroundColor: const Color.fromARGB(
                              255,
                              214,
                              210,
                              200,
                            ), // Optional background color
                            child:
                                profilePicture == 'not available'
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
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        43,
                                        109,
                                        46,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),

                                  /// **Smaller White Dot on Top**
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
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
                    TextButton(
                      onPressed: () {},
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
    );
  }
}
