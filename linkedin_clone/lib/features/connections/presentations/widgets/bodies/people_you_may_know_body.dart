import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/cards/people_you_may_know_user_card.dart';
import 'package:provider/provider.dart';

class PeopleYouMayKnowBody extends StatefulWidget {
  final ScrollController scrollController;

  const PeopleYouMayKnowBody({super.key, required this.scrollController});

  @override
  State<PeopleYouMayKnowBody> createState() => _PeopleYouMayKnowBodyState();
}

class _PeopleYouMayKnowBodyState extends State<PeopleYouMayKnowBody> {
  late NetworksProvider _networksProvider;

  @override
  void initState() {
    super.initState();

    _networksProvider = Provider.of<NetworksProvider>(context, listen: false);
    _networksProvider.getPeopleYouMayKnowList(isInitial: true);
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (widget.scrollController.position.pixels >=
            widget.scrollController.position.maxScrollExtent - 200 &&
        !_networksProvider.isBusy &&
        _networksProvider.hasMore) {
      _networksProvider.getPeopleYouMayKnowList(); // pagination
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectionsProvider = Provider.of<ConnectionsProvider>(context);

    return Consumer<NetworksProvider>(
      key: const Key('key_pymk_networks_consumer'),
      builder: (context, provider, _) {
        final list = provider.peopleYouMayKnowList ?? [];

        return Container(
          key: const Key('key_pymk_container'),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          child: Column(
            key: const Key('key_pymk_column'),
            children: [
              Text(
                "People you may know",
                key: const Key('key_pymk_title'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(key: Key('key_pymk_spacer'), height: 10),
              GridView.builder(
                key: const Key('key_pymk_grid'),
                itemCount: list.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: 2 / 3,
                ),
                itemBuilder: (context, index) {
                  final user = list[index];
                  return PeopleYouMayKnowUserCard(
                    key: Key('key_pymk_card_$index'),
                    firstName: user.firstName,
                    lastName: user.lastName,
                    userId: user.userId,
                    profileImageUrl: user.profileImageUrl,
                    headerImageUrl: user.headerImageUrl,
                    headLine: user.headLine,
                    connectionsProvider: connectionsProvider,
                    networksProvider: _networksProvider,
                  );
                },
              ),
              if (provider.isBusy)
                Padding(
                  key: const Key('key_pymk_loading_container'),
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    key: const Key('key_pymk_loading_center'),
                    child: CircularProgressIndicator(
                      key: const Key('key_pymk_loading_indicator'),
                    ),
                  ),
                ),
              if (provider.hasMore && list.isEmpty && !provider.isBusy)
                Center(
                  key: const Key('key_pymk_empty_center'),
                  child: Text(
                    "No people to connect with at the moment",
                    key: const Key('key_pymk_empty_text'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
