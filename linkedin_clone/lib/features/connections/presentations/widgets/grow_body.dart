import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/label_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/my_network_invitations_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/people_you_may_know_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/routing_functions.dart';

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

  Future<void> _onRefresh() async {}

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworksProvider>(
      builder: (context, networksProvider, _) {
        return RefreshIndicator(
          onRefresh: () async {
            await connectionsProvider?.getInvitations(
              isInitsent: true,
              isInitRec: true,
              refreshRec: true,
              refreshSent: true,
            );
            await networksProvider.getPeopleYouMayKnowList(isInitial: true);
          },
          color: Theme.of(context).primaryColor,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                MyNetworksInvitationsCard(),
                const SizedBox(height: 10),
                LabelCard(
                  label: "Manage my network",
                  onTap: () => goToManageMyNetwork(context),
                ),
                const SizedBox(height: 10),
                PeopleYouMayKnowBody(scrollController: _scrollController),
                if (networksProvider.isBusy)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
