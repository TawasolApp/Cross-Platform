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
import 'package:linkedin_clone/features/connections/presentations/widgets/manage_my_network_body.dart';
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
import 'package:linkedin_clone/features/notifications/presentation/pages/notifications_list.dart';
import 'package:linkedin_clone/features/feed/presentation/pages/reactions_page.dart';
import 'package:linkedin_clone/features/admin_panel/presentation/pages/reports_page.dart';
import 'package:linkedin_clone/features/admin_panel/presentation/pages/job_listings_page.dart';
import 'package:linkedin_clone/features/admin_panel/presentation/pages/analytics_page.dart';
import 'package:linkedin_clone/features/feed/presentation/pages/saved_posts_page.dart';
import 'package:linkedin_clone/features/admin_panel/presentation/pages/admin_panel_page.dart';
import 'package:linkedin_clone/features/feed/presentation/pages/reposts_page.dart';

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
        path: RouteNames.savedPosts,
        name: 'savedPosts',
        builder: (context, state) {
          final extraData = state.extra as Map<String, String?>; // 👈
          final userId = extraData['userId']!;
          final profileName = extraData['profileName']!;
          return SavedPostsPage(userId: userId, profileName: profileName);
        },
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

      GoRoute(path: RouteNames.feed, builder: (context, state) => FeedPage()),

      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) {
          // Extract userId from state.extra if available
          // state.extra can be a String (for direct user profiles) or a Map (for nested navigation)
          String? userId;
          if (state.extra != null) {
            if (state.extra is String) {
              userId = state.extra as String;
            } else if (state.extra is Map) {
              userId =
                  (state.extra as Map<String, dynamic>)['userId'] as String?;
            }
          }
          return UserProfile(userId: userId);
        },
      ),
      GoRoute(
        path: RouteNames.addName,
        builder: (context, state) => AddNamePage(),
      ),

      GoRoute(
        path: RouteNames.createPost,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          //final userId = state.extra as String;
          final userId = extra?['userId'] as String?;
          return PostCreationPage(
            parentPostId: extra?['parentPostId'] as String?,
            isSilentRepost: extra?['isSilentRepost'] as bool? ?? false,
          );
        },
      ),
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
        builder: (context, state) {
          final extras = state.extra as Map<String, String?>;
          final userId = extras['userId'];
          return ListPage(type: PageType.connections, userId: userId);
        },
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
      GoRoute(
        path: RouteNames.reactions,
        builder: (context, state) {
          final postId = state.extra as String;
          final userId = state.extra as String;
          return ReactionsPage(postId: postId);
        },
      ),
      GoRoute(
        path: RouteNames.adminReports,
        builder: (context, state) => const ReportsPage(),
      ),
      GoRoute(
        path: RouteNames.adminJobs,
        builder: (context, state) => const JobListingsPage(),
      ),
      GoRoute(
        path: RouteNames.adminAnalytics,
        builder: (context, state) => const AnalyticsPage(),
      ),
      GoRoute(
        path: RouteNames.notifications,
        builder: (context, state) => const NotificationsListPage(),
      ),
      GoRoute(
        path: RouteNames.adminPanel,
        builder: (context, state) => const AdminPanelPage(),
      ),
      GoRoute(
        path: RouteNames.repostPage,
        builder: (context, state) {
          final postId = state.extra as String;
          return RepostsPage(postId: postId);
        },
      ),
      GoRoute(
        path: RouteNames.companyProfile,
        builder: (context, state) {
          final data = state.extra as Map<String, String>;
          return CompanyProfileScreen(
            companyId: data['companyId']!,
            title: data['companyTitle']!,
          );
        },
      ),
    ],
  );
}
