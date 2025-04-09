import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class AboutSection extends StatelessWidget {
  final String? bio;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final String? errorMessage;
  final bool isOwner;

  const AboutSection({
    super.key,
    this.bio,
    required this.isExpanded,
    required this.onToggleExpansion,
    this.errorMessage,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final displayBio = bio ?? provider.bio ?? '';
        final error = errorMessage ?? provider.bioError;
        final visibleBio =
            isExpanded || displayBio.length <= 200
                ? displayBio
                : '${displayBio.substring(0, 200)}...';

        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 12.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isOwner)
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => _showEditBioDialog(context, provider),
                      ),
                  ],
                ),
              ),

              // Bio Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayBio.isNotEmpty ? visibleBio : "No bio available",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    if (displayBio.length <= 200) const SizedBox(height: 16),
                  ],
                ),
              ),

              // Show More/Show Less Button
              if (displayBio.length > 200)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 8.0,
                    bottom: 0.0,
                  ),
                  child: TextButton(
                    onPressed: onToggleExpansion,
                    child: Text(isExpanded ? 'Show less' : 'Show more'),
                  ),
                ),

              // Error Message
              if (error != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),

              // Show empty state message when no bio and user is owner
              if (displayBio.isEmpty && isOwner)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Add information about yourself to help others understand your background.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showEditBioDialog(BuildContext context, ProfileProvider provider) {
    final bioController = TextEditingController(text: provider.bio);
    final maxBioLength = 2000;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            bool isSubmitting = false;

            return AlertDialog(
              contentPadding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: const Text(
                'Edit About',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: bioController,
                      maxLines: 5,
                      maxLength: maxBioLength,
                      buildCounter: (
                        BuildContext context, {
                        required int currentLength,
                        required bool isFocused,
                        required int? maxLength,
                      }) {
                        return Text(
                          '$currentLength / $maxLength',
                          style: TextStyle(
                            color:
                                currentLength == maxLength
                                    ? Colors.red
                                    : Colors.grey,
                            fontSize: 12,
                          ),
                        );
                      },
                      enabled: !isSubmitting,
                      decoration: InputDecoration(
                        hintText: 'Tell us about yourself...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        errorMaxLines: 2,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your bio';
                        }
                        if (value.length > maxBioLength) {
                          return 'Bio exceeds maximum length of $maxBioLength characters';
                        }
                        return null;
                      },
                    ),
                    if (provider.bioError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          provider.bioError!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                TextButton(
                  onPressed:
                      isSubmitting
                          ? null
                          : () async {
                            if (!formKey.currentState!.validate()) return;

                            setDialogState(() => isSubmitting = true);
                            await provider.setUserBio(bioController.text);

                            if (context.mounted) {
                              if (provider.bioError == null) {
                                Navigator.pop(context);
                              } else {
                                setDialogState(() => isSubmitting = false);
                              }
                            }
                          },
                  child:
                      isSubmitting
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
