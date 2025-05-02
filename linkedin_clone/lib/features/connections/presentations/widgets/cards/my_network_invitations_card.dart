import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin_clone/core/Navigation/route_names.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/label_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/user_card.dart';
import 'package:provider/provider.dart';
import '../misc/routing_functions.dart';

class MyNetworksInvitationsCard extends StatefulWidget {
  // ignore: use_super_parameters
  const MyNetworksInvitationsCard({Key? key}) : super(key: key);

  @override
  State<MyNetworksInvitationsCard> createState() =>
      _MyNetworksInvitationsCardState();
}

class _MyNetworksInvitationsCardState extends State<MyNetworksInvitationsCard> {
  ConnectionsProvider? connectionsProvider;
  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback((_) {
    connectionsProvider = Provider.of<ConnectionsProvider>(
      context,
      listen: false,
    );
    connectionsProvider!.getInvitations(
      isInitsent: true,
      isInitRec: true,
      refreshRec: true,
      refreshSent: true,
    );
    connectionsProvider!.getReceivedConnectionRequestsCount();
    //   });
  }

  @override
  Widget build(BuildContext context) {
    final connectionsProvider = Provider.of<ConnectionsProvider>(context);

    return Container(
      color: Theme.of(context).colorScheme.onSecondary,
      child: Consumer<ConnectionsProvider>(
        builder: (context, provider, _) {
          final list =
              connectionsProvider.receivedRequestsCount >= 2
                  ? connectionsProvider.receivedConnectionRequestsList!.sublist(
                    0,
                    2,
                  )
                  : connectionsProvider.receivedRequestsCount == 1
                  ? [connectionsProvider.receivedConnectionRequestsList![0]]
                  : [];
          return Column(
            children: [
              LabelCard(
                label:
                    connectionsProvider.receivedRequestsCount > 0
                        ? "Invitations (${connectionsProvider.receivedRequestsCount})"
                        : "Invitations",
                onTap: () {
                  goToInvitations(context);
                },
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor,
              ),
              provider.receivedRequestsCount > 0
                  ? ListView.builder(
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final user = list[index];

                      return Column(
                        children: [
                          UserCard(
                            userId: user.userId,
                            firstName: user.firstName,
                            lastName: user.lastName,
                            headLine: user.headLine,
                            profilePicture: user.profilePicture,
                            isOnline: false,
                            time: user.time,
                            cardType: PageType.connections,
                            connectionsProvider: connectionsProvider,
                          ),
                        ],
                      );
                    },
                  )
                  : const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}
