import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/manage_my_network_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/routing_functions.dart';

class ManageMyNetworkBody extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onSecondary,
      borderRadius: BorderRadius.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          children: [
            ///Connecitons
            ManageMyNetworkCard(
              title: 'Connections',
              icon: Icons.people_alt_rounded,
              onTap: () {
                goToConnections(context);
              },
              count:
                  -1, //connectionsProvider?.getConnectionsCount() as int? ?? 0,
            ),

            ///Followings
            ManageMyNetworkCard(
              title: 'People I follow',
              icon: Icons.person_2_rounded,
              onTap: () {
                goToFollowing(context);
              },
              count: -1, //networksProvider?.getFollowingsCount() as int? ?? 0,
            ),

            ///Followers
            ManageMyNetworkCard(
              title: 'Followers',
              icon: Icons.person_2_outlined,
              onTap: () {
                goToFollowers(context);
              },
              count: -1, //networksProvider?.getFollowersCount() as int? ?? 0,
            ),
            //pages
            ManageMyNetworkCard(
              title: 'Pages',
              icon: Icons.apartment,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pages feature is under development')),
                );
              },
              count: -1, //TODO: Add logic to get pages count
            ),
          ],
        ),
      ),
    );
  }
}
