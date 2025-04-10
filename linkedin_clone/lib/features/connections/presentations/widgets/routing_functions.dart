import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart'
    show RouteNames;

void goToInvitations(BuildContext context) {
  GoRouter.of(context).push(RouteNames.invitations);
}

void goToProfile(BuildContext context, {required String userId}) {
  GoRouter.of(context).push(RouteNames.profile, extra: {'userId': userId});
}

void goToConnections(BuildContext context) {
  GoRouter.of(context).push(RouteNames.connections);
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
