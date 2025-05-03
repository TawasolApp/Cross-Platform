import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/user_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:provider/provider.dart';

class SearchUsersBody extends StatefulWidget {
  final String query;

  const SearchUsersBody({super.key, required this.query});

  @override
  State<SearchUsersBody> createState() => _SearchUsersBodyState();
}

class _SearchUsersBodyState extends State<SearchUsersBody> {
  late ScrollController _scrollController;
  late SearchProvider _searchProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchProvider = Provider.of<SearchProvider>(context);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_searchProvider.hasMoreUsers && !_searchProvider.isBusy) {
        _searchProvider.performSearchUser(searchWord: widget.query);
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
    List<ConnectionsUserEntity> users = _searchProvider.searchResultsUsers;

    if (users.isEmpty && _searchProvider.isBusy) {
      return const Center(
        key: Key('key_searchusers_loading_center'),
        child: CircularProgressIndicator(
          key: Key('key_searchusers_loading_indicator'),
        ),
      );
    }

    if (users.isEmpty && !_searchProvider.isBusy) {
      return Center(
        key: const Key('key_searchusers_empty_center'),
        child: Text(
          'No users found matching "${widget.query}"',
          key: const Key('key_searchusers_empty_text'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return ListView.builder(
      key: const Key('key_searchusers_listview'),
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: users.length + 1,
      itemBuilder: (context, index) {
        if (index < users.length) {
          final user = users[index];
          return Column(
            key: Key('key_searchusers_column_$index'),
            children: [
              UserCard(
                key: Key('key_searchusers_card_$index'),
                userId: user.userId,
                firstName: user.firstName,
                lastName: user.lastName,
                headLine: user.headLine ?? '',
                profilePicture: user.profilePicture,
                isOnline: false,
                time: '',
                cardType: PageType.search,
              ),
              Divider(
                key: Key('key_searchusers_divider_$index'),
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor,
              ),
            ],
          );
        } else {
          return _searchProvider.isBusy
              ? Padding(
                key: const Key('key_searchusers_loading_more_container'),
                padding: const EdgeInsets.all(16),
                child: Center(
                  key: const Key('key_searchusers_loading_more_center'),
                  child: CircularProgressIndicator(
                    key: const Key('key_searchusers_loading_more_indicator'),
                  ),
                ),
              )
              : SizedBox(
                key: const Key('key_searchusers_bottom_spacer'),
                height: 30,
              );
        }
      },
    );
  }
}
