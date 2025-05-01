import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/grow_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/page_type_enum.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/search_bar.dart'
    as search_bar;
import 'package:linkedin_clone/features/connections/presentations/widgets/user_avatar.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/routing_functions.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileProvider = Provider.of<ProfileProvider>(context, listen: false);
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
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          elevation: 0,
          title: const search_bar.SearchBar(),
          leading: InkWell(
            onTap: () {
              goToProfile(context, userId: "");
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Messages feature is not implemented yet.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
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
