import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../feed/data/models/reaction_model.dart';
import '../provider/feed_provider.dart';
import '../../../../core/utils/reaction_type.dart';

class ReactionsPage extends StatefulWidget {
  final String postId;

  const ReactionsPage({super.key, required this.postId});

  @override
  State<ReactionsPage> createState() => _ReactionsPageState();
}

class _ReactionsPageState extends State<ReactionsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<String> filterTypes;

  @override
  void initState() {
    super.initState();
    filterTypes = [
      'All',
      'Funny',
      'Like',
      'Celebrate',
      'Insightful',
      'Love',
      'Support',
    ];

    _tabController = TabController(length: filterTypes.length, vsync: this);

    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    feedProvider.getPostReactions(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final allReactions = feedProvider.postReactions;

    Map<String, List<ReactionModel>> grouped = {
      for (var t in filterTypes)
        t:
            t == 'All'
                ? allReactions
                : allReactions
                    .where((r) => r.type.toLowerCase() == t.toLowerCase())
                    .toList(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reactions'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          indicatorColor: Colors.blue,
          tabs:
              filterTypes.map((type) {
                final count = grouped[type]?.length ?? 0;
                final icon = getReactionIcon(type);
                final color = getReactionColor(type);
                return Tab(
                  child: Row(
                    children: [
                      if (type != 'All') Icon(icon, size: 16, color: color),
                      if (type != 'All') const SizedBox(width: 4),
                      Text('$count'),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            filterTypes.map((type) {
              final reactions = grouped[type] ?? [];
              if (reactions.isEmpty) {
                return const Center(child: Text("No reactions"));
              }

              return ListView.separated(
                itemCount: reactions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final r = reactions[index];
                  final reactionType = getReactionTypeFromName(r.type);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(r.authorPicture),
                    ),
                    title: Text(r.authorName),
                    subtitle: Text(r.authorBio),
                    trailing: Icon(
                      reactionType.icon,
                      color: reactionType.color,
                    ),
                  );
                },
              );
            }).toList(),
      ),
    );
  }
}
