// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/no_internet_connection.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/view_connections_appbar.dart';
import 'package:provider/provider.dart';
import '../widgets/view_connections_card.dart';
import '../provider/connections_provider.dart';

class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({Key? key}) : super(key: key);

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  late ConnectionsProvider connectionsProvider;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    connectionsProvider = Provider.of<ConnectionsProvider>(
      context,
      listen: false,
    );
    _scrollController = ScrollController()..addListener(_scrollListener);
    connectionsProvider.getConnections(isInitial: true);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!connectionsProvider.isBusy && connectionsProvider.hasMoreMain) {
        connectionsProvider.getConnections();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 65.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Connections',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(42),
          child: Consumer<ConnectionsProvider>(
            builder: (context, provider, _) {
              if (provider.connectionsList == null ||
                  provider.connectionsList!.isEmpty ||
                  provider.isLoading ||
                  provider.hasErrorMain) {
                return const SizedBox();
              }
              return ViewConnectionsAppBar(
                connectionsProvider: provider,
                connectionsCount: provider.connectionsList!.length,
              );
            },
          ),
        ),
      ),
      body: Consumer<ConnectionsProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: () => provider.getConnections(isInitial: true),
            child: Builder(
              builder: (context) {
                if (provider.isLoading) {
                  print('ConnectionsPage: Loading...');
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                } else if (provider.hasErrorMain) {
                  if (provider.errorSecondary == 'Request Timeout') {
                    return NoInternetConnection(
                      onRetry: () => provider.getConnections(isInitial: true),
                    );
                  } else {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height:
                            MediaQuery.of(context).size.height - kToolbarHeight,
                        width: MediaQuery.of(context).size.width,
                      ),
                    );
                  }
                } else if (provider.connectionsList!.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height:
                          MediaQuery.of(context).size.height - kToolbarHeight,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'No Connections',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: provider.connectionsList!.length + 1,
                  itemBuilder: (context, index) {
                    if (index < provider.connectionsList!.length) {
                      final connection = provider.connectionsList![index];
                      return ConnectionCard(
                        userId: connection.userId,
                        firstName: connection.firstName,
                        lastName: connection.lastName,
                        headLine: connection.headLine,
                        connectionTime: connection.time,
                        isOnline: false,
                        profilePicture: connection.profilePicture,
                        connectionsProvider: provider,
                      );
                    } else {
                      return provider.isBusy
                          ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                          : const SizedBox(height: 30);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
