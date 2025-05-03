import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/domain/entities/education.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/education/add_education.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/education/edit_education.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class EducationListPage extends StatefulWidget {
  const EducationListPage({super.key});

  @override
  State<EducationListPage> createState() => _EducationListPageState();
}

class _EducationListPageState extends State<EducationListPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Education",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: theme.primaryColor,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEducation(context),
        backgroundColor: theme.primaryColor,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        if (provider.educations == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.educations!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, size: 60, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No education added yet",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tap the + button to add your education",
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchProfile(provider.userId),
          color: Theme.of(context).primaryColor,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.school,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Education",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Showcase your academic background and qualifications",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // List of educations
              ...provider.educations!.asMap().entries.map(
                (entry) => _buildEducationCard(
                  context,
                  entry.value,
                  entry.key,
                  provider,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEducationCard(
    BuildContext context,
    Education education,
    int index,
    ProfileProvider provider,
  ) {
    // Format degree type for display
    String formatDegreeType(String? type) {
      // Convert to title case with proper formatting
      return type?.trim() ?? '';
    }

    final String formattedDegree = formatDegreeType(education.degree);

    final dates =
        education.endDate != null
            ? "${education.startDate} - ${education.endDate}"
            : "${education.startDate} - Present";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _editEducation(context, education),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child:
                          education.companyLogo != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  education.companyLogo!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.school,
                                        size: 35,
                                        color: Colors.grey[400],
                                      ),
                                    );
                                  },
                                ),
                              )
                              : Center(
                                child: Icon(
                                  Icons.school,
                                  size: 35,
                                  color: Colors.grey[400],
                                ),
                              ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            education.school,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Degree and Field - Allow wrapping
                          if (education.degree != null &&
                              education.field != null) ...[
                            Wrap(
                              children: [
                                Text(
                                  formattedDegree,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  " · ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  education.field!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ] else if (education.degree != null) ...[
                            Text(
                              formattedDegree,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ] else if (education.field != null) ...[
                            Text(
                              education.field!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],

                          const SizedBox(height: 4),
                          // Date range with calendar icon
                          if (education.startDate != null) ...[
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    dates,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                if (education.endDate == null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Colors.green[200]!,
                                      ),
                                    ),
                                    child: Text(
                                      "Current",
                                      style: TextStyle(
                                        color: Colors.green[800],
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],

                          // Grade if available
                          if (education.grade != null &&
                              education.grade!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.grade,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    "Grade: ${education.grade}",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == "edit") {
                          await _editEducation(context, education);
                        } else if (value == "delete") {
                          await _deleteEducation(context, index, provider);
                        }
                      },
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      icon: Icon(Icons.more_vert, color: Colors.grey[700]),
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: "edit",
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: Colors.grey[700],
                                  ),
                                  const SizedBox(width: 8),
                                  const Text("Edit"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ),

                // Description if available - show full text
                if (education.description != null &&
                    education.description!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Text(
                    education.description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addEducation(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddEducationPage()),
    );

    if (result == true && mounted) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await _refreshEducations(provider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Education added successfully")),
        );
      }
    }
  }

  Future<void> _editEducation(BuildContext context, Education education) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditEducationPage(education: education),
      ),
    );

    if (result == true && mounted) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await _refreshEducations(provider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Education updated successfully")),
        );
      }
    }
  }

  Future<void> _deleteEducation(
    BuildContext context,
    int index,
    ProfileProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Education"),
            content: const Text(
              "Are you sure you want to remove this education? This action cannot be undone.",
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text(
                  "Delete",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true && context.mounted) {
      setState(() => _isLoading = true);
      try {
        await provider.removeEducation(index);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Education deleted successfully")),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to delete: ${e.toString()}")),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _refreshEducations(ProfileProvider provider) async {
    setState(() => _isLoading = true);
    try {
      await provider.fetchProfile(provider.userId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to refresh: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
