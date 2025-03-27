import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/view_connections_appbar.dart';
import 'package:provider/provider.dart';
import '../widgets/view_connections_card.dart';
import '../../domain/entities/connections_list_user_entity.dart';
import '../provider/connections_provider.dart';

class ConnectionsPage extends StatelessWidget {
  final String token;
  const ConnectionsPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final connectionsListProvider = Provider.of<ConnectionsProvider>(
      context,
      listen: false,
    );
    connectionsListProvider.setToken(token);
    Future<List<ConnectionsListUserEntity>> connectionsList =
        connectionsListProvider.getConnections(token);

    return Scaffold(
      backgroundColor: Colors.white, // Directly setting background color

      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 0,
        toolbarHeight: 65.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Connections',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(42),
          child: Column(
            children: [
              const Divider(
                height: 1,
                thickness: 1,
                color: Color.fromARGB(255, 201, 201, 201),
              ),
              FutureBuilder<List<ConnectionsListUserEntity>>(
                future: connectionsList, // Fetching connections
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return ViewConnectionsAppBar(
                      connectionsCount:
                          !snapshot.hasData || snapshot.data!.isEmpty
                              ? snapshot.data!.length
                              : 0,
                      connectionsProvider: connectionsListProvider,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),

      body: FutureBuilder<List<ConnectionsListUserEntity>>(
        future: connectionsList, // Fetching connections
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No connections available'));
          }

          final connections = snapshot.data!;

          return Consumer<ConnectionsProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                itemCount: connections.length,
                itemBuilder: (context, index) {
                  final connection = connections[index];
                  return ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: GestureDetector(
                      child: SizedBox(
                        width: double.infinity,
                        child: ConnectionCard(
                          userId: connection.userId,
                          userName: connection.userName,
                          headLine: connection.headLine,
                          connectionTime: connection.connectionTime,
                          isOnline: false, //connection.isOnline,
                          image: connection.profilePicture,
                          connectionsProvider: connectionsListProvider,
                        ),
                      ),
                      onTap: () {
                        // Navigate to user profile
                        print(
                          'Navigate to user profile',
                        ); // Placeholder for navigation //TODO: Implement navigation
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
