import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/profile/domain/entities/skill.dart'
    as entity;
import 'package:linkedin_clone/features/profile/presentation/pages/skill/endorsements_list.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class SkillWidget extends StatefulWidget {
  final entity.Skill skill;

  const SkillWidget({super.key, required this.skill});

  @override
  State<SkillWidget> createState() => _SkillWidgetState();
}

class _SkillWidgetState extends State<SkillWidget> {
  bool _hasEndorsed = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkEndorsementStatus();
  }

  Future<void> _checkEndorsementStatus() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    try {
      setState(() {
        _isLoading = true;
      });

      // Check if the current user has already endorsed this skill
      final hasEndorsed = await profileProvider.hasEndorsedSkill(
        widget.skill.skillName,
      );

      if (mounted) {
        setState(() {
          _hasEndorsed = hasEndorsed;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasEndorsed = false;
          _isLoading = false;
        });
      }
      debugPrint('Error checking endorsement: $e');
    }
  }

  Future<void> _toggleEndorsement(ProfileProvider profileProvider) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final connectionsProvider = Provider.of<ConnectionsProvider>(
      context,
      listen: false,
    );
    final skillName = widget.skill.skillName;

    try {
      if (_hasEndorsed) {
        await connectionsProvider.removeEndorsment(
          profileProvider.userId!,
          skillName,
        );
      } else {
        await connectionsProvider.endorseSkill(
          profileProvider.userId!,
          skillName,
        );
      }

      if (mounted) {
        setState(() {
          _hasEndorsed = !_hasEndorsed;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _hasEndorsed
                  ? 'Endorsed $skillName'
                  : 'Removed endorsement for $skillName',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update endorsement: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final isConnection = profileProvider.connectStatus == 'Connection';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skill Name & Endorsements
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.skill.skillName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                if (widget.skill.position != null &&
                    widget.skill.position!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      widget.skill.position!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EndorsementsListPage(
                              skillName: widget.skill.skillName,
                            ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people, size: 16, color: Colors.black),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.skill.endorsements?.length ?? 0} endorsements',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Add Endorse button only if user is a connection
          if (isConnection)
            _isLoading
                ? const CircularProgressIndicator()
                : TextButton.icon(
                  onPressed: () => _toggleEndorsement(profileProvider),
                  icon: Icon(
                    _hasEndorsed
                        ? Icons.remove_circle_outline
                        : Icons.add_circle_outline,
                    color: Theme.of(context).primaryColor,
                    size: 18,
                  ),
                  label: Text(
                    _hasEndorsed ? 'Remove' : 'Endorse',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                    ),
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withOpacity(0.05),
                  ),
                ),
        ],
      ),
    );
  }
}
