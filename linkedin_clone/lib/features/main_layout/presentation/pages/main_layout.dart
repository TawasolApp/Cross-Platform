import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/company/presentation/screens/companies_list_screen.dart';
import 'package:linkedin_clone/features/company/presentation/screens/company_profile_screen.dart';
import 'package:linkedin_clone/features/connections/presentations/pages/invitations_page.dart';
import 'package:linkedin_clone/features/connections/presentations/pages/list_page.dart';
import 'package:linkedin_clone/features/connections/presentations/pages/my_network_page.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/page_type_enum.dart';
import 'package:linkedin_clone/features/feed/presentation/pages/feed_page.dart';
import 'package:linkedin_clone/features/main_layout/presentation/pages/settings.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/presentation/pages/notifications_list.dart';
import '../../../../core/services/token_service.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  String? _userId;
  bool _loadingId = true;

  final List<Widget> _pages = [
    FeedPage(), // Will be replaced by News Feed module
    MyNetworkPage(), // Will be replaced by Connections module
    // Will be replaced by Jobs module and company accessed through jobs and news feed in next phases
    CompaniesListScreen(),
    NotificationsListPage(),
    SettingsPage(), // Will be replaced by Settings module
  ];

  @override
  void initState() {
    super.initState();
    _loadCompanyId();
  }

  Future<void> _loadCompanyId() async {
    final isCompany = await TokenService.getIsCompany();
    final id =
        isCompany == true
            ? await TokenService.getCompanyId()
            : await TokenService.getUserId();

    setState(() {
      _userId = id;
      _loadingId = false;
    });

    print("🔐 Loaded ID for saved posts: $_userId");
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _goToProfile() {
    // Navigate to user profile

    context.go(
      RouteNames.profile,
    ); // Define this route in GoRouter or Navigator
  }

  void _goToSavedPosts() {
    if (_userId == null) return;

    Navigator.pop(context); // close drawer
    context.push(RouteNames.savedPosts, extra: _userId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: null,
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _goToProfile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage(
                      'assets/images/profile_placeholder.png',
                    ), // Replace with user image
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Omar Kaddah\nEx-SWE Intern @Dell",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Giza, Egypt",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            ListTile(
              title: Text(
                "Puzzle games",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Saved posts",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onTap: _loadingId ? null : _goToSavedPosts,
            ),
            ListTile(
              title: Text(
                "Groups",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            const Divider(height: 32),
            ListTile(
              leading: const Icon(Icons.workspace_premium_outlined),
              title: Text(
                "Try Premium for EGP0",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(
                "Settings",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(3);
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.unselectedWidgetColor,
        backgroundColor: theme.scaffoldBackgroundColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "My Network",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        iconSize: 24,
        showUnselectedLabels: true,
        enableFeedback: true,
        // Allow labels to take more space
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
      ),
    );
  }
}
