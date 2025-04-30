import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:image_picker/image_picker.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: _isSaving ? null : _saveProfile,
            icon:
                _isSaving
                    ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: theme.primaryColor,
                      ),
                    )
                    : Icon(Icons.check, color: theme.primaryColor),
            label: Text(
              "Save",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                // Profile Image Section
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey[200],
                              backgroundImage:
                                  provider.profilePicture != null
                                      ? NetworkImage(provider.profilePicture!)
                                      : null,
                              child:
                                  provider.profilePicture == null
                                      ? Icon(
                                        Icons.person,
                                        size: 55,
                                        color: Colors.grey[400],
                                      )
                                      : null,
                            ),
                          ),
                          GestureDetector(
                            onTap:
                                () => _showProfilePicturePickerDialog(
                                  context,
                                  provider,
                                ),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: theme.primaryColor,
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${provider.firstName ?? ''} ${provider.lastName ?? ''}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (provider.headline != null &&
                          provider.headline!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            provider.headline!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                if (provider.profileError != null)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.error.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            provider.profileError!,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Personal Information Section
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            "Personal Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),

                        // First Name Field
                        _buildTextField(
                          controller: _firstNameController,
                          label: "First Name",
                          icon: Icons.person_outline,
                          required: true,
                        ),

                        const SizedBox(height: 16),

                        // Last Name Field
                        _buildTextField(
                          controller: _lastNameController,
                          label: "Last Name",
                          icon: Icons.person_outline,
                          required: true,
                        ),

                        const SizedBox(height: 16),

                        // Headline Field
                        _buildTextField(
                          controller: _headlineController,
                          label: "Headline",
                          icon: Icons.title,
                          required: true,
                          hint: "Your professional headline",
                        ),
                      ],
                    ),
                  ),
                ),

                // Location and Industry Section
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            "Location & Industry",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),

                        // Location Field
                        _buildTextField(
                          controller: _locationController,
                          label: "Location",
                          icon: Icons.location_on_outlined,
                          required: true,
                          hint: "City, Country",
                        ),

                        const SizedBox(height: 16),

                        // Industry Field
                        _buildTextField(
                          controller: _industryController,
                          label: "Industry",
                          icon: Icons.business_center_outlined,
                          hint: "Your industry or field",
                        ),
                      ],
                    ),
                  ),
                ),

                // About Section
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            "About",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),

                        // Bio Field
                        TextFormField(
                          controller: _bioController,
                          
                          decoration: InputDecoration(
                            hintText:
                                "Tell us about yourself and your professional experience",
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                            
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: theme.primaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                          maxLines: 6,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),

                // Save Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child:
                        _isSaving
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  "Saving...",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                            : const Text(
                              "Save Profile",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: required ? "$label *" : label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
      ),
      validator:
          required
              ? (value) =>
                  value?.trim().isEmpty ?? true
                      ? "This field is required"
                      : null
              : null,
      style: const TextStyle(fontSize: 15),
    );
  }

  Future<void> _showProfilePicturePickerDialog(
    BuildContext context,
    ProfileProvider provider,
  ) async {
    final result = await showDialog<ImageSource?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              if (provider.profilePicture != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    try {
                      await provider.deleteProfilePicture();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile picture removed successfully'),
                        ),
                      );
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to remove profile picture: $e'),
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      try {
        final pickedFile = await ImagePicker().pickImage(source: result);
        if (pickedFile != null) {
          await provider.updateProfilePicture(pickedFile.path);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile picture: $e')),
        );
      }
    }
  }
}
