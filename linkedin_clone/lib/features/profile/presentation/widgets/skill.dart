import 'package:flutter/material.dart';

class Skill extends StatelessWidget {
  final String skillName;
  final int endorsements;
  final List<String> endorsers; // List of profile picture URLs

  const Skill({
    super.key,
    required this.skillName,
    required this.endorsements,
    required this.endorsers,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skill Name & Endorsements
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                skillName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  // Profile pictures of endorsers
                  ...endorsers.take(3).map((url) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(url),
                      ),
                    );
                  }).toList(),

                  // Endorsements count
                  Text(
                    '$endorsements',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
