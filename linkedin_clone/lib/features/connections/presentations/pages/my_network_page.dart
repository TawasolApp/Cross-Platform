import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/grow_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/enums.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/search_bar.dart'
    as search_bar;
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/user_avatar.dart';
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
  String? myProfilePircture;
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
      profileProvider!.fetchProfile("");
      myProfilePircture = profileProvider!.profilePicture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              GestureDetector(
                onTap: () => goToProfile(context, userId: ""),
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Giza, Egypt",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),
              ListTile(
                title: Text(
                  "Puzzle games",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ListTile(
                title: Text(
                  "Saved posts",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                // onTap: _loadingId ? null : _goToSavedPosts,
              ),
              ListTile(
                title: Text(
                  "Groups",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Divider(height: 32),
              ListTile(
                leading: const Icon(Icons.workspace_premium_outlined),
                title: Text(
                  "Try Premium for EGP0",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text(
                  "Settings",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // _onItemTapped(3);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          elevation: 0,
          title: const search_bar.SearchBar(),
          leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Consumer<ProfileProvider>(
              builder:
                  (context, profileProvider, child) => UserAvatar(
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
                icon: Icon(
                  Icons.message_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  //TODO: messaging provider
                  goToMessages(context);
                },
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: const Color.fromARGB(255, 43, 109, 46),
                labelColor: const Color.fromARGB(255, 43, 109, 46),
                unselectedLabelColor:
                    Theme.of(context).textTheme.bodyMedium?.color,
                tabs: const [Tab(text: 'Grow')],
                dividerColor: Theme.of(context).dividerColor,
              ),
            ),
          ),
        ),
        body: TabBarView(children: [GrowBody()]),
      ),
    );
  }
}
