// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'page_type_enum.dart';
import 'online_dot.dart';

class UserAvatar extends StatelessWidget {
  final String profilePicture;
  final bool isOnline;
  final PageType cardType;
  double avatarSize;

  UserAvatar({
    super.key,
    required this.profilePicture,
    required this.isOnline,
    required this.cardType,
    this.avatarSize = 0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double radius =
        avatarSize > 0
            ? avatarSize
            : screenWidth * 0.09 > 50
            ? 50
            : screenWidth * 0.09;
    final showOnline =
        cardType == PageType.connections ||
        cardType == PageType.followers ||
        cardType == PageType.following;
    final size = radius * 2;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: size,
        height: size,
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
                        : AssetImage('assets/images/profile_placeholder.jpg')
                            as ImageProvider<Object>,
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
