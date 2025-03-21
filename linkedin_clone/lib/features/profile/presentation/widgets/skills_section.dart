import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/presentation/widgets/skill.dart'; // Import Skill widget

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  _SkillsSectionState createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  bool showAll = false; // To toggle showing extra skills

  final List<Map<String, dynamic>> skills = [
    {'name': 'Flutter', 'endorsements': 120, 'endorsers': [
      'https://randomuser.me/api/portraits/men/1.jpg',
      'https://randomuser.me/api/portraits/women/2.jpg',
      'https://randomuser.me/api/portraits/men/3.jpg'
    ]},
    {'name': 'Dart', 'endorsements': 95, 'endorsers': [
      'https://randomuser.me/api/portraits/women/4.jpg',
      'https://randomuser.me/api/portraits/men/5.jpg'
    ]},
    {'name': 'UI/UX Design', 'endorsements': 80, 'endorsers': [
      'https://randomuser.me/api/portraits/men/6.jpg',
      'https://randomuser.me/api/portraits/women/7.jpg'
    ]},
    {'name': 'Agile Development', 'endorsements': 60, 'endorsers': [
      'https://randomuser.me/api/portraits/women/8.jpg'
    ]},
    {'name': 'Project Management', 'endorsements': 45, 'endorsers': [
      'https://randomuser.me/api/portraits/men/9.jpg'
    ]},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header (Title + Buttons)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Skills & Endorsements',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {}, // Add skill action
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {}, // Edit skills action
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Skills List (Using Skill Widget) - Show top 3 always, others conditionally
          Column(
            children: (showAll ? skills : skills.take(3)).map((skill) {
              return Skill(
                skillName: skill['name'],
                endorsements: skill['endorsements'],
                endorsers: List<String>.from(skill['endorsers']),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // "Show More" Button to Reveal Extra Skills
          if (skills.length > 3)
            TextButton(
              onPressed: () {
                setState(() {
                  showAll = !showAll;
                });
              },
              child: Text(showAll ? 'Show less' : 'Show more'),
            ),
        ],
      ),
    );
  }
}
