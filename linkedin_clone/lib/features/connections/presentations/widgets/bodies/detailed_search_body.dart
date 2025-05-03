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
      key: const Key('key_detailedsearch_scrollview'),
      child: Column(
        key: const Key('key_detailedsearch_main_column'),
        children: [
          SizedBox(
            key: const Key('key_detailedsearch_spacer_1'),
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Consumer<SearchProvider>(
            key: const Key('key_detailedsearch_users_consumer'),
            builder: (context, searchProvider, child) {
              if (_searchProvider.searchResultsUsers.isNotEmpty) {
                return UserSearchCard(
                  key: const Key('key_detailedsearch_users_card'),
                  users: users,
                );
              } else {
                return const SizedBox.shrink(
                  key: Key('key_detailedsearch_users_empty'),
                );
              }
            },
          ),
          SizedBox(
            key: const Key('key_detailedsearch_spacer_2'),
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Consumer<SearchProvider>(
            key: const Key('key_detailedsearch_companies_consumer'),
            builder: (context, searchProvider, child) {
              if (_searchProvider.searchResultsCompanies.isNotEmpty) {
                return CompanySearchCard(
                  key: const Key('key_detailedsearch_companies_card'),
                  companies: _searchProvider.searchResultsCompanies,
                );
              } else {
                return const SizedBox.shrink(
                  key: Key('key_detailedsearch_companies_empty'),
                );
              }
            },
          ),
          SizedBox(
            key: const Key('key_detailedsearch_spacer_3'),
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Consumer<SearchProvider>(
            key: const Key('key_detailedsearch_jobs_consumer'),
            builder: (context, searchProvider, child) {
              if (_searchProvider.searchResultsJobs.isNotEmpty) {
                return JobSearchCard(
                  key: const Key('key_detailedsearch_jobs_card'),
                  jobs: _searchProvider.searchResultsJobs,
                );
              } else {
                return const SizedBox.shrink(
                  key: Key('key_detailedsearch_jobs_empty'),
                );
              }
            },
          ),
          SizedBox(
            key: const Key('key_detailedsearch_spacer_4'),
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Consumer<SearchProvider>(
            key: const Key('key_detailedsearch_posts_consumer'),
            builder: (context, searchProvider, child) {
              if (_searchProvider.searchResultsPosts.isNotEmpty) {
                print("Posts: ${_searchProvider.searchResultsPosts.length}");
                return PostSearchCard(
                  key: const Key('key_detailedsearch_posts_card'),
                  posts: _searchProvider.searchResultsPosts,
                  myProfile: _searchProvider.myProfile!,
                );
              } else {
                return const SizedBox.shrink(
                  key: Key('key_detailedsearch_posts_empty'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
