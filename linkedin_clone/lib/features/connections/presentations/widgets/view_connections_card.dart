import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/pop_up_menu_user.dart';
import 'view_connections_user_data.dart';

/// **Connection Card** includes user data and action buttons
/// - User Data includes user image, name, headline, connection time, and online status
class ConnectionCard extends StatelessWidget {
  final String userId;
  final String userName;
  final String headLine;
  final String connectionTime;
  final String image;
  final bool isOnline;

  const ConnectionCard({
    super.key,
    required this.userId,
    required this.userName,
    required this.headLine,
    required this.connectionTime,
    required this.isOnline,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ViewConnectionsUserData(
              isOnline: isOnline,
              image: image,
              name: userName,
              headLine: headLine,
              connectionTime: connectionTime,
            ),
          ),

          /// **Action Buttons**
          Row(
            ////////FIXME: this can be listTile
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: PopUpMenuUser(userId: userId, userName: userName),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: IconButton(
                  icon: Transform.rotate(
                    angle: 315 * (3.141592653589793 / 180),
                    child: Icon(
                      Icons.send,
                      size: 23,
                      color: const Color.fromARGB(255, 30, 30, 30),
                    ),
                  ),
                  onPressed: () {
                    print(
                      'Send message to $userName ID $userId',
                    ); //TODO: Navigate to chat
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
