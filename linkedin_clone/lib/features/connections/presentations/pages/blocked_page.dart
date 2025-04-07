// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/blocked_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/no_internet_connection.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/view_connections_appbar.dart';
import 'package:provider/provider.dart';
import '../widgets/view_connections_card.dart';
import '../provider/networks_provider.dart';
import "../widgets/blocked_card.dart";

class BlockedPage extends StatefulWidget {
  const BlockedPage({Key? key}) : super(key: key);

  @override
  State<BlockedPage> createState() => _BlockedPageState();
}

class _BlockedPageState extends State<BlockedPage> {
  late NetworksProvider networksProvider;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    networksProvider = Provider.of<NetworksProvider>(context, listen: false);
    _scrollController = ScrollController()..addListener(_scrollListener);
    networksProvider.getBlockedList(isInitial: true);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!networksProvider.isBusy && networksProvider.hasMore) {
        networksProvider.getBlockedList();
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
        title: Text('Blocked', style: Theme.of(context).textTheme.titleLarge),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(42),
          child: Consumer<NetworksProvider>(
            builder: (context, provider, _) {
              if (provider.blockedList == null ||
                  provider.blockedList!.isEmpty ||
                  provider.isLoading ||
                  provider.hasError) {
                return const SizedBox();
              }
              return Column(
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${provider.blockedList!.length} people',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: Consumer<NetworksProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: () => provider.getBlockedList(isInitial: true),
            child: Builder(
              builder: (context) {
                if (provider.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                } else if (provider.hasError) {
                  if (provider.error == 'Request Timeout') {
                    return NoInternetConnection(
                      onRetry: () => provider.getBlockedList(isInitial: true),
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
                } else if (provider.blockedList!.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height:
                          MediaQuery.of(context).size.height - kToolbarHeight,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'No Blocked Users',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: provider.blockedList!.length + 1,
                  itemBuilder: (context, index) {
                    if (index < provider.blockedList!.length) {
                      final connection = provider.blockedList![index];
                      return BlockedCard(
                        userId: connection.userId,
                        firstName: connection.firstName,
                        lastName: connection.lastName,
                        headLine: connection.headLine,
                        profilePicture: connection.profilePicture,
                        networksProvider: provider,
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
