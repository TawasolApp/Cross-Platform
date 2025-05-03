// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/users_search_card.dart';
import 'package:provider/provider.dart';

class DetailedSearchBody extends StatefulWidget {
  const DetailedSearchBody({super.key});

  @override
  _DetailedSearchBodyState createState() => _DetailedSearchBodyState();
}

class _DetailedSearchBodyState extends State<DetailedSearchBody> {
  late SearchProvider _searchProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchProvider = Provider.of<SearchProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<ConnectionsUserEntity> users =
        _searchProvider.searchResultsUsers;

    return SingleChildScrollView(
      child: Column(
        children: [
          Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              if (_searchProvider.searchResultsUsers.isNotEmpty) {
                return UserSearchCard(users: users);
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
