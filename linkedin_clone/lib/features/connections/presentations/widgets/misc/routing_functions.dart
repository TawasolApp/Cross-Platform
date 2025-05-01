import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart'
    show RouteNames;

void goToInvitations(BuildContext context) {
  GoRouter.of(context).push(RouteNames.invitations);
}

void goToProfile(BuildContext context, {String? userId}) {
  if (userId != null && userId.isNotEmpty) {
    // Pass userId as extra parameter to match router configuration
    GoRouter.of(context).push(RouteNames.profile, extra: userId);
  } else {
    // If no userId provided, navigate to the user's own profile
    GoRouter.of(context).push(RouteNames.profile);
  }
}

void goToConnections(BuildContext context, {String? userId}) {
  GoRouter.of(context).push(RouteNames.connections, extra: {'userId': userId});
}

void goToFollowers(BuildContext context) {
  GoRouter.of(context).push(RouteNames.followers);
}

void goToFollowing(BuildContext context) {
  GoRouter.of(context).push(RouteNames.following);
}

void goToManageMyNetwork(BuildContext context) {
  GoRouter.of(context).push(RouteNames.manageMyNetwrok);
}

void goToGeneralSeachPage(BuildContext context) {
  GoRouter.of(context).push(RouteNames.generalSearch);
}
