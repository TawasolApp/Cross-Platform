import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class AboutSection extends StatelessWidget {
  final ProfileProvider provider;
  final String? bio;
  final String? errorMessage;

  const AboutSection({
    super.key, 
    required this.provider,
    this.bio,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final displayBio = bio ?? provider.bio ?? '';
    final isLoading = provider.isLoading;
    final error = errorMessage ?? provider.bioError;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header with Edit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'About',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () => _showEditBioDialog(context, provider),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Error Message (if any)
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                error,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),

          // Bio Content or Loading Indicator
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Text(
              displayBio.isNotEmpty ? displayBio : "No bio available",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }

  void _showEditBioDialog(BuildContext context, ProfileProvider provider) {
    final bioController = TextEditingController(text: provider.bio);
    final maxBioLength = 300;  // Common limit for bio text
    
    showDialog(
      context: context,
      builder: (context) {
        bool isSubmitting = false;
        int charCount = bioController.text.length;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Bio'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: bioController,
                    maxLines: 5,
                    maxLength: maxBioLength,
                    enabled: !isSubmitting,
                    onChanged: (text) => setState(() => charCount = text.length),
                    decoration: const InputDecoration(
                      hintText: 'Tell us about yourself...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$charCount / $maxBioLength',
                    style: TextStyle(
                      color: charCount == maxBioLength ? Colors.red : Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  if (provider.bioError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        provider.bioError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: isSubmitting 
                    ? null 
                    : () async {
                        if (bioController.text.trim().isEmpty) {
                          // Use the setter directly instead of a non-existent method
                          provider.bioError = "Bio cannot be empty";
                          return;
                        }
                        
                        setState(() {
                          isSubmitting = true;
                        });
                        
                        await provider.setUserBio(bioController.text);
                        
                        if (context.mounted) {
                          if (provider.bioError == null) {
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              isSubmitting = false;
                            });
                          }
                        }
                      },
                  child: isSubmitting 
                    ? const SizedBox(
                        width: 16, 
                        height: 16, 
                        child: CircularProgressIndicator(strokeWidth: 2)
                      )
                    : const Text('Save'),
                ),
              ],
            );
          }
        );
      },
    );
  }
}