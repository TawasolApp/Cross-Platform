import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/pop_up_menu_user.dart';
import '../provider/connections_provider.dart';
import '../../../../core/utils/connected_ago_formatter.dart';

/// **Connection Card** includes user data and action buttons
/// - User Data includes user image, name, headline, connection time, and online status
class ConnectionCard extends StatelessWidget {
  final String userId;
  final String userName;
  final String headLine;
  final String connectionTime;
  final String profilePicture;
  final bool isOnline;
  final ConnectionsProvider connectionsProvider;

  const ConnectionCard({
    super.key,
    required this.userId,
    required this.userName,
    required this.headLine,
    required this.connectionTime,
    required this.isOnline,
    required this.profilePicture,
    required this.connectionsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Routing to user profile page')),
          ), //TODO: Navigate to user profile ,
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
                            backgroundColor: Color.fromARGB(
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
                                      color:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.color,
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
                            userName,
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

                          const SizedBox(height: 5),

                          /// **Connection Time**
                          Text(
                            getConnectionTime(connectionTime),
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// **Action Buttons**
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: PopUpMenuUser(
                    userId: userId,
                    userName: userName,
                    connectionsProvider: connectionsProvider,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: IconButton(
                    icon: Transform.rotate(
                      angle: 315 * (3.141592653589793 / 180),
                      child: Icon(
                        Icons.send,
                        size: 23,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Routing to Messaging page')),
                      ); //TODO: Navigate to chat
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
