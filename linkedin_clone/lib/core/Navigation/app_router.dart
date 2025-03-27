// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/add_email_password_page.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/add_name_page.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/check_your_email_page.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/forgot_password_page.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/home_page.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/login_page.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Pages/email_verification_page.dart.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_profile_screen.dart';
import 'package:linkedin_clone/features/feed/presentation/pages/create_post_page.dart';
import 'package:linkedin_clone/features/feed/presentation/pages/feed_page.dart';
import 'package:linkedin_clone/features/main_layout/presentation/pages/main_layout.dart';
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
      GoRoute(path: RouteNames.forgotPassword, builder: (context, state) => ForgotPasswordPage()),
      GoRoute(path: RouteNames.checkemail, builder: (context, state) => ForgotPasswordCheckEmailPage()),
      GoRoute(path: RouteNames.main, builder: (context, state) => MainNavigationPage()),
      GoRoute(path: RouteNames.createPost,builder: (context, state) => PostCreationPage() ),
      GoRoute(path: RouteNames.feed,builder: (context, state) => FeedPage()),
      GoRoute(path: RouteNames.companyPage,builder: (context, state) =>CompanyProfileScreen(companyId: "Company", title: "Test") ),

    ],
  );
}
