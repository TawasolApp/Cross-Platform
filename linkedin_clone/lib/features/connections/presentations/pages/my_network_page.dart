import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/search_bar.dart'
    as search_bar;
import 'package:provider/provider.dart';
import '../provider/connections_provider.dart';

class MyNetworkPage extends StatefulWidget {
  const MyNetworkPage({super.key});

  @override
  State<MyNetworkPage> createState() => _MyNetworkPageState();
}

class _MyNetworkPageState extends State<MyNetworkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        title: const search_bar.SearchBar(),
        leading: Padding(
          padding: const EdgeInsets.only(
            top: 7.0,
            left: 15.0,
            right: 7.0,
            bottom: 7.0,
          ),
          child: GestureDetector(
            onTap: () {
              _goToProfile(context);
            },
            child: CircleAvatar(
              radius: 10,
              backgroundImage: const NetworkImage(
                'https://x.com/lastvibes/status/1909289321854910679/photo/1',
              ), //TODO: akhod el pfp mn 3nd Aya
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
                  SnackBar(
                    content: const Text(
                      'Messages feature is not implemented yet.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Consumer<ConnectionsProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Invitations ${provider.receivedConnectionRequestsList!.length}",
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1.0,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

void _goToProfile(BuildContext context) {
  // Navigate to user profile
  GoRouter.of(
    context,
  ).go(RouteNames.profile); // Ensure RouteNames.profile is defined
}
