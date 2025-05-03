import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/user_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:provider/provider.dart';

class UserSearchBody extends StatefulWidget {
  final String query;

  const UserSearchBody({super.key, required this.query});

  @override
  State<UserSearchBody> createState() => _UserSearchBodyState();
}

class _UserSearchBodyState extends State<UserSearchBody> {
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

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: users.length + 1,
      itemBuilder: (context, index) {
        if (index < users.length) {
          final user = users[index];
          return Column(
            children: [
              UserCard(
                userId: user.userId,
                firstName: user.firstName,
                lastName: user.lastName,
                profilePicture: user.profilePicture,
                cardType: PageType.search,
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ],
          );
        } else {
          return _searchProvider.isBusy
              ? const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
              : const SizedBox(height: 30);
        }
      },
    );
  }
}
