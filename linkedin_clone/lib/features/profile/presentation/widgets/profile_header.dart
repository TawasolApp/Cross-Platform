import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final String profilePictureUrl = 'https://example.com/user_profile_image.png';
    final String name = 'John' + ' (Johnny) ' + 'Doe';
    final String education = 'Cairo University';
    final String address = '123 Main St, Springfield, USA';
    final int connections = 500;
    final String headline = 'Experienced Software Engineer with a demonstrated history of working in the tech industry.';
    final String website = 'https://example.com';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 50.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profilePictureUrl),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              headline,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Text(
              education,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              address,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Color(0xFF6E6E6E),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              website,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$connections connections',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),

            // First row of buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4), 
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Open to'),
                  ),
                ),
                const SizedBox(width: 6), 

                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4), 
                      side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Add section'),
                  ),
                ),
                const SizedBox(width: 6), 

                // Circular "More Options" button
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
                    icon: const Icon(Icons.more_horiz, size: 16), 
                    onPressed: () {},
                    color: Theme.of(context).colorScheme.onSurface,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10), // Space before Enhance Profile button

            // Full-width Enhance Profile button
            SizedBox(
              width: double.infinity, // Ensures full width
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 6), // Compact height
                  side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                  textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Enhance Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
