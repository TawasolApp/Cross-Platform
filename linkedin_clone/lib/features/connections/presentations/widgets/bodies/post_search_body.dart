import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/user_card.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:linkedin_clone/features/feed/domain/entities/post_entity.dart';
import 'package:linkedin_clone/features/feed/presentation/widgets/post_card.dart';
import 'package:provider/provider.dart';

class PostSearchBody extends StatefulWidget {
  final String query;

  const PostSearchBody({super.key, required this.query});

  @override
  State<PostSearchBody> createState() => _PostSearchBodyState();
}

class _PostSearchBodyState extends State<PostSearchBody> {
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
      if (_searchProvider.hasMorePosts && !_searchProvider.isBusy) {
        _searchProvider.performSearchPosts(searchWord: widget.query);
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
    List<PostEntity> posts = _searchProvider.searchResultsPosts;

    return ListView.builder(
      key: const Key('post_search_listview'),
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: posts.length + 1,
      itemBuilder: (context, index) {
        if (index < posts.length) {
          final post = posts[index];
          return Column(
            key: Key('post_item_column_$index'),
            children: [
              FutureBuilder<String>(
                key: Key('post_user_id_future_$index'),
                future: _searchProvider.userId,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return PostCard(
                      key: Key('post_card_$index'),
                      post: post,
                      currentUserId: snapshot.data!,
                      profileImage: _searchProvider.myProfile?.profilePicture,
                      profileName:
                          "${_searchProvider.myProfile?.firstName} ${_searchProvider.myProfile?.lastName}",
                      profileTitle: _searchProvider.myProfile?.headline,
                    );
                  }
                  return const Center(
                    key: Key('post_card_loading_container'),
                    child: CircularProgressIndicator(
                      key: Key('post_card_loading_indicator'),
                    ),
                  );
                },
              ),
              Divider(
                key: Key('post_divider_$index'),
                height: 1,
                thickness: 1,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ],
          );
        } else {
          return _searchProvider.isBusy
              ? const Padding(
                key: Key('post_loading_more_container'),
                padding: EdgeInsets.all(16),
                child: Center(
                  key: Key('post_loading_more_center'),
                  child: CircularProgressIndicator(
                    key: Key('post_loading_more_indicator'),
                  ),
                ),
              )
              : const SizedBox(key: Key('post_list_bottom_spacer'), height: 30);
        }
      },
    );
  }
}
