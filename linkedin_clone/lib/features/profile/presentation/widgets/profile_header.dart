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

        // Determine what to show based on visibility and status
        final isOwner = provider.status == 'Owner';
        final isConnection = provider.status == 'Connection';
        final isFollowing = provider.status == 'Following';
        final isPending = provider.status == 'Pending';
        final isRequest = provider.status == 'Request';
        final isNoConnection = provider.status == 'No Connection';

        final isPrivateProfile = provider.visibility == 'private';
        final isConnectionsOnly = provider.visibility == 'connections_only';
        final isPublicProfile = provider.visibility == 'public';

        // Determine if we should show limited information
        final showLimitedInfo =
            (isPrivateProfile && !isOwner) ||
            (isConnectionsOnly && !isOwner && !isConnection);

        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Cover Photo section
              Container(
                height: coverPhotoHeight + 40,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    // Cover Photo - always visible
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: coverPhotoHeight,
                      child: GestureDetector(
                        onTap:
                            showLimitedInfo
                                ? null
                                : () => _viewFullImage(
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

                    // Camera button for cover photo - only for owner
                    if (isOwner)
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

                    // Profile picture
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
                              showLimitedInfo
                                  ? null
                                  : onProfilePictureTap ??
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

                    // Camera button for profile picture - only for owner
                    if (isOwner)
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

              // Edit profile button - only for owner
              if (isOwner)
                Transform.translate(
                  offset: const Offset(0, -35),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfilePage(),
                            ),
                          ).then((updated) {
                            if (updated == true) {
                              Provider.of<ProfileProvider>(
                                context,
                                listen: false,
                              ).fetchProfile();
                            }
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ),
                  ),
                ),

              // Content section
              Transform.translate(
                offset: Offset(
                  0,
                  isOwner ? -30 : -10,
                ), // Removed const, using conditional offset
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    isOwner
                        ? 10
                        : 30, // Removed from const, using conditional padding
                    16,
                    0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showLimitedInfo
                            ? 'LinkedIn Member'
                            : provider.fullName.isNotEmpty
                            ? provider.fullName
                            : 'No name provided',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),

                      if (!showLimitedInfo) ...[
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFF6E6E6E)),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          '${provider.connectionCount ?? 0} connections',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Action buttons based on status
                      if (isOwner) ...[
                        _buildOwnerButtons(context),
                      ] else if (isConnection) ...[
                        _buildConnectionButtons(context),
                      ] else if (isFollowing) ...[
                        _buildFollowingButtons(context),
                      ] else if (isPending) ...[
                        _buildPendingButtons(context),
                      ] else if (isRequest) ...[
                        _buildRequestButtons(context),
                      ] else if (isNoConnection || showLimitedInfo) ...[
                        _buildNoConnectionButtons(context, provider),
                      ],

                      if (error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
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

  Widget _buildOwnerButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                textStyle: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontSize: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
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
                foregroundColor: Theme.of(context).primaryColor,
                textStyle: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontSize: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
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
    );
  }

  Widget _buildConnectionButtons(BuildContext context) {
    return Row(
      children: [
        // Message button (primary action for connections)
        Expanded(
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {}, // Message action
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                // ...existing style...
              ),
              child: const Text('Message'),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Following button for connections
        Expanded(
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {}, // Following action
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
                // ...existing style...
              ),
              child: const Text('Following'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFollowingButtons(BuildContext context) {
    return Row(
      children: [
        // Connect button (primary action for following users)
        Expanded(
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {}, // Connect action
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                // ...existing style...
              ),
              child: const Text('Connect'),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Following button with checkmark
        Expanded(
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {}, // Following action
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
                // ...existing style...
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Following'),
                  SizedBox(width: 4),
                  Icon(Icons.check, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingButtons(BuildContext context) {
    return Row(
      children: [
        // Pending button
        Expanded(
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {}, // View pending status
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
                // ...existing style...
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pending'),
                  SizedBox(width: 4),
                  Icon(Icons.hourglass_top, size: 16),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Following button for pending connections
        Expanded(
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {}, // Follow action
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
                textStyle: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontSize: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Follow'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {}, // Accept connection request
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                textStyle: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontSize: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Accept'),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {}, // Ignore connection request
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                textStyle: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontSize: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.grey[400]!, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Ignore'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLimitedAccessMessage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Enhanced private profile message with card and icon
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(Icons.lock_outline, color: Colors.grey[600], size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This profile is private',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Connect with this person to see their full profile',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // // Action buttons
        // Row(
        //   children: [
        //     Expanded(
        //       child: SizedBox(
        //         height: 36,
        //         child: ElevatedButton(
        //           onPressed: () {}, // Connect action
        //           style: ElevatedButton.styleFrom(
        //             backgroundColor: Theme.of(context).primaryColor,
        //             foregroundColor: Colors.white,
        //             textStyle: Theme.of(
        //               context,
        //             ).textTheme.labelLarge?.copyWith(fontSize: 14),
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(24),
        //             ),
        //             padding: const EdgeInsets.symmetric(vertical: 8),
        //           ),
        //           child: const Text('Connect'),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(width: 8),
        //     Expanded(
        //       child: SizedBox(
        //         height: 36,
        //         child: ElevatedButton(
        //           onPressed: () {}, // Follow action
        //           style: ElevatedButton.styleFrom(
        //             backgroundColor: Colors.white,
        //             foregroundColor: Theme.of(context).primaryColor,
        //             textStyle: Theme.of(
        //               context,
        //             ).textTheme.labelLarge?.copyWith(fontSize: 14),
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(24),
        //               side: BorderSide(
        //                 color: Theme.of(context).primaryColor,
        //                 width: 1.5,
        //               ),
        //             ),
        //             padding: const EdgeInsets.symmetric(vertical: 8),
        //           ),
        //           child: const Text('Follow'),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildNoConnectionButtons(
    BuildContext context,
    ProfileProvider provider,
  ) {
    final isPrivateProfile =
        provider.visibility == 'private' ||
        provider.visibility == 'connections_only';
    final isNoConnection = provider.status == 'No Connection';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4), // Add consistent spacing
        // Only show connection buttons if the profile is not private OR user has a connection
        if (!isPrivateProfile || !isNoConnection)
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {}, // Connect action
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      textStyle: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(fontSize: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Connect'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {}, // Follow action
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      textStyle: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(fontSize: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Follow'),
                  ),
                ),
              ),
            ],
          ),

        // If private profile with no connection, show privacy message instead of buttons
        if (isPrivateProfile && isNoConnection)
          _buildLimitedAccessMessage(context),
        const SizedBox(height: 8), // Add bottom padding for visual balance
      ],
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
