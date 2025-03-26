import 'package:flutter/material.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Home Page')),       // Will be replaced by News Feed module
    Center(child: Text('My Network Page')), // Will be replaced by Connections module
    Center(child: Text('Jobs Placeholder')),
    Center(child: Text('Settings Page')),   // Will be replaced by Settings module
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _goToProfile() {
    // Navigate to user profile
    Navigator.pop(context); // Close drawer
    Navigator.pushNamed(context, '/profile'); // Define this route in GoRouter or Navigator
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: null,
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _goToProfile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage('assets/images/profile_placeholder.png'), // Replace with user image
                  ),
                  const SizedBox(height: 12),
                  Text("Omar Kaddah", style: theme.textTheme.titleMedium), //Hardcoded fro now refactor when API is ready
                  Text("Ex-SWE Intern @Dell", style: theme.textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text("Giza, Egypt", style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const Divider(height: 32),
            ListTile(title: const Text("Puzzle games")),
            ListTile(title: const Text("Saved posts")),
            ListTile(title: const Text("Groups")),
            const Divider(height: 32),
            ListTile(
              leading: const Icon(Icons.workspace_premium_outlined),
              title: const Text("Try Premium for EGP0"),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.unselectedWidgetColor,
        backgroundColor: theme.scaffoldBackgroundColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "My Network"),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: "Jobs"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
