import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/pop_up_menu_sort_by.dart';

/// AppBar for the View Connections Page
/// icon buttons for search and filtering connections
class ViewConnectionsAppBar extends StatelessWidget {
  final int connectionsCount;

  const ViewConnectionsAppBar({required this.connectionsCount, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '$connectionsCount connections',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.search, size: 25),
              color: const Color.fromARGB(255, 30, 30, 30),
              onPressed: () {},
            ),
            PopUpMenuSortBy(),
          ],
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Color.fromARGB(255, 201, 201, 201),
        ),
      ],
    );
  }
}
