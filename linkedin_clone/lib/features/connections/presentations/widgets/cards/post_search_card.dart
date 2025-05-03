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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 16.0),

            child: Text(
              "Companies",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children:
                  displayedCompanies.map((post) {
                    return Column(
                      children: [
                        Divider(color: Theme.of(context).dividerColor),
                        PostCard(
                          post: post,
                          currentUserId: myProfile.userId,
                          profileImage: myProfile.profilePicture,
                          profileName:
                              "${myProfile.firstName} ${myProfile.lastName}",
                          profileTitle: myProfile.headline,
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                _searchProvider?.filterType = FilterType.posts;
              },
              child: Text(
                "See all posts",
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
