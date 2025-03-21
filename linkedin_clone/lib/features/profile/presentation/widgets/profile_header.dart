import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final String profilePictureUrl = 'https://example.com/user_profile_image.png';
    final String name = 'John Doe';
    final String education = 'Cairo University';
    final String address = '123 Main St, Springfield, USA';
    final int connections = 500;
    final String headline =
        'Experienced Software Engineer with a demonstrated history of working in the tech industry.';
    final String website = 'https://example.com';

    return Container(
      color: Colors.white, // Set background color to white
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0), // Adjust vertical padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profilePictureUrl),
          ),
          const SizedBox(height: 15),
          Text(
            name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            headline,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            education,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            address,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6E6E6E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            website,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$connections connections',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),

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

          const SizedBox(height: 10), // Ensure spacing before last button only

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
    );
  }
}
