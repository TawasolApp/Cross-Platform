import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart'
    show RouteNames;
import 'package:linkedin_clone/features/messaging/presentation/pages/conversation_list_page.dart';

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

void goToBlocked(BuildContext context) {
  GoRouter.of(context).push(RouteNames.blockedUsers);
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

void goToPremiumSurvey(BuildContext context) {
  GoRouter.of(context).push(RouteNames.premiumSurvey);
}

void goToReportUser(BuildContext context, {String? userId}) {
  GoRouter.of(context).push(RouteNames.reportUser, extra: {'userId': userId});
}

void goToReportPost(BuildContext context, {String? postId}) {
  GoRouter.of(context).push(RouteNames.reportPost, extra: {'postId': postId});
}
