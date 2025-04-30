import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/manage_my_network_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/routing_functions.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.zero,
      child: Column(
        children: [
          /// Connections
          ManageMyNetworkCard(
            title: 'Connections',
            icon: Icons.people_alt_rounded,
            onTap: () {
              goToConnections(context);
            },
            count:
                widget.connectionsProvider?.getConnectionsCount() as int? ?? 0,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).dividerColor,
          ),

          /// Followings
          ManageMyNetworkCard(
            title: 'People I follow',
            icon: Icons.person_2_rounded,
            onTap: () {
              goToFollowing(context);
            },
            count: widget.networksProvider?.getFollowingsCount() as int? ?? 0,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).dividerColor,
          ),

          /// Followers
          ManageMyNetworkCard(
            title: 'Followers',
            icon: Icons.person_2_outlined,
            onTap: () {
              goToFollowers(context);
            },
            count: widget.networksProvider?.getFollowersCount() as int? ?? 0,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }
}
