// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/company_search_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/job_search_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/post_search_card.dart';
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              if (_searchProvider.searchResultsUsers.isNotEmpty) {
                return UserSearchCard(users: users);
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              if (_searchProvider.searchResultsCompanies.isNotEmpty) {
                return CompanySearchCard(
                  companies: _searchProvider.searchResultsCompanies,
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              if (_searchProvider.searchResultsJobs.isNotEmpty) {
                return JobSearchCard(jobs: _searchProvider.searchResultsJobs);
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              if (_searchProvider.searchResultsPosts.isNotEmpty) {
                return PostSearchCard(
                  posts: _searchProvider.searchResultsPosts,
                  myProfile: _searchProvider.myProfile!,
                );
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
