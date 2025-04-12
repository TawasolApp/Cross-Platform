import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/endorsement.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class EndorsementsListPage extends StatefulWidget {
  final String skillName;

  const EndorsementsListPage({Key? key, required this.skillName})
    : super(key: key);

  @override
  State<EndorsementsListPage> createState() => _EndorsementsListPageState();
}

class _EndorsementsListPageState extends State<EndorsementsListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch endorsements for this skill when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.getSkillEndorsements(widget.skillName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2EE),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Endorsements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final provider = Provider.of<ProfileProvider>(
                context,
                listen: false,
              );
              provider.getSkillEndorsements(widget.skillName);
            },
            tooltip: 'Refresh Endorsements',
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingEndorsements) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.endorsementsError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.endorsementsError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.getSkillEndorsements(widget.skillName);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final endorsements = provider.currentEndorsements;
          if (endorsements == null || endorsements.isEmpty) {
            return Center(
              child: Text(
                'No endorsements yet for ${widget.skillName}',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Text(
                  widget.skillName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              if (endorsements.isNotEmpty)
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    '${endorsements.length} ${endorsements.length == 1 ? 'person has' : 'people have'} endorsed you',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: endorsements.length,
                    separatorBuilder:
                        (context, index) => Divider(
                          height: 32,
                          thickness: 1,
                          color: Colors.grey.shade200,
                        ),
                    itemBuilder: (context, index) {
                      final endorsement = endorsements[index];
                      return EndorsementListItem(endorsement: endorsement);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class EndorsementListItem extends StatelessWidget {
  final Endorsement endorsement;

  const EndorsementListItem({Key? key, required this.endorsement})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade300,
            backgroundImage:
                endorsement.profilePicture != null
                    ? NetworkImage(endorsement.profilePicture!)
                    : null,
            child:
                endorsement.profilePicture == null
                    ? Text(
                      _getInitials(endorsement.firstName, endorsement.lastName),
                      style: const TextStyle(color: Colors.black54),
                    )
                    : null,
          ),
          const SizedBox(width: 16),
          // User details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${endorsement.firstName ?? ''} ${endorsement.lastName ?? ''}'
                      .trim(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Since we don't have headline in the original endorsement entity
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Has endorsed you for this skill',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String? firstName, String? lastName) {
    String initials = '';
    if (firstName != null && firstName.isNotEmpty) {
      initials += firstName[0];
    }
    if (lastName != null && lastName.isNotEmpty) {
      initials += lastName[0];
    }
    return initials.toUpperCase();
  }
}
