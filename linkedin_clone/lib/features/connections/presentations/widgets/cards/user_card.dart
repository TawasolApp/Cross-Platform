// ignore_for_file: use_build_context_synchronously

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/buttons/cconfirmable_action_button.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/user_avatar.dart';
import 'package:linkedin_clone/features/privacy/presentations/provider/privacy_provider.dart';
import 'user_card_info.dart';
import '../pending_requests_actions.dart';
import '../connections_list_actions.dart';
import '../misc/connections_enums.dart';
import '../misc/routing_functions.dart';

class UserCard extends StatelessWidget {
  final String userId;
  final String firstName;
  final String lastName;
  String headLine;
  final String profilePicture;
  final bool isOnline;
  final String time;
  final PageType cardType;
  final ConnectionsProvider? connectionsProvider;
  final NetworksProvider? networksProvider;
  final PrivacyProvider? privacyProvider;

  UserCard({
    super.key,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.headLine = '',
    required this.profilePicture,
    this.isOnline = false,
    this.time = '',
    required this.cardType,
    this.connectionsProvider,
    this.networksProvider,
    this.privacyProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      key: Key('user_card_material_$userId'),
      color: Theme.of(context).colorScheme.onSecondary,
      borderRadius: BorderRadius.zero,
      child: Padding(
        key: Key('user_card_padding_$userId'),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          key: Key('user_card_inkwell_$userId'),
          onTap: () => goToProfile(context, userId: userId),
          borderRadius: BorderRadius.zero,
          child: Row(
            key: Key('user_card_main_row_$userId'),
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Profile image and online indicator
              UserAvatar(
                key: Key('user_card_avatar_$userId'),
                profilePicture: profilePicture,
                isOnline: isOnline,
                cardType: cardType,
              ),

              const SizedBox(key: Key('user_card_avatar_spacing'), width: 8),

              /// User info (name, headline, time)
              Flexible(
                key: Key('user_card_info_flexible_$userId'),
                fit: FlexFit.tight,
                child: UserCardInfo(
                  key: Key('user_card_info_$userId'),
                  firstName: firstName,
                  lastName: lastName,
                  headLine: headLine,
                  time: time,
                  cardType: cardType,
                ),
              ),

              /// Right-side action buttons
              Padding(
                key: Key('user_card_actions_padding_$userId'),
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  key: Key('user_card_actions_align_$userId'),
                  alignment: Alignment.centerRight,
                  child: _buildActions(context),
                ),
              ),
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
          key: Key('user_card_pending_actions_$userId'),
          userId: userId,
          connectionsProvider: connectionsProvider!,
        );
      case PageType.sent:
        return ConfirmableActionButton(
          key: Key('user_card_withdraw_button_$userId'),
          buttonText: "Withdraw",
          confirmAction:
              () => connectionsProvider!.withdrawConnectionRequest(userId),
          errorDialogAction: () async => Navigator.pop(context),
          confirmDialog: false,
          errorTitle: "Couldn't withdraw request",
          errorMessage: "Unable to withdraw request. Please try again.",
          errorButtonText: "Cancel",
        );
      case PageType.following:
        return ConfirmableActionButton(
          key: Key('user_card_following_button_$userId'),
          buttonText: "Following",
          confirmAction: () => networksProvider!.unfollowUser(userId),
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
      case PageType.followers || PageType.search || PageType.others:
        return const SizedBox(
          key: Key('user_card_no_actions_spacer'),
        ); // No action yet
      case PageType.blocked:
        return ConfirmableActionButton(
          key: Key('user_card_unblock_button_$userId'),
          buttonText: "Unblock",
          confirmAction: () => privacyProvider!.unblockUser(userId),
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
          key: Key('user_card_connections_actions_$userId'),
          userId: userId,
          connectionsProvider: connectionsProvider!,
          firstName: firstName,
          lastName: lastName,
        );
      default:
        return const SizedBox(
          key: Key('user_card_default_no_actions'),
        ); // No action yet
    }
  }
}
