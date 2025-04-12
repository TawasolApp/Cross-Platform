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
import 'package:linkedin_clone/features/company/presentation/screens/companies_list_screen.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_profile_screen.dart';
import 'package:linkedin_clone/features/connections/presentations/pages/list_page.dart';
import 'package:linkedin_clone/features/feed/presentation/pages/create_post_page.dart';
import 'package:linkedin_clone/features/feed/presentation/pages/feed_page.dart';
import 'package:linkedin_clone/features/main_layout/presentation/pages/change_password.dart';
import 'package:linkedin_clone/features/main_layout/presentation/pages/delete_account.dart';
import 'package:linkedin_clone/features/main_layout/presentation/pages/main_layout.dart';
import 'package:linkedin_clone/features/main_layout/presentation/pages/signin_security.dart';
import 'package:linkedin_clone/features/main_layout/presentation/pages/update_email.dart';
import 'package:linkedin_clone/features/main_layout/presentation/pages/update_info.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/user_profile.dart';
import '../../features/authentication/presentation/pages/onboarding_page.dart';
import 'package:linkedin_clone/features/feed/presentation/pages/post_detail_page.dart';
import '../../features/main_layout/presentation/pages/settings.dart';
import 'package:linkedin_clone/features/connections/presentations/pages/invitations_page.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/page_type_enum.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.onboarding, // Start at onboarding

    routes: [
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => OnboardingPage(),
      ),
      GoRoute(path: RouteNames.login, builder: (context, state) => LoginPage()),
      GoRoute(path: RouteNames.home, builder: (context, state) => HomePage()),
      GoRoute(
        path: RouteNames.addName,
        builder: (context, state) => AddNamePage(),
      ),
      GoRoute(
        path: RouteNames.addEmail,
        builder: (context, state) => AddEmailPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.verifyEmail,
        builder: (context, state) => EmailVerificationPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => ForgotPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.checkemail,
        builder: (context, state) => ForgotPasswordCheckEmailPage(),
      ),
      GoRoute(
        path: RouteNames.main,
        builder: (context, state) => MainNavigationPage(),
      ),
      GoRoute(
        path: RouteNames.createPost,
        builder: (context, state) => PostCreationPage(),
      ),
      GoRoute(path: RouteNames.feed, builder: (context, state) => FeedPage()),
      GoRoute(
        path: RouteNames.companyPage,
        builder: (context, state) => CompaniesListScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => UserProfile(),
      ),
      GoRoute(path: RouteNames.home, builder: (context, state) => HomePage()),
      GoRoute(
        path: RouteNames.addName,
        builder: (context, state) => AddNamePage(),
      ),
      GoRoute(
        path: RouteNames.addEmail,
        builder: (context, state) => AddEmailPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.verifyEmail,
        builder: (context, state) => EmailVerificationPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => ForgotPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.checkemail,
        builder: (context, state) => ForgotPasswordCheckEmailPage(),
      ),
      GoRoute(
        path: RouteNames.main,
        builder: (context, state) => MainNavigationPage(),
      ),
      GoRoute(
        path: RouteNames.createPost,
        builder: (context, state) => PostCreationPage(),
      ),
      GoRoute(path: RouteNames.feed, builder: (context, state) => FeedPage()),
      GoRoute(
        path: RouteNames.companyPage,
        builder:
            (context, state) => CompanyProfileScreen(
              companyId: "elsewedy-electric",
              title: "Test",
            ),
      ),
      // GoRoute(
      //   path: RouteNames.profile,
      //   builder: (context, state) {
      //     final userId = state.extra as String;
      //     return UserProfile(userId);
      //   },
      // ),
      GoRoute(path: RouteNames.home, builder: (context, state) => HomePage()),
      GoRoute(
        path: RouteNames.addName,
        builder: (context, state) => AddNamePage(),
      ),
      GoRoute(
        path: RouteNames.addEmail,
        builder: (context, state) => AddEmailPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.verifyEmail,
        builder: (context, state) => EmailVerificationPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => ForgotPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.checkemail,
        builder: (context, state) => ForgotPasswordCheckEmailPage(),
      ),
      GoRoute(
        path: RouteNames.main,
        builder: (context, state) => MainNavigationPage(),
      ),
      GoRoute(
        path: RouteNames.createPost,
        builder: (context, state) => PostCreationPage(),
      ),
      GoRoute(path: RouteNames.feed, builder: (context, state) => FeedPage()),
      GoRoute(
        path: RouteNames.companyPage,
        builder: (context, state) => CompaniesListScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => UserProfile(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => SettingsPage(),
      ),
      GoRoute(
        path: RouteNames.deleteAccount,
        builder:
            (context, state) => DeleteAccountPage(
              userName: "Omar Kaddah",
              connectionName: "Shikabala",
              connectionRole: "Greatest of all time",
              connectionCount: 100,
            ),
      ),
      GoRoute(
        path: RouteNames.signInAndSecurity,
        builder: (context, state) => SignInSecurityPage(),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        builder: (context, state) => ChangePasswordPage(),
      ),
      GoRoute(
        path: RouteNames.updateEmail,
        builder: (context, state) => UpdateEmailPage(),
      ),
      GoRoute(
        path: RouteNames.updateInfo,
        builder: (context, state) => UpdateInfoPage(),
      ),
      GoRoute(
        path: RouteNames.postDetails,
        builder: (context, state) {
          final postId = state.extra as String;
          return PostDetailsPage(postId: postId);
        },
      ),
      GoRoute(
        path: RouteNames.connections,
        builder: (context, state) => ListPage(type: PageType.connections),
      ),
      GoRoute(
        path: RouteNames.followers,
        builder: (context, state) => ListPage(type: PageType.followers),
      ),
      GoRoute(
        path: RouteNames.following,
        builder: (context, state) => ListPage(type: PageType.following),
      ),
      GoRoute(
        path: RouteNames.invitations,
        builder: (context, state) => InvitationsPage(),
      ),
      GoRoute(
        path: RouteNames.manageMyNetwrok,
        builder: (context, state) => ListPage(type: PageType.manageMyNetwork),
      ),
    ],
  );
}
