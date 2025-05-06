import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/label_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/my_network_invitations_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/people_you_may_know_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/routing_functions.dart';

class GrowBody extends StatefulWidget {
  const GrowBody({super.key});

  @override
  State<GrowBody> createState() => _GrowBodyState();
}

class _GrowBodyState extends State<GrowBody> {
  final ScrollController _scrollController = ScrollController();
  NetworksProvider? networksProvider;
  ConnectionsProvider? connectionsProvider;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (networksProvider != null && !networksProvider!.isBusy) {
          networksProvider!.getPeopleYouMayKnowList();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworksProvider>(
      key: const Key('key_growbody_networks_consumer'),
      builder: (context, networksProvider, _) {
        this.networksProvider = networksProvider;
        return Consumer<ConnectionsProvider>(
          key: const Key('key_growbody_connections_consumer'),
          builder: (context, connectionsProvider, _) {
            this.connectionsProvider = connectionsProvider;
            return RefreshIndicator(
              key: const Key('key_growbody_refresh_indicator'),
              onRefresh: () async {
                await connectionsProvider.getInvitations(
                  isInitsent: true,
                  isInitRec: true,
                  refreshRec: true,
                  refreshSent: true,
                );
                await networksProvider.getPeopleYouMayKnowList(isInitial: true);
              },
              color: Theme.of(context).primaryColor,
              child: SingleChildScrollView(
                key: const Key('key_growbody_scrollview'),
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  key: const Key('key_growbody_main_column'),
                  children: [
                    MyNetworksInvitationsCard(
                      key: const Key('key_growbody_invitations_card'),
                    ),
                    const SizedBox(
                      key: Key('key_growbody_spacer_1'),
                      height: 10,
                    ),
                    LabelCard(
                      key: const Key('key_growbody_manage_network_card'),
                      label: "Manage my network",
                      onTap: () => goToManageMyNetwork(context),
                    ),
                    const SizedBox(
                      key: Key('key_growbody_spacer_2'),
                      height: 10,
                    ),
                    PeopleYouMayKnowBody(
                      key: const Key('key_growbody_people_you_may_know'),
                      scrollController: _scrollController,
                    ),
                    if (networksProvider.isBusy)
                      const Padding(
                        key: Key('key_growbody_loading_container'),
                        padding: EdgeInsets.all(16),
                        child: Center(
                          key: Key('key_growbody_loading_center'),
                          child: CircularProgressIndicator(
                            key: Key('key_growbody_loading_indicator'),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
