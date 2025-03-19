import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final String coverPhotoUrl = 'https://example.com/cover_photo.png';
    final String profilePictureUrl = 'https://example.com/user_profile_image.png';
    final String name = 'John Doe';
    final String occupation = 'Software Engineer at Example Corp';
    final String address = '123 Main St, Springfield, USA';
    final int connections = 500;
    final String bio = 'Experienced Software Engineer with a demonstrated history of working in the tech industry.';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align the column to the left
        children: <Widget>[
          // Cover photo
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Placeholder gray background color
              image: coverPhotoUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(coverPhotoUrl), // Mock cover photo
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 50.0), // More balanced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align the column to the left
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300], // Placeholder gray background color
                  backgroundImage: profilePictureUrl.isNotEmpty
                      ? NetworkImage(profilePictureUrl) // Mock profile picture
                      : null,
                ),
                const SizedBox(height: 20),
                Text(
                  name, // Mock name
                  style: Theme.of(context).textTheme.headlineMedium, // Theme-based text style
                ),
                const SizedBox(height: 10),
                Text(
                  occupation, // Mock occupation
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  address, // Mock address
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  '$connections connections', // Mock connections
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Text(
                  bio, // Mock bio
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0), // Better button alignment
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center buttons
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Text('Open to'),
                      ),
                      const SizedBox(width: 10), // Add spacing between buttons
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Text('Add section'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
