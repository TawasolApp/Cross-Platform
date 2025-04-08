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
    return Material(
      color: Theme.of(context).colorScheme.onSecondary,
      borderRadius: BorderRadius.zero,
      child: Container(
        constraints: const BoxConstraints(minHeight: 80),
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () => _goToProfile(context),
          borderRadius: BorderRadius.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Profile image and online indicator
              UserAvatar(
                profilePicture: profilePicture,
                isOnline: isOnline,
                cardType: cardType,
              ),

              const SizedBox(width: 8),

              /// User info (name, headline, time)
              Expanded(
                child: UserCardInfo(
                  firstName: firstName,
                  lastName: lastName,
                  headLine: headLine,
                  time: time,
                  cardType: cardType,
                ),
              ),

              const SizedBox(width: 8),

              /// Right-side action buttons
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    switch (cardType) {
      case PageType.pending:
        return PendingRequestsActions(
          userId: userId,
          connectionsProvider: connectionsProvider!,
        );
      case PageType.sent:
        return ConfirmableActionButton(
          buttonText: "Withdraw",
          confirmAction:
              () => connectionsProvider!.withdrawConnectionRequest(userId),
          conrifmDialogCancelAction: () async => Navigator.pop(context),
          afterConfirmAction:
              () async => connectionsProvider!.getSentConnectionRequests(
                isInitial: true,
              ),
          errorDialogAction: () async => Navigator.pop(context),
          confirmDialog: false,
          errorTitle: "Couldn't withdraw request",
          errorMessage: "Unable to withdraw request. Please try again.",
          errorButtonText: "Cancel",
        );
      case PageType.following:
        return ConfirmableActionButton(
          buttonText: "Following",
          confirmAction: () => networksProvider!.unfollowUser(userId),
          conrifmDialogCancelAction: () async => Navigator.pop(context),
          afterConfirmAction:
              () async => networksProvider!.getFollowingList(isInitial: true),
          errorDialogAction: () async => Navigator.pop(context),
          confirmTitle: "Unfollow $firstName $lastName?",
          confirmMessage:
              "Are you sure you want to unfollow $firstName $lastName?",
          confirmButtonText: "Unfollow",
          cancelButtonText: "Cancel",
          errorTitle: "Couldn't unfollow $firstName $lastName",
          errorMessage:
              "Unable to unfollow $firstName $lastName. Please try again.",
          errorButtonText: "Cancel",
        );
      case PageType.followers:
        return const SizedBox(); // No action yet
      case PageType.blocked:
        return ConfirmableActionButton(
          buttonText: "Unblock",
          confirmAction: () => networksProvider!.unblockUser(userId),
          conrifmDialogCancelAction: () async => Navigator.pop(context),
          afterConfirmAction:
              () async => networksProvider!.getBlockedList(isInitial: true),
          errorDialogAction: () async => Navigator.pop(context),
          confirmTitle: "Unblock $firstName $lastName?",
          confirmMessage:
              "Are you sure you want to unblock $firstName $lastName?",
          confirmButtonText: "Unblock",
          cancelButtonText: "Cancel",
          errorTitle: "Couldn't unblock $firstName $lastName",
          errorMessage:
              "Unable to unblock $firstName $lastName. Please try again.",
          errorButtonText: "Cancel",
        );
      case PageType.connections:
        return ConnectionsListActions(
          userId: userId,
          connectionsProvider: connectionsProvider!,
          firstName: firstName,
          lastName: lastName,
        );
    }
  }

  void _goToProfile(BuildContext context) {
    GoRouter.of(context).go(RouteNames.profile);
  }
}
