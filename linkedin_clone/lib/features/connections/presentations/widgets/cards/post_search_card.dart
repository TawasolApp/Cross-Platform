import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/search_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:linkedin_clone/features/feed/domain/entities/post_entity.dart';
import 'package:linkedin_clone/features/feed/presentation/widgets/post_card.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PostSearchCard extends StatelessWidget {
  final List<PostEntity> posts;
  Profile myProfile;
  SearchProvider? _searchProvider;
  PostSearchCard({super.key, required this.posts, required this.myProfile});

  @override
  Widget build(BuildContext context) {
    _searchProvider = Provider.of<SearchProvider>(context);
    final displayedCompanies = posts.length > 3 ? posts.sublist(0, 3) : posts;

    return Container(
      key: const Key('key_postsearch_container'),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
      ),
      child: Column(
        key: const Key('key_postsearch_main_column'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            key: const Key('key_postsearch_title_padding'),
            padding: const EdgeInsets.only(top: 18.0, left: 16.0),

            child: Text(
              "Posts",
              key: const Key('key_postsearch_title_text'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(key: Key('key_postsearch_spacer'), height: 10),
          Padding(
            key: const Key('key_postsearch_posts_padding'),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              key: const Key('key_postsearch_posts_column'),
              children:
                  displayedCompanies.asMap().entries.map((entry) {
                    int index = entry.key;
                    PostEntity post = entry.value;
                    return Column(
                      key: Key('key_postsearch_post_column_$index'),
                      children: [
                        Divider(
                          key: Key('key_postsearch_divider_$index'),
                          color: Theme.of(context).dividerColor,
                        ),
                        FutureBuilder<String>(
                          key: Key('key_postsearch_future_$index'),
                          future: _searchProvider!.userId,
                          builder: (context, snapshot) {
                            return PostCard(
                              key: Key('key_postsearch_card_$index'),
                              post: post,
                              currentUserId: snapshot.data ?? '',
                              profileImage: myProfile.profilePicture,
                              profileName:
                                  "${myProfile.firstName} ${myProfile.lastName}",
                              profileTitle: myProfile.headline,
                            );
                          },
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
          Center(
            key: const Key('key_postsearch_button_center'),
            child: TextButton(
              key: const Key('key_postsearch_see_all_button'),
              onPressed: () {
                _searchProvider?.filterType = FilterType.posts;
              },
              child: Text(
                "See all posts",
                key: const Key('key_postsearch_see_all_text'),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
