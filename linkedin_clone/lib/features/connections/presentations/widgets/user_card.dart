// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cconfirmable_action_button.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/user_avatar.dart';
import 'user_card_info.dart';
import 'pending_requests_actions.dart';
import 'connections_list_actions.dart';
import 'page_type_enum.dart';

class UserCard extends StatelessWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final String headLine;
  final String profilePicture;
  final bool isOnline;
  final String time;
  final PageType cardType;
  final ConnectionsProvider? connectionsProvider;
  final NetworksProvider? networksProvider;

  const UserCard({
    super.key,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.headLine,
    required this.profilePicture,
    this.isOnline = false,
    this.time = '',
    required this.cardType,
    this.connectionsProvider,
    this.networksProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Material(
        color: Theme.of(context).colorScheme.onSecondary,

        child: InkWell(
          onTap: () => _goToProfile(context),
          borderRadius: BorderRadius.circular(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Profile image and online indicator
              UserAvatar(
                profilePicture: profilePicture,
                isOnline: isOnline,
                cardType: cardType,
              ),
              Expanded(
                child: UserCardInfo(
                  firstName: firstName,
                  lastName: lastName,
                  headLine: headLine,
                  time: time,
                  cardType: cardType,
                ),
              ),

              /// Action buttons based on cardType
              if (cardType == PageType.pending)
                PendingRequestsActions(
                  userId: userId,
                  connectionsProvider: connectionsProvider!,
                )
              else if (cardType == PageType.sent)
                ConfirmableActionButton(
                  buttonText: "Withdraw",
                  confirmAction:
                      () => connectionsProvider!.withdrawConnectionRequest(
                        userId,
                      ),
                  conrifmDialogCancelAction: () async {
                    Navigator.pop(context);
                  },
                  afterConfirmAction: () async {
                    connectionsProvider!.getSentConnectionRequests(
                      isInitial: true,
                    );
                  },
                  errorDialogAction: () async {
                    Navigator.pop(context);
                  },
                  confirmDialog: false,
                  errorTitle: "Couldn't withdraw request",
                  errorMessage: "Unable to withdraw request. Please try again.",
                  errorButtonText: "Cancel",
                )
              else if (cardType == PageType.following)
                ConfirmableActionButton(
                  buttonText: "Following",
                  confirmAction: () => networksProvider!.unfollowUser(userId),
                  conrifmDialogCancelAction: () async {
                    Navigator.pop(context);
                  },
                  afterConfirmAction: () async {
                    networksProvider!.getFollowingList(isInitial: true);
                  },
                  errorDialogAction: () async {
                    Navigator.pop(context);
                  },
                  confirmTitle: "Unfollow $firstName $lastName?",
                  confirmMessage:
                      "Are you sure you want to unfollow $firstName $lastName?",
                  confirmButtonText: "Unfollow",
                  cancelButtonText: "Cancel",
                  errorTitle: "Couldn't unfollow $firstName $lastName",
                  errorMessage:
                      "Unable to unfollow $firstName $lastName. Please try again.",
                  errorButtonText: "Cancel",
                )
              else if (cardType == PageType.followers)
                SizedBox()
              ///FIXME: still don't know what to do here
              else if (cardType == PageType.blocked) //DONEEEEEEEEEEEEEEEEEEE
                ConfirmableActionButton(
                  buttonText: "Unblock",
                  confirmAction: () => networksProvider!.unblockUser(userId),
                  conrifmDialogCancelAction: () async {
                    Navigator.pop(context);
                  },
                  afterConfirmAction: () async {
                    networksProvider!.getBlockedList(isInitial: true);
                  },
                  errorDialogAction: () async {
                    Navigator.pop(context);
                  },
                  confirmTitle: "Unblock $firstName $lastName?",
                  confirmMessage:
                      "Are you sure you want to unblock $firstName $lastName?",
                  confirmButtonText: "Unblock",
                  cancelButtonText: "Cancel",
                  errorTitle: "Couldn't unblock $firstName $lastName",
                  errorMessage:
                      "Unable to unblock $firstName $lastName. Please try again.",
                  errorButtonText: "Cancel",
                )
              else if (cardType ==
                  PageType.connections) //DONEEEEEEEEEEEEEEEEEEEEEE
                ConnectionsListActions(
                  userId: userId,
                  connectionsProvider: connectionsProvider!,
                  firstName: firstName,
                  lastName: lastName,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToProfile(BuildContext context) {
    GoRouter.of(context).go(RouteNames.profile);
  }
}
