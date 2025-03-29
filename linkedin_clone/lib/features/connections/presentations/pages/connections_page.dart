// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/no_internet_connection.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/view_connections_appbar.dart';
import 'package:provider/provider.dart';
import '../widgets/view_connections_card.dart';
import '../../domain/entities/connections_list_user_entity.dart';
import '../provider/connections_provider.dart';

class ConnectionsPage extends StatelessWidget {
  final String token;
  const ConnectionsPage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectionsProvider = Provider.of<ConnectionsProvider>(
      context,
      listen: false,
    );
    connectionsProvider.setToken(token);
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
          child: Consumer<ConnectionsProvider>(
            builder: (context, connectionsProvider, child) {
              if (connectionsProvider.connectionsList == null) {
                return SizedBox();
              } else {
                return ViewConnectionsAppBar(
                  connectionsProvider: connectionsProvider,
                  connectionsCount: connectionsProvider.connectionsList!.length,
                );
              }
            },
          ),
        ),
      ),
      body: FutureBuilder(
        future: connectionsProvider.getConnections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return SizedBox();
          }
          if (snapshot.hasError) {
            return NoInternetConnection(
              onRetry: () => connectionsProvider.getConnections(),
            );
          }
          return Consumer<ConnectionsProvider>(
            builder: (context, connectionsProvider, _) {
              return RefreshIndicator(
                onRefresh: () => connectionsProvider.getConnections(),
                child: Consumer<ConnectionsProvider>(
                  builder: (context, provider, _) {
                    if (provider.connectionsList!.isEmpty) {
                      return const SizedBox();
                    }
                    return ListView.builder(
                      itemCount: provider.connectionsList!.length,
                      itemBuilder: (context, index) {
                        final connection = provider.connectionsList![index];
                        return ConnectionCard(
                          userId: connection.userId,
                          userName: connection.userName,
                          headLine: connection.headLine,
                          connectionTime: connection.connectionTime,
                          isOnline: false,
                          profilePicture: connection.profilePicture,
                          connectionsProvider: provider,
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
