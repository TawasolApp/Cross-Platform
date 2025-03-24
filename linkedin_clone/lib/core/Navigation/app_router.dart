// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/add_email_password_page.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/add_name_page.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/home_page.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/login_page.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/email_verification_page.dart.dart';
import '../../features/authentication/presentation/pages/onboarding_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.onboarding, // Start at onboarding

    routes: [
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => OnboardingPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: RouteNames.home,
         builder: (context, state) => HomePage(),
      ), 
      GoRoute(path: RouteNames.addName, builder: (context, state) => AddNamePage()),
      GoRoute(path: RouteNames.addEmail, builder: (context, state) => AddEmailPasswordPage()),
      GoRoute(path: RouteNames.verifyEmail, builder: (context, state) => EmailVerificationPage()),
      // GoRoute(
      //   path: RouteNames.register,
      //   builder: (context, state) => RegisterPage(),
      // ),
      // GoRoute(
      //   path: RouteNames.feed,
      //   builder: (context, state) => FeedPage(),
      // ),
      // GoRoute(
      //   path: RouteNames.profile,
      //   builder: (context, state) => ProfilePage(),
      // ),
    ],
  );
}
