// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'pop_up_menu_user.dart';

class ConnectionsListActions extends StatelessWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final dynamic connectionsProvider;

  const ConnectionsListActions({
    Key? key,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.connectionsProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PopUpMenuUser(
          userId: userId,
          userName: '$firstName $lastName',
          connectionsProvider: connectionsProvider,
        ),
        IconButton(
          icon: Transform.rotate(
            angle: 315 * (3.141592653589793 / 180),
            child: Icon(
              Icons.send,
              size: 23,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Routing to Messaging page')),
            );
          },
        ),
      ],
    );
  }
}
