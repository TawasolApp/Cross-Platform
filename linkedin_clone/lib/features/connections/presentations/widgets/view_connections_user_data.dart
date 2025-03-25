import 'package:flutter/material.dart';
import '../../../../core/utils/connected_ago_formatter.dart';

///used for displaying user data in the connections list
class ViewConnectionsUserData extends StatelessWidget {
  final String name;
  final String headLine;
  final String connectionTime;
  final String image;
  final bool isOnline;

  final GlobalKey _avatarKey = GlobalKey();

  ViewConnectionsUserData({
    super.key,
    required this.name,
    required this.headLine,
    required this.connectionTime,
    required this.image,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  key: _avatarKey,
                  radius: 28,
                  backgroundImage:
                      image != 'notavailable' ? NetworkImage(image) : null,
                  backgroundColor:
                      Colors.grey[300], // Optional background color
                  child:
                      image == 'notavailable'
                          ? Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey[700],
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
                            color: const Color.fromARGB(255, 43, 109, 46),
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
                  name,
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
    );
  }
}
