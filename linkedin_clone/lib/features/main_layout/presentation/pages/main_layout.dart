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
import 'package:linkedin_clone/features/messaging/presentation/pages/conversation_list_page.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/conversation_list_provider.dart';
import 'package:linkedin_clone/features/notifications/domain/entities/notifications.dart';
import 'package:linkedin_clone/features/notifications/presentation/pages/notifications_list.dart';
import 'package:linkedin_clone/features/notifications/presentation/provider/notifications_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/token_service.dart';
import 'package:linkedin_clone/features/jobs/presentation/pages/jobs_search_page.dart';
import '../../../profile/presentation/provider/profile_provider.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  String? _userId;
  bool _loadingId = true;
  String? _profileName;

  final List<Widget> _pages = [
    FeedPage(), // Will be replaced by News Feed module
    MyNetworkPage(), // Will be replaced by Connections module
    CompaniesListScreen(),
    JobSearchPage(),
    NotificationsListPage(),
    
    SettingsPage(), // Will be replaced by Settings module
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = Provider.of<ProfileProvider>(context, listen: false);
      profile.fetchProfile("").then((_) {
        setState(() {
          _profileName = profile.fullName;
        });
      });
    });
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
    print("🔁 Attempting to push to /savedPosts with:");
    print("🔹 userId: $_userId");
    print("🔹 profileName: $_profileName");
    Navigator.pop(context); // close drawer
    context.push(
      RouteNames.savedPosts,
      extra: {'userId': _userId, 'profileName': _profileName},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final messagingProvider = Provider.of<ConversationListProvider>(
      context,
      listen: false,
    );
    final notificationsProvider = Provider.of<NotificationsProvider>(context);

    return Scaffold(
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
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              messagingProvider.fetchConversations();
              print("Conversations gayat: ${messagingProvider.conversations.length}");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConversationListPage()),
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.unselectedWidgetColor,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "My Network",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: "Companies",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                if (notificationsProvider.unseenNotificationsCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(minWidth: 12, minHeight: 12),
                      child:
                          notificationsProvider.unseenNotificationsCount > 9
                              ? Text(
                                '9+',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              )
                              : Text(
                                '${notificationsProvider.unseenNotificationsCount}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                    ),
                  ),
              ],
            ),
            label: "Notifications",
            activeIcon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (notificationsProvider.unseenNotificationsCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(minWidth: 12, minHeight: 12),
                      child:
                          notificationsProvider.unseenNotificationsCount > 9
                              ? Text(
                                '9+',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              )
                              : Text(
                                '${notificationsProvider.unseenNotificationsCount}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                    ),
                  ),
              ],
            ),
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
