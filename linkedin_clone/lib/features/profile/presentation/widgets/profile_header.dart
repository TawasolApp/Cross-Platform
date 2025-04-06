import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/profile_header/edit_profile.dart';

class ProfileHeader extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onProfilePictureTap;

  const ProfileHeader({super.key, this.errorMessage, this.onProfilePictureTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final error = errorMessage ?? provider.profileError;
        final coverPhotoHeight = MediaQuery.of(context).size.width * 0.25;

        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Cover Photo section with further reduced height
              Container(
                height: coverPhotoHeight + 40, // Further reduced from 40
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand, // Changed to expand
                  children: [
                    // Cover Photo
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: coverPhotoHeight,
                      child: GestureDetector(
                        onTap:
                            () => _viewFullImage(
                              context,
                              provider.coverPhoto,
                              'Cover Photo',
                            ),
                        child: Container(
                          color: Colors.grey[200],
                          child:
                              provider.coverPhoto != null
                                  ? Image.network(
                                    provider.coverPhoto!,
                                    fit: BoxFit.cover,
                                  )
                                  : const Icon(
                                    Icons.photo,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                        ),
                      ),
                    ),

                    // Camera button for cover photo
                    Positioned(
                      top: 8,
                      right: 16,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Theme.of(context).primaryColor,
                            size: 16,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed:
                              () => _showCoverPhotoPickerDialog(
                                context,
                                provider,
                              ),
                        ),
                      ),
                    ),

                    // Profile picture - moved to a higher z-index
                    Positioned(
                      left: 16,
                      top: coverPhotoHeight - 50,
                      width: 100,
                      height: 100,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: CircleBorder(),
                          onTap:
                              onProfilePictureTap ??
                              () => _viewFullImage(
                                context,
                                provider.profilePicture,
                                'Profile Picture',
                              ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 48,
                                backgroundColor: Colors.grey[200],
                                backgroundImage:
                                    provider.profilePicture != null
                                        ? NetworkImage(provider.profilePicture!)
                                        : null,
                                child:
                                    provider.profilePicture == null
                                        ? Icon(
                                          Icons.person,
                                          size: 48,
                                          color: Colors.grey[400],
                                        )
                                        : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Camera button - placed on top of everything
                    Positioned(
                      left: 90,
                      top: coverPhotoHeight + 15,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: CircleBorder(),
                          onTap:
                              () => _showProfilePicturePickerDialog(
                                context,
                                provider,
                              ),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.camera_alt,
                                color: Theme.of(context).primaryColor,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Edit profile button with negative margin to pull it up
              Transform.translate(
                offset: const Offset(0, -35), // Negative margin to pull up
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        // Navigate to edit profile page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        ).then((updated) {
                          if (updated == true) {
                            // Refresh profile data if changes were made
                            Provider.of<ProfileProvider>(
                              context,
                              listen: false,
                            ).fetchProfile();
                          }
                        });
                      },
                      padding: EdgeInsets.zero, // Remove padding
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ), // Smaller constraints
                    ),
                  ),
                ),
              ),

              // Content section with more negative margin to pull it up further
              Transform.translate(
                offset: const Offset(0, -30),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Use minimum space needed
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.fullName.isNotEmpty
                            ? provider.fullName
                            : 'No name provided',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4), // Reduced from 4

                      Text(
                        provider.headline ?? 'No headline provided',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),

                      if (provider.educations?.isNotEmpty ?? false)
                        Text(
                          provider.educations!.first.school,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                      Text(
                        provider.location ?? 'No location provided',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6E6E6E),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        '${provider.connectionCount ?? 0} connections',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontSize: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text('Open to'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontSize: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text('Add section'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 1.5,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.more_horiz, size: 18),
                              onPressed: () {},
                              color: Theme.of(context).colorScheme.onSurface,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),

                      // If there's an error message, show it without any padding
                      if (error != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 0.0,
                          ), // Reduced from 16.0
                          child: Text(
                            error,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Keep all the helper methods exactly the same as before
  void _viewFullImage(BuildContext context, String? imageUrl, String title) {
    if (imageUrl == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: Text(title)),
              body: Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: Image.network(imageUrl, fit: BoxFit.contain),
                ),
              ),
            ),
      ),
    );
  }

  Future<void> _showImagePickerDialog(
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
                  onTap: () {
                    provider.deleteProfilePicture();
                    Navigator.pop(context);
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

  Future<void> _showCoverPhotoPickerDialog(
    BuildContext context,
    ProfileProvider provider,
  ) async {
    final result = await showDialog<ImageSource?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Cover Photo'),
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
              if (provider.coverPhoto != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Remove Cover Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    try {
                      await provider.deleteCoverPhoto();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cover photo removed successfully'),
                        ),
                      );
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to remove cover photo: $e'),
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
          await provider.updateCoverPhoto(pickedFile.path);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cover photo updated successfully')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update cover photo: $e')),
        );
      }
    }
  }

  // Updated method for profile picture picker dialog
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
