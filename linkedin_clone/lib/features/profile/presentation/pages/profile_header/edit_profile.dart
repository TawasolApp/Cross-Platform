import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _headlineController = TextEditingController();
  final _locationController = TextEditingController();
  final _industryController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Load current profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      _firstNameController.text = provider.firstName ?? '';
      _lastNameController.text = provider.lastName ?? '';
      _headlineController.text = provider.headline ?? '';
      _locationController.text = provider.location ?? '';
      _industryController.text = provider.industry ?? '';
      _bioController.text = provider.bio ?? '';
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _headlineController.dispose();
    _locationController.dispose();
    _industryController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);

      // Update first name if changed
      if (_firstNameController.text != provider.firstName) {
        await provider.updateFirstName(_firstNameController.text);
      }

      // Update last name if changed
      if (_lastNameController.text != provider.lastName) {
        await provider.updateLastName(_lastNameController.text);
      }

      // Update headline if changed
      if (_headlineController.text != provider.headline) {
        await provider.updateHeadline(_headlineController.text);
      }

      // Update location if changed
      if (_locationController.text != provider.location) {
        await provider.updateLocation(_locationController.text);
      }

      // Update industry if changed
      if (_industryController.text != provider.industry) {
        await provider.updateIndustry(_industryController.text);
      }

      // Update bio if changed
      if (_bioController.text != provider.bio) {
        await provider.setUserBio(_bioController.text);
      }

      if (mounted) {
        Navigator.pop(context, true); // Return success flag
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child:
                _isSaving
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.white,
                      ),
                    )
                    : const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Consumer<ProfileProvider>(
                builder: (context, provider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Icon Header - similar to experience & education pages
                      Center(
                        child: Card(
                          shape: const CircleBorder(),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  provider.profilePicture != null
                                      ? NetworkImage(provider.profilePicture!)
                                      : null,
                              child:
                                  provider.profilePicture == null
                                      ? const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.blueGrey,
                                      )
                                      : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (provider.profileError != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            provider.profileError!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),

                      // First Name Field
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: "First Name*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true ? "Required" : null,
                          ),
                        ),
                      ),

                      // Last Name Field
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: "Last Name*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true ? "Required" : null,
                          ),
                        ),
                      ),

                      // Headline Field
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: TextFormField(
                            controller: _headlineController,
                            decoration: const InputDecoration(
                              labelText: "Headline*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true ? "Required" : null,
                          ),
                        ),
                      ),

                      // Location Field
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              labelText: "Location*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true ? "Required" : null,
                          ),
                        ),
                      ),

                      // Industry Field
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: TextFormField(
                            controller: _industryController,
                            decoration: const InputDecoration(
                              labelText: "Industry",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Bio Field
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: TextFormField(
                            controller: _bioController,
                            decoration: const InputDecoration(
                              labelText: "About",
                              border: InputBorder.none,
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 8.0,
                              ),
                            ),
                            maxLines: 5,
                          ),
                        ),
                      ),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child:
                              _isSaving
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text(
                                    "Save Profile",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
