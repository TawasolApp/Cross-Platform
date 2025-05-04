import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/company/domain/entities/user.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';

class CompanyFollowersScreen extends StatefulWidget {
  final String companyId;

  const CompanyFollowersScreen({Key? key, required this.companyId})
    : super(key: key);

  @override
  State<CompanyFollowersScreen> createState() => _CompanyFollowersScreenState();
}

class _CompanyFollowersScreenState extends State<CompanyFollowersScreen> {
  @override
  void initState() {
    super.initState();
    // Reset followers when company changes
    Future.microtask(() {
      final provider = Provider.of<CompanyProvider>(context, listen: false);
      provider.resetFollowers();
      provider.fetchFollowers(widget.companyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Company Followers')),
      body: Consumer<CompanyProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingFollowers && provider.followers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text(provider.errorMessage));
          }

          if (provider.followers.isEmpty) {
            return const Center(child: Text('No followers found.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.followers.length,
                  itemBuilder: (context, index) {
                    final user = provider.followers[index];
                    return buildUserTile(user);
                  },
                ),
              ),
              if (!provider.isAllFollowersLoaded &&
                  !provider.isLoadingFollowers)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    key: const ValueKey('load_more_followers_button'),
                    onPressed: () {
                      provider.loadMoreFollowers(widget.companyId);
                    },
                    child: const Text('Load More'),
                  ),
                ),
              if (provider.isAllFollowersLoaded)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: const Text('No more followers available.'),
                  ),
                ),
              if (provider.isLoadingFollowers)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget buildUserTile(User user) {
    final imageUrl = user.profilePicture;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading:
            imageUrl != null && imageUrl.isNotEmpty
                ? CircleAvatar(backgroundImage: NetworkImage(imageUrl))
                : const CircleAvatar(child: Icon(Icons.person)),
        title: Text('${user.firstName} ${user.lastName}'),
        subtitle: Text(user.headline ?? 'No headline'),
      ),
    );
  }
}
