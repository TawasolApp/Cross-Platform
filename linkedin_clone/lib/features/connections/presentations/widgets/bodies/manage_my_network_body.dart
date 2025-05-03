import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/manage_my_network_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/routing_functions.dart';
import 'package:provider/provider.dart';

class ManageMyNetworkBody extends StatefulWidget {
  final ConnectionsProvider? connectionsProvider;
  final NetworksProvider? networksProvider;
  final String? userId;

  const ManageMyNetworkBody({
    super.key,
    this.connectionsProvider,
    this.networksProvider,
    this.userId,
  });

  @override
  State<ManageMyNetworkBody> createState() => _ManageMyNetworkBodyState();
}

class _ManageMyNetworkBodyState extends State<ManageMyNetworkBody> {
  @override
  void initState() {
    super.initState();

    widget.networksProvider?.getFollowingsCount();
    widget.networksProvider?.getFollowersCount();
    widget.connectionsProvider?.getConnectionsCount("");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: const Key('key_managenetwork_container'),
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.zero,
      child: Column(
        key: const Key('key_managenetwork_main_column'),
        children: [
          /// Connections
          Consumer<ConnectionsProvider>(
            key: const Key('key_managenetwork_connections_consumer'),
            builder: (context, provider, child) {
              return ManageMyNetworkCard(
                key: const Key('key_managenetwork_connections_card'),
                title: 'Connections',
                icon: Icons.people_alt_rounded,
                onTap: () {
                  goToConnections(context);
                },
                count:
                    provider.connectionsCount != null
                        ? provider.connectionsCount.toString()
                        : '',
              );
            },
          ),

          Divider(
            key: const Key('key_managenetwork_divider_1'),
            height: 1,
            thickness: 1,
            color: Theme.of(context).dividerColor,
          ),

          /// Followings
          Consumer<NetworksProvider>(
            key: const Key('key_managenetwork_following_consumer'),
            builder: (context, provider, child) {
              return ManageMyNetworkCard(
                key: const Key('key_managenetwork_following_card'),
                title: 'People I follow',
                icon: Icons.person_2_rounded,
                onTap: () {
                  goToFollowing(context);
                },
                count:
                    provider.followingsCount != null
                        ? provider.followingsCount.toString()
                        : '',
              );
            },
          ),

          Divider(
            key: const Key('key_managenetwork_divider_2'),
            height: 1,
            thickness: 1,
            color: Theme.of(context).dividerColor,
          ),

          /// Followers
          Consumer<NetworksProvider>(
            key: const Key('key_managenetwork_followers_consumer'),
            builder: (context, provider, child) {
              return ManageMyNetworkCard(
                key: const Key('key_managenetwork_followers_card'),
                title: 'Followers',
                icon: Icons.person_2_outlined,
                onTap: () {
                  goToFollowers(context);
                },
                count:
                    provider.followersCount != null
                        ? provider.followersCount.toString()
                        : '',
              );
            },
          ),

          Divider(
            key: const Key('key_managenetwork_divider_3'),
            height: 1,
            thickness: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }
}
