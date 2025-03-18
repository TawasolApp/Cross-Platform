import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key}); // Add key parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: Theme.of(context).appBarTheme.titleTextStyle, // Use theme's title text style
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0), // Add padding from left and top
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start, // Align the column to the left
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://example.com/user_profile_image.png'),
            ),
            const SizedBox(height: 20),
            Text(
              'John Doe',
              style: Theme.of(context).textTheme.headlineMedium, // Use theme's headline text style
            ),
            const SizedBox(height: 10),
            Text(
              'Ex-Intern at TotalEnergies Egypt - Computer and Communications Engineering Junior at Cairo University',
              style: Theme.of(context).textTheme.bodyLarge, // Use theme's body text style
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: Theme.of(context).elevatedButtonTheme.style, // Use theme's button style
              child: Text('Follow'),           
            ),
          ],
        ),
      ),
    );
  }
}
