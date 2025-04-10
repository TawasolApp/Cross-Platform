import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/list_page_appbar.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/manage_my_network_body.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/people_you_may_know_body.dart';

import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/page_type_enum.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/no_internet_connection.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/user_card.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';

class ListPage extends StatefulWidget {
  final PageType type;

  const ListPage({super.key, required this.type});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late ScrollController _scrollController;
  ConnectionsProvider? connectionsProvider;
  NetworksProvider? networksProvider;

  @override
  void initState() {
    super.initState();
    if (widget.type == PageType.connections) {
      connectionsProvider = Provider.of<ConnectionsProvider>(
        context,
        listen: false,
      );
    } else {
      networksProvider = Provider.of<NetworksProvider>(context, listen: false);
    }
    _scrollController = ScrollController()..addListener(_scrollListener);
    _fetchInitial();
  }

  void _fetchInitial() {
    switch (widget.type) {
      case PageType.followers:
        networksProvider?.getFollowersList(isInitial: true);
        break;
      case PageType.following:
        networksProvider?.getFollowingList(isInitial: true);
        break;
      case PageType.blocked:
        networksProvider?.getBlockedList(isInitial: true);
        break;
      case PageType.connections:
        connectionsProvider?.getConnections(isInitial: true);
        break;
      default:
        break;
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (networksProvider != null &&
          !networksProvider!.isBusy &&
          networksProvider!.hasMore) {
        switch (widget.type) {
          case PageType.followers:
            networksProvider!.getFollowersList();
            break;
          case PageType.following:
            networksProvider!.getFollowingList();
            break;
          case PageType.blocked:
            networksProvider!.getBlockedList();
            break;
          default:
            break;
        }
      }

      if (connectionsProvider != null &&
          !connectionsProvider!.isBusy &&
          connectionsProvider!.hasMoreMain) {
        if (widget.type == PageType.connections) {
          connectionsProvider!.getConnections();
        }
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
    final isWide = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        toolbarHeight: isWide ? 80 : 65,
        title: Text(
          widget.type == PageType.connections
              ? 'Connections'
              : widget.type == PageType.followers
              ? 'Followers'
              : widget.type == PageType.following
              ? 'People I Follow'
              : widget.type == PageType.manageMyNetwork
              ? 'Manage My Network'
              : 'Blocked',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        bottom:
            widget.type == PageType.connections
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(42),
                  child: Consumer<ConnectionsProvider>(
                    builder: (context, provider, _) {
                      if (provider.connectionsList == null ||
                          provider.connectionsList!.isEmpty ||
                          provider.isLoading ||
                          provider.hasErrorMain) {
                        return const SizedBox();
                      }
                      return ListPageAppBar(
                        pageType: widget.type,
                        count: provider.connectionsList!.length,
                        connectionsProvider: provider,
                      );
                    },
                  ),
                )
                : widget.type == PageType.followers
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(42),
                  child: Consumer<NetworksProvider>(
                    builder: (context, provider, _) {
                      if (provider.followersList == null ||
                          provider.followersList!.isEmpty ||
                          provider.isLoading ||
                          provider.hasError) {
                        return const SizedBox();
                      }
                      return ListPageAppBar(
                        pageType: widget.type,
                        count: provider.followersList!.length,
                      );
                    },
                  ),
                )
                : widget.type == PageType.following
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(42),
                  child: Consumer<NetworksProvider>(
                    builder: (context, provider, _) {
                      if (provider.followingList == null ||
                          provider.followingList!.isEmpty ||
                          provider.isLoading ||
                          provider.hasError) {
                        return const SizedBox();
                      }
                      return ListPageAppBar(
                        pageType: widget.type,
                        count: provider.followingList!.length,
                      );
                    },
                  ),
                )
                : widget.type == PageType.blocked
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(42),
                  child: Consumer<NetworksProvider>(
                    builder: (context, provider, _) {
                      if (provider.blockedList == null ||
                          provider.blockedList!.isEmpty ||
                          provider.isLoading ||
                          provider.hasError) {
                        return const SizedBox();
                      }
                      return ListPageAppBar(
                        pageType: widget.type,
                        count: provider.blockedList!.length,
                      );
                    },
                  ),
                )
                : null,
      ),
      body:
          widget.type == PageType.connections
              ? Consumer<ConnectionsProvider>(
                builder: (context, provider, _) {
                  connectionsProvider = provider;
                  return _buildBody(context);
                },
              )
              : Consumer<NetworksProvider>(
                builder: (context, provider, _) {
                  networksProvider = provider;
                  return _buildBody(context);
                },
              ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final list = _getList();

    if (widget.type == PageType.manageMyNetwork) {
      // Using FutureBuilder to handle the async operation
      return FutureBuilder<String?>(
        future: connectionsProvider?.getMyUserId(),
        builder: (context, snapshot) {
          return ManageMyNetworkBody(
            networksProvider: networksProvider,
            connectionsProvider: connectionsProvider,
            userId: snapshot.data,
          );
        },
      );
    }

    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () async => _fetchInitial(),
      child: Builder(
        builder: (context) {
          if (_isLoading()) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (_hasError()) {
            final errorText =
                connectionsProvider?.errorMain ?? networksProvider?.error;
            if (errorText == 'Request Timeout') {
              return NoInternetConnection(onRetry: () => _fetchInitial());
            } else {
              return _emptyPlaceholder();
            }
          } else if (list == null || list.isEmpty) {
            return _emptyPlaceholder(
              child: Center(
                child: Text(
                  _getEmptyText(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          } else {
            return ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length + 1,
              itemBuilder: (context, index) {
                if (index < list.length) {
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
                        time: user.time ?? '',
                        cardType: widget.type,
                        networksProvider: networksProvider,
                        connectionsProvider: connectionsProvider,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ],
                  );
                } else {
                  final isBusy =
                      (connectionsProvider?.isBusy ?? false) ||
                      (networksProvider?.isBusy ?? false);
                  return isBusy
                      ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                      : const SizedBox(height: 30);
                }
              },
            );
          }
        },
      ),
    );
  }

  List<dynamic>? _getList() {
    switch (widget.type) {
      case PageType.followers:
        return networksProvider?.followersList;
      case PageType.following:
        return networksProvider?.followingList;
      case PageType.blocked:
        return networksProvider?.blockedList;
      case PageType.connections:
        return connectionsProvider?.connectionsList;
      default:
        return null;
    }
  }

  bool _hasError() {
    return (networksProvider?.hasError ?? false) ||
        (connectionsProvider?.hasErrorMain ?? false);
  }

  bool _isLoading() {
    if (widget.type == PageType.connections) {
      return connectionsProvider?.isLoading ?? false;
    } else {
      return networksProvider?.isLoading ?? false;
    }
  }

  Widget _emptyPlaceholder({Widget? child}) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        width: MediaQuery.of(context).size.width,
        child: child,
      ),
    );
  }

  String _getEmptyText() {
    switch (widget.type) {
      case PageType.followers:
        return 'No Followers';
      case PageType.following:
        return 'There are no people you follow';
      case PageType.blocked:
        return 'No Blocked Users';
      case PageType.connections:
        return 'No Connections';
      default:
        return 'Nothing to show';
    }
  }
}
