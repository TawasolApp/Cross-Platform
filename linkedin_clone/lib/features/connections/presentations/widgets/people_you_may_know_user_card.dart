// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/error_dialog.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/linkedin_iconic_button.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/people_you_may_know_user_card_info.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/page_type_enum.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/routing_functions.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/user_avatar.dart';
import 'package:provider/provider.dart';

class PeopleYouMayKnowUserCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String userId;
  final String profileImageUrl;
  final String headerImageUrl;
  final String headLine;
  final ConnectionsProvider? connectionsProvider;
  final NetworksProvider? networksProvider;

  const PeopleYouMayKnowUserCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.userId,
    required this.profileImageUrl,
    required this.headerImageUrl,
    required this.headLine,
    required this.connectionsProvider,
    required this.networksProvider,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double cardWdith =
        screenWidth * 0.45 > 200 ? 200 : screenWidth * 0.45;
    final double cardHeight =
        screenHeight * 0.4 > 300 ? 300 : screenHeight * 0.4;
    return InkWell(
      onTap: () {
        goToProfile(context, userId: userId);
      },
      child: Center(
        child: Container(
          width: cardWdith,
          height: cardHeight,
          //padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child:
                            headerImageUrl != "notavailable"
                                ? Image.network(
                                  headerImageUrl,
                                  width: double.infinity,
                                  height: cardHeight * 0.25,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  width: double.infinity,
                                  height: cardHeight * 0.25,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withBlue(
                                        Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant
                                                .blue +
                                            50,
                                      )
                                      .withRed(
                                        Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant.red +
                                            50,
                                      )
                                      .withGreen(
                                        Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant
                                                .green +
                                            50,
                                      ),
                                ),
                      ),
                      SizedBox(
                        height: cardHeight * 0.15,
                        width: double.infinity,
                        child: Container(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: cardHeight * 0.1,
                    child: UserAvatar(
                      profilePicture: profileImageUrl,
                      isOnline: false,
                      cardType: PageType.others,
                      avatarSize:
                          screenWidth * 0.1 > 80 ? 80 : screenWidth * 0.1,
                    ),
                  ),
                ],
              ),

              //const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PeopleYouMayKnowUserCardInfo(
                    firstName: firstName,
                    lastName: lastName,
                    headLine: headLine,
                  ),
                ),
              ),

              // const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomCenter,

                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: LinkedInIconicButton(
                    width: cardWdith * 0.3,
                    label: "Connect",
                    onPressed: () async {
                      final result = await connectionsProvider
                          ?.sendConnectionRequest(userId);
                      if (!result!) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(
                              title: "Connection Request Failed",
                              message:
                                  "Couldn't send connection request to $firstName $lastName.",
                              buttonText: "Cancel",
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      } else {
                        networksProvider?.removePeopleyouMayKnowElement(userId);
                      }
                    },
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
