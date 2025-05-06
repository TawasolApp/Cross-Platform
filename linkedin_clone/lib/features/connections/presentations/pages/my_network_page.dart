import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/grow_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/search_bar.dart'
    as search_bar;
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/user_avatar.dart';
import 'package:linkedin_clone/features/messaging/presentation/pages/conversation_list_page.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/conversation_list_provider.dart';
import 'package:linkedin_clone/features/premium/presentations/provider/premium_provider.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/misc/routing_functions.dart';

class MyNetworkPage extends StatefulWidget {
  const MyNetworkPage({super.key});

  @override
  State<MyNetworkPage> createState() => _MyNetworkPageState();
}

class _MyNetworkPageState extends State<MyNetworkPage> {
  ProfileProvider? profileProvider;
  NetworksProvider? networksProvider;
  ConnectionsProvider? connectionsProvider;
  PremiumProvider? premiumProvider;
  bool? isPremium = false;
  String? myProfilePircture;
  ConversationListProvider? messagingProvider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      networksProvider = Provider.of<NetworksProvider>(context, listen: false);
      networksProvider = Provider.of<NetworksProvider>(context, listen: false);
      connectionsProvider = Provider.of<ConnectionsProvider>(
        context,
        listen: false,
      );
      premiumProvider = Provider.of<PremiumProvider>(context, listen: false);
      messagingProvider = Provider.of<ConversationListProvider>(
        context,
        listen: false,
      );
      profileProvider!.fetchProfile("");
      myProfilePircture = profileProvider!.profilePicture;
      isPremium = profileProvider!.isPremium;
      print("isPremium: $isPremium");
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          key: const ValueKey('network_drawer'),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              GestureDetector(
                key: const ValueKey('profile_drawer_header'),
                onTap: () => goToProfile(context, userId: ""),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      key: const ValueKey('drawer_profile_avatar'),
                      radius: 36,
                      backgroundImage: const AssetImage(
                        'assets/images/profile_placeholder.png',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      key: const ValueKey('drawer_profile_name'),
                      "Omar Kaddah\nEx-SWE Intern @Dell",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      key: const ValueKey('drawer_profile_location'),
                      "Giza, Egypt",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),
              ListTile(
                key: const ValueKey('puzzle_games_drawer_item'),
                title: Text(
                  "Puzzle games",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ListTile(
                key: const ValueKey('saved_posts_drawer_item'),
                title: Text(
                  "Saved posts",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ListTile(
                key: const ValueKey('groups_drawer_item'),
                title: Text(
                  "Groups",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Divider(height: 32),

              if (isPremium == false)
                ListTile(
                  key: const ValueKey('try_premium_drawer_item'),
                  leading: const Icon(Icons.workspace_premium_outlined),
                  title: TextButton(
                    key: const ValueKey('try_premium_button'),
                    child: Text(
                      "Try Premium for EGP0",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onPressed: () {
                      goToPremiumSurvey(context);
                    },
                  ),
                ),
              if (isPremium == true)
                ListTile(
                  key: const ValueKey('cancel_premium_drawer_item'),
                  leading: const Icon(Icons.workspace_premium_outlined),
                  title: Text(
                    "Cancel Premium Subscription",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () async {
                    bool result = await premiumProvider!.cancelSubscription();
                    if (result) {
                      setState(() {
                        isPremium = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          key: const ValueKey('premium_cancelled_snackbar'),
                          content: Text("Subscription cancelled successfully"),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          key: const ValueKey('premium_cancel_failed_snackbar'),
                          content: Text("Failed to cancel subscription"),
                        ),
                      );
                    }
                  },
                ),
              ListTile(
                key: const ValueKey('settings_drawer_item'),
                leading: const Icon(Icons.settings),
                title: Text(
                  "Settings",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          key: const ValueKey('my_network_app_bar'),
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          elevation: 0,
          title: const search_bar.SearchBar(
            key: ValueKey('network_search_bar'),
          ),
          leading: InkWell(
            key: const ValueKey('drawer_menu_button'),
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Consumer<ProfileProvider>(
              builder:
                  (context, profileProvider, child) => UserAvatar(
                    key: const ValueKey('app_bar_profile_avatar'),
                    profilePicture: myProfilePircture ?? 'not available',
                    isOnline: false,
                    cardType: PageType.manageMyNetwork,
                    avatarSize: MediaQuery.of(context).size.width * 0.1,
                  ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                key: const ValueKey('messages_button'),
                icon: Icon(
                  Icons.message_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  messagingProvider!.fetchConversations();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConversationListPage(),
                    ),
                  );
                },
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Container(
              key: const ValueKey('network_tab_bar_container'),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TabBar(
                key: const ValueKey('network_tab_bar'),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: const Color.fromARGB(255, 43, 109, 46),
                labelColor: const Color.fromARGB(255, 43, 109, 46),
                unselectedLabelColor:
                    Theme.of(context).textTheme.bodyMedium?.color,
                tabs: const [
                  Tab(key: ValueKey('grow_network_tab'), text: 'Grow'),
                ],
                dividerColor: Theme.of(context).dividerColor,
              ),
            ),
          ),
        ),
        body: TabBarView(
          key: const ValueKey('network_tab_view'),
          children: [GrowBody(key: const ValueKey('grow_network_body'))],
        ),
      ),
    );
  }
}
