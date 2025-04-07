import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/received_invitations_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/sent_invitations_body.dart';
import 'package:provider/provider.dart';
import '../provider/connections_provider.dart'; // Ensure this is the correct path

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
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Invitations',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  // Settings action if needed
                },
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
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
                tabs: const [Tab(text: 'Received'), Tab(text: 'Sent')],
                dividerColor: Theme.of(context).dividerColor,
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [ReceivedInvitationsBody(), SentInvitationsBody()],
        ),
      ),
    );
  }
}
