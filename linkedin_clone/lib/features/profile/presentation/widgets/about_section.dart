import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class AboutSection extends StatelessWidget {
  final String? bio;
  final String? errorMessage;

  const AboutSection({
    super.key, 
    this.bio,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                    onPressed: () => _showEditBioDialog(context, provider),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Error Message (if any)
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 14,
                    ),
                  ),
                ),

              // Bio Content or Loading Indicator
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    displayBio.isNotEmpty ? displayBio : "No bio available",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.4,
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
    final maxBioLength = 2000; // LinkedIn's actual character limit
    final formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (context) {
        bool isSubmitting = false;
        int charCount = bioController.text.length;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
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
                      maxLines: 8,
                      maxLength: maxBioLength,
                      enabled: !isSubmitting,
                      onChanged: (text) => setState(() => charCount = text.length),
                      decoration: InputDecoration(
                        hintText: 'Tell us about yourself...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your bio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$charCount / $maxBioLength',
                          style: TextStyle(
                            color: charCount == maxBioLength 
                                ? Colors.red 
                                : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
                  onPressed: isSubmitting 
                    ? null 
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        
                        setState(() => isSubmitting = true);
                        await provider.setUserBio(bioController.text);
                        
                        if (context.mounted) {
                          if (provider.bioError == null) {
                            Navigator.pop(context);
                          } else {
                            setState(() => isSubmitting = false);
                          }
                        }
                      },
                  child: isSubmitting 
                    ? const SizedBox(
                        width: 20, 
                        height: 20, 
                        child: CircularProgressIndicator(strokeWidth: 2)
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.white,
            );
          }
        );
      },
    );
  }
}