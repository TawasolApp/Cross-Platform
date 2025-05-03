import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/company/presentation/screens/companies_list_screen.dart';
import 'package:linkedin_clone/features/connections/presentations/pages/invitations_page.dart';
import 'package:linkedin_clone/features/connections/presentations/pages/list_page.dart';
import 'package:linkedin_clone/features/connections/presentations/pages/my_network_page.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:linkedin_clone/features/feed/presentation/pages/feed_page.dart';
import 'package:linkedin_clone/features/main_layout/presentation/pages/settings.dart';
import 'package:linkedin_clone/features/messaging/presentation/pages/chat_page.dart';
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
    FeedPage(key: const Key('feedPage')),
    MyNetworkPage(key: const Key('myNetworkPage')),
    CompaniesListScreen(key: const Key('companiesListPage')),
    JobSearchPage(key: const Key('jobSearchPage')),
    NotificationsListPage(key: const Key('notificationsListPage')),
    SettingsPage(key: const Key('settingsPage')),
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
    final id = isCompany == true
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
    context.go(RouteNames.profile);
  }

  void _goToChat(String conversationId) {
    final conversationProvider =
        Provider.of<ConversationListProvider>(context, listen: false);
    final conversation = conversationProvider.getConversationById(conversationId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          key: Key('chatPage_${conversation?.id ?? ''}'),
          conversationId: conversation?.id ?? '',
          receiverId: conversation?.otherParticipant?.id ?? '',
          userName:
              '${conversation?.otherParticipant?.firstName ?? ''} ${conversation?.otherParticipant?.lastName ?? ''}',
          profileImageUrl: conversation?.otherParticipant?.profilePicture ?? '',
        ),
      ),
    );
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
        key: const Key('mainDrawer'),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              key: const Key('profileDrawerItem'),
              onTap: _goToProfile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    key: Key('profileAvatar'),
                    radius: 36,
                    backgroundImage: AssetImage(
                      'assets/images/profile_placeholder.png',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Omar Kaddah\nEx-SWE Intern @Dell",
                    key: const Key('profileNameText'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Giza, Egypt",
                    key: const Key('profileLocationText'),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            ListTile(
              key: const Key('savedPostsDrawerItem'),
              title: Text(
                "Saved posts",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onTap: _loadingId ? null : _goToSavedPosts,
            ),
            ListTile(
              key: const Key('settingsDrawerItem'),
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
      appBar: _currentIndex == 1
          ? null
          : AppBar(
              actions: [
                IconButton(
                  key: const Key('searchButton'),
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Implement search functionality
                  },
                ),
                IconButton(
                  key: const Key('messagesButton'),
                  icon: const Icon(Icons.message),
                  onPressed: () {
                    messagingProvider.fetchConversations();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConversationListPage(
                          key: Key('conversationListPage'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        key: const Key('bottomNavigationBar'),
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.unselectedWidgetColor,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home, key: Key('homeNavIcon')),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people, key: Key('networkNavIcon')),
            label: "My Network",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.business, key: Key('companiesNavIcon')),
            label: "Companies",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.work, key: Key('jobsNavIcon')),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications_outlined, key: Key('notificationsNavIcon')),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings, key: Key('settingsNavIcon')),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
