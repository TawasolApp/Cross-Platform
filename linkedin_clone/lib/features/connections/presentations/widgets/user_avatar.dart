import 'dart:math';

import 'package:flutter/material.dart';
import 'page_type_enum.dart';
import 'online_dot.dart';

class UserAvatar extends StatelessWidget {
  final String profilePicture;
  final bool isOnline;
  final PageType cardType;

  const UserAvatar({
    super.key,
    required this.profilePicture,
    required this.isOnline,
    required this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double radius = screenWidth * 0.09 > 20 ? 20 : screenWidth * 0.09;
    final double iconSize = screenWidth * 0.1 > 60 ? 60 : screenWidth * 0.1;
    final showOnline =
        cardType == PageType.connections ||
        cardType == PageType.followers ||
        cardType == PageType.following;
    final avatarSize = radius * 2;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: avatarSize,
        height: avatarSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CircleAvatar(
                radius: radius,
                backgroundImage:
                    (profilePicture != 'not available' &&
                            profilePicture != 'notavailable')
                        ? NetworkImage(profilePicture)
                        : null,
                backgroundColor: Theme.of(context).primaryColor,
                child:
                    (profilePicture == 'not available' ||
                            profilePicture == 'notavailable')
                        ? Icon(
                          Icons.person,
                          size: iconSize,
                          color: Theme.of(context).primaryColor,
                        )
                        : null,
              ),
            ),
            if (showOnline && isOnline)
              Positioned(
                bottom: avatarSize * sin(5 * pi / 180),
                left: avatarSize * cos(35 * pi / 180),
                child: OnlineDot(),
              ),
          ],
        ),
      ),
    );
  }
}
