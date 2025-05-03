import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/bodies/invitations_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:provider/provider.dart';
import '../provider/connections_provider.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});

  @override
  State<InvitationsPage> createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  @override
  void initState() {
    super.initState();
    final connectionsProvider = Provider.of<ConnectionsProvider>(
      context,
      listen: false,
    );
    connectionsProvider.getInvitations(
      isInitsent: true,
      isInitRec: true,
      refreshRec: true,
      refreshSent: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectionsProvider = Provider.of<ConnectionsProvider>(context);

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        key: const ValueKey('invitations_page_scaffold'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          key: const ValueKey('invitations_app_bar'),
          title: Text(
            key: const ValueKey('invitations_title_text'),
            'Invitations',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          leading: IconButton(
            key: const ValueKey('invitations_back_button'),
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Container(
              key: const ValueKey('invitations_tab_bar_container'),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TabBar(
                key: const ValueKey('invitations_tab_bar'),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: const Color.fromARGB(255, 43, 109, 46),
                labelColor: const Color.fromARGB(255, 43, 109, 46),
                unselectedLabelColor:
                    Theme.of(context).textTheme.bodyMedium?.color,
                tabs: const [
                  Tab(
                    key: ValueKey('received_invitations_tab'),
                    text: 'Received',
                  ),
                  Tab(key: ValueKey('sent_invitations_tab'), text: 'Sent'),
                ],
                dividerColor: Theme.of(context).dividerColor,
              ),
            ),
          ),
        ),
        body: TabBarView(
          key: const ValueKey('invitations_tab_view'),
          children: [
            InvitationsBody(
              key: const ValueKey('received_invitations_body'),
              cardType: PageType.pending,
              connectionsProvider: connectionsProvider,
            ),
            InvitationsBody(
              key: const ValueKey('sent_invitations_body'),
              cardType: PageType.sent,
              connectionsProvider: connectionsProvider,
            ),
          ],
        ),
      ),
    );
  }
}
