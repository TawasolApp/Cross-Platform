import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/routing_functions.dart';
import 'package:linkedin_clone/features/privacy/presentations/provider/privacy_provider.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/profile_header/edit_profile.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';

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

        // Use the new status fields with their specific values
        final isOwner = provider.connectStatus == 'Owner';
        final isConnection = provider.connectStatus == 'Connection';
        final isPending = provider.connectStatus == 'Pending';
        final isRequest = provider.connectStatus == 'Request';
        final isNoConnection = provider.connectStatus == 'No Connection';

        final isFollowing = provider.followStatus == 'Following';
        final isNotFollowing = provider.followStatus == 'No Connection';

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
                              ).fetchProfile(provider.userId);
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
                        GestureDetector(
                          onTap:
                              () => goToConnections(
                                context,
                                userId: provider.userId,
                              ),
                          child: Text(
                            '${provider.connectionCount ?? 0} connections',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        // const SizedBox(height: 16),
                      ],

                      // Action buttons based on connectStatus
                      if (isOwner) ...[
                        // _buildOwnerButtons(context),
                      ] else if (isConnection) ...[
                        _buildConnectionButtons(context, provider),
                      ] else if (isPending) ...[
                        _buildPendingButtons(context, provider),
                      ] else if (isRequest) ...[
                        _buildRequestButtons(context, provider),
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

  // // No changes needed for _buildOwnerButtons
  // Widget _buildOwnerButtons(BuildContext context) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: SizedBox(
  //           height: 36,
  //           child: ElevatedButton(
  //             onPressed: () {},
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Theme.of(context).primaryColor,
  //               foregroundColor: Colors.white,
  //               textStyle: Theme.of(
  //                 context,
  //               ).textTheme.labelLarge?.copyWith(fontSize: 14),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(24),
  //               ),
  //               padding: const EdgeInsets.symmetric(vertical: 8),
  //             ),
  //             child: const Text('Open to'),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 8),
  //       Expanded(
  //         child: SizedBox(
  //           height: 36,
  //           child: ElevatedButton(
  //             onPressed: () {},
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.white,
  //               foregroundColor: Theme.of(context).primaryColor,
  //               textStyle: Theme.of(
  //                 context,
  //               ).textTheme.labelLarge?.copyWith(fontSize: 14),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(24),
  //                 side: BorderSide(
  //                   color: Theme.of(context).primaryColor,
  //                   width: 1.5,
  //                 ),
  //               ),
  //               padding: const EdgeInsets.symmetric(vertical: 8),
  //             ),
  //             child: const Text('Add section'),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 8),
  //       Container(
  //         height: 36,
  //         width: 36,
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           border: Border.all(
  //             color: Theme.of(context).colorScheme.onSurface,
  //             width: 1.5,
  //           ),
  //         ),
  //         child: IconButton(
  //           icon: const Icon(Icons.more_horiz, size: 18),
  //           onPressed: () {},
  //           color: Theme.of(context).colorScheme.onSurface,
  //           padding: EdgeInsets.zero,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildConnectionButtons(
    BuildContext context,
    ProfileProvider provider,
  ) {
    final isFollowing = provider.followStatus == 'Following';
    final networksProvider = Provider.of<NetworksProvider>(
      context,
      listen: false,
    );

    return Row(
      key: const Key('profile_action_buttons_row'),
      children: [
        // Message button (primary action for connections)
        Expanded(
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              key: const Key('profile_message_button'),
              onPressed: () {}, // Message action
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
              child: const Text('Message'),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Follow/Following button for connections based on followStatus
        Expanded(
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              key: Key(
                'profile_${isFollowing ? 'following' : 'follow'}_button',
              ),
              onPressed: () async {
                // Toggle follow status using NetworksProvider directly
                if (provider.userId == null) return;

                bool success;
                if (isFollowing) {
                  // Unfollow action
                  success = await networksProvider.unfollowUser(
                    provider.userId!,
                  );
                } else {
                  // Follow action
                  success = await networksProvider.followUser(provider.userId!);
                }

                if (success) {
                  // Refresh the profile to get updated status
                  await provider.fetchProfile(provider.userId);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFollowing
                            ? 'Unfollowed successfully'
                            : 'Following successfully',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFollowing ? 'Failed to unfollow' : 'Failed to follow',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isFollowing ? Colors.grey[200] : Colors.white,
                foregroundColor:
                    isFollowing
                        ? Colors.black87
                        : Theme.of(context).primaryColor,
                textStyle: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontSize: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color:
                        isFollowing
                            ? Colors.transparent
                            : Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isFollowing ? 'Following' : 'Follow'),
                  if (isFollowing) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.check, size: 16),
                  ],
                ],
              ),
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
            key: const Key('profile_options_button'),
            icon: const Icon(Icons.more_horiz, size: 18),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Container(
                              width: 36,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            leading: Icon(
                              Icons.flag_outlined,
                              color: Colors.red[700],
                              size: 22,
                            ),
                            title: Text(
                              'Report',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                            onTap: () {
                              goToReportUser(context, userId: provider.userId);
                            },
                          ),
                          Divider(height: 1, color: Colors.grey[200]),
                          ListTile(
                            leading: Icon(
                              Icons.block,
                              color: Colors.red[700],
                              size: 22,
                            ),
                            title: Text(
                              'Block',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              // Show block confirmation dialog
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text(
                                        'Block this person?',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      content: const Text(
                                        'They won\'t be able to see your profile or contact you on TawasolApp. They won\'t be notified that you blocked them.',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: Text(
                                            'CANCEL',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'BLOCK',
                                            style: TextStyle(
                                              color: Colors.red[700],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                      backgroundColor: Colors.white,
                                      elevation: 5,
                                    ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            color: Theme.of(context).colorScheme.onSurface,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildPendingButtons(BuildContext context, ProfileProvider provider) {
    final isFollowing = provider.followStatus == 'Following';
    final isPrivateProfile =
        provider.visibility == 'private' ||
        provider.visibility == 'connections_only';
    final networksProvider = Provider.of<NetworksProvider>(
      context,
      listen: false,
    );
    final connectionsProvider = Provider.of<ConnectionsProvider>(
      context,
      listen: false,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isPrivateProfile) ...[
          Row(
            children: [
              // Pending button - now clickable to withdraw request
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Withdraw connection request
                      if (provider.userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Cannot withdraw request: User ID is missing',
                            ),
                          ),
                        );
                        return;
                      }

                      // Show confirmation dialog
                      final shouldWithdraw = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Withdraw Connection Request'),
                              content: const Text(
                                'Are you sure you want to withdraw your connection request?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'WITHDRAW',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );

                      if (shouldWithdraw == true) {
                        // Show loading indicator
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Withdrawing connection request...'),
                          ),
                        );

                        // Call the withdraw connection request function
                        final success = await connectionsProvider
                            .withdrawConnectionRequest(provider.userId!);

                        // Show result
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Connection request withdrawn'
                                  : 'Failed to withdraw connection request',
                            ),
                            backgroundColor:
                                success ? Colors.green : Colors.red,
                          ),
                        );

                        // Refresh profile if successful
                        if (success) {
                          await provider.fetchProfile(provider.userId);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      textStyle: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(fontSize: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
              // Follow/Following button for pending connections
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (provider.userId == null) return;

                      if (isFollowing) {
                        // Unfollow action
                        final success = await networksProvider.unfollowUser(
                          provider.userId!,
                        );
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to unfollow'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        // Follow action
                        final success = await networksProvider.followUser(
                          provider.userId!,
                        );
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to follow'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                      await provider.fetchProfile(provider.userId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFollowing ? Colors.grey[200] : Colors.white,
                      foregroundColor:
                          isFollowing
                              ? Colors.black87
                              : Theme.of(context).primaryColor,
                      textStyle: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(fontSize: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color:
                              isFollowing
                                  ? Colors.transparent
                                  : Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isFollowing ? 'Following' : 'Follow'),
                        if (isFollowing) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.check, size: 16),
                        ],
                      ],
                    ),
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
                  key: const Key('profile_options_button'),
                  icon: const Icon(Icons.more_horiz, size: 18),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      elevation: 10,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                  ),
                                  child: Container(
                                    width: 36,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ListTile(
                                  leading: Icon(
                                    Icons.flag_outlined,
                                    color: Colors.red[700],
                                    size: 22,
                                  ),
                                  title: Text(
                                    'Report',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    // Show report dialog or navigate to report page
                                    // Show report dialog or navigate to report page
                                    goToReportUser(
                                      context,
                                      userId: provider.userId,
                                    );
                                  },
                                ),
                                Divider(height: 1, color: Colors.grey[200]),
                                ListTile(
                                  leading: Icon(
                                    Icons.block,
                                    color: Colors.red[700],
                                    size: 22,
                                  ),
                                  title: Text(
                                    'Block',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    // Show block confirmation dialog
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text(
                                              'Block this person?',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            content: const Text(
                                              'They won\'t be able to see your profile or contact you on TawasolApp. They won\'t be notified that you blocked them.',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: const Text(
                                                        'Block functionality will be implemented soon',
                                                      ),
                                                      backgroundColor:
                                                          Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                      behavior:
                                                          SnackBarBehavior
                                                              .floating,
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'BLOCK',
                                                  style: TextStyle(
                                                    color: Colors.red[700],
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            backgroundColor: Colors.white,
                                            elevation: 5,
                                          ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  color: Theme.of(context).colorScheme.onSurface,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ] else ...[
          _buildLimitedAccessMessage(context),
        ],
        const SizedBox(height: 8), // Add bottom padding for visual balance
      ],
    );
  }

  Widget _buildRequestButtons(BuildContext context, ProfileProvider provider) {
    final isFollowing = provider.followStatus == 'Following';
    final connectionsProvider = Provider.of<ConnectionsProvider>(
      context,
      listen: false,
    );
    final networksProvider = Provider.of<NetworksProvider>(
      context,
      listen: false,
    );

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () async {
                // Accept connection request
                if (provider.userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Cannot accept request: User ID is missing',
                      ),
                    ),
                  );
                  return;
                }

                // Show loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Accepting connection request...'),
                    duration: Duration(seconds: 1),
                  ),
                );

                // Accept the connection request
                final success = await connectionsProvider
                    .acceptConnectionRequest(provider.userId!);

                // Show result after a short delay to allow snackbar visibility
                Future.delayed(const Duration(milliseconds: 1200), () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Connection request accepted'
                            : 'Failed to accept connection request',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                });

                // Refresh profile if successful
                if (success) {
                  await provider.fetchProfile(provider.userId);
                }
              },
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
              onPressed: () async {
                // Ignore connection request with confirmation
                if (provider.userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Cannot ignore request: User ID is missing',
                      ),
                    ),
                  );
                  return;
                }

                // Show confirmation dialog
                final shouldIgnore = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Ignore Connection Request'),
                        content: const Text(
                          'Are you sure you want to ignore this connection request?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'IGNORE',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );

                if (shouldIgnore == true) {
                  // Show loading indicator
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ignoring connection request...'),
                      duration: Duration(seconds: 1),
                    ),
                  );

                  // Ignore the connection request
                  final success = await connectionsProvider
                      .ignoreConnectionRequest(provider.userId!);

                  // Show result after a short delay
                  Future.delayed(const Duration(milliseconds: 1200), () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Connection request ignored'
                              : 'Failed to ignore connection request',
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  });

                  // Refresh profile if successful
                  if (success) {
                    await provider.fetchProfile(provider.userId);
                  }
                }
              },
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
            key: const Key('profile_options_button'),
            icon: const Icon(Icons.more_horiz, size: 18),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Container(
                              width: 36,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            leading: Icon(
                              Icons.flag_outlined,
                              color: Colors.red[700],
                              size: 22,
                            ),
                            title: Text(
                              'Report',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                            onTap: () {
                              // Show report dialog or navigate to report page
                              goToReportUser(context, userId: provider.userId);
                            },
                          ),
                          Divider(height: 1, color: Colors.grey[200]),
                          ListTile(
                            leading: Icon(
                              Icons.block,
                              color: Colors.red[700],
                              size: 22,
                            ),
                            title: Text(
                              'Block',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text(
                                        'Block this person?',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      content: const Text(
                                        'They won\'t be able to see your profile or contact you on TawasolApp. They won\'t be notified that you blocked them.',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: Text(
                                            'CANCEL',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'BLOCK',
                                            style: TextStyle(
                                              color: Colors.red[700],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                      backgroundColor: Colors.white,
                                      elevation: 5,
                                    ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            color: Theme.of(context).colorScheme.onSurface,
            padding: EdgeInsets.zero,
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
    final isNoConnection = provider.connectStatus == 'No Connection';
    final isFollowing = provider.followStatus == 'Following';
    final networksProvider = Provider.of<NetworksProvider>(
      context,
      listen: false,
    );
    final privacyProvider = Provider.of<PrivacyProvider>(
      context,
      listen: false,
    );
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
                    onPressed: () async {
                      // Get the connections provider
                      final connectionsProvider =
                          Provider.of<ConnectionsProvider>(
                            context,
                            listen: false,
                          );

                      // Verify we have a user ID
                      if (provider.userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cannot connect: User ID is missing'),
                          ),
                        );
                        return;
                      }

                      // Show loading indicator
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sending connection request...'),
                        ),
                      );

                      // Send connection request
                      final success = await connectionsProvider
                          .sendConnectionRequest(provider.userId!);

                      // Show result
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Connection request sent successfully'
                                : 'Failed to send connection request',
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );

                      // Refresh the profile to get updated status from server
                      if (success) {
                        await provider.fetchProfile(provider.userId);
                      }
                    },
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
                    onPressed: () async {
                      if (provider.userId == null) return;

                      bool success;
                      if (isFollowing) {
                        // Unfollow action
                        success = await networksProvider.unfollowUser(
                          provider.userId!,
                        );
                      } else {
                        // Follow action
                        success = await networksProvider.followUser(
                          provider.userId!,
                        );
                      }

                      if (success) {
                        // Refresh to update UI
                        await provider.fetchProfile(provider.userId);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFollowing
                                  ? 'Unfollowed successfully'
                                  : 'Following successfully',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFollowing
                                  ? 'Failed to unfollow'
                                  : 'Failed to follow',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFollowing ? Colors.grey[200] : Colors.white,
                      foregroundColor:
                          isFollowing
                              ? Colors.black87
                              : Theme.of(context).primaryColor,
                      textStyle: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(fontSize: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color:
                              isFollowing
                                  ? Colors.transparent
                                  : Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isFollowing ? 'Following' : 'Follow'),
                        if (isFollowing) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.check, size: 16),
                        ],
                      ],
                    ),
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
                  key: const Key('profile_options_button'),
                  icon: const Icon(Icons.more_horiz, size: 18),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      elevation: 10,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                  ),
                                  child: Container(
                                    width: 36,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ListTile(
                                  leading: Icon(
                                    Icons.flag_outlined,
                                    color: Colors.red[700],
                                    size: 22,
                                  ),
                                  title: Text(
                                    'Report',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  onTap: () {
                                    // Show report dialog or navigate to report page
                                    goToReportUser(
                                      context,
                                      userId: provider.userId,
                                    );
                                  },
                                ),
                                Divider(height: 1, color: Colors.grey[200]),
                                ListTile(
                                  leading: Icon(
                                    Icons.block,
                                    color: Colors.red[700],
                                    size: 22,
                                  ),
                                  title: Text(
                                    'Block',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    // Show block confirmation dialog
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text(
                                              'Block this person?',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            content: const Text(
                                              'They won\'t be able to see your profile or contact you on TawasolApp. They won\'t be notified that you blocked them.',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  bool success =
                                                      await privacyProvider
                                                          .blockUser(
                                                            provider.userId!,
                                                          );
                                                  if (success) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                          'User Blocked successfully',
                                                        ),
                                                        backgroundColor:
                                                            Theme.of(
                                                              context,
                                                            ).primaryColor,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                      ),
                                                    );
                                                    Navigator.pop(context);
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                          'Failed to block user',
                                                        ),
                                                        backgroundColor:
                                                            Theme.of(
                                                              context,
                                                            ).primaryColor,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  'BLOCK',
                                                  style: TextStyle(
                                                    color: Colors.red[700],
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            backgroundColor: Colors.white,
                                            elevation: 5,
                                          ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  color: Theme.of(context).colorScheme.onSurface,
                  padding: EdgeInsets.zero,
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
