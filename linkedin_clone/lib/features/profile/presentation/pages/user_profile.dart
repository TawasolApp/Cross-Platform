import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/profile_header.dart'; // Import the profile_header widget

class UserProfile extends StatelessWidget {
  const UserProfile({super.key}); // Add key parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Column(
        children: [
          ProfileHeader(), // Call the profile_header widget
          // Add other widgets here
        ],
      ),
    );
  }
}
