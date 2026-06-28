// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'dialogs/pop_up_menu_user.dart';

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
      key: Key('connections_list_actions_row_$userId'),
      children: [
        PopUpMenuUser(
          key: Key('connections_list_popup_menu_$userId'),
          userId: userId,
          userName: '$firstName $lastName',
          connectionsProvider: connectionsProvider,
        ),
        IconButton(
          key: const Key('routing_to_chat_button'),
          icon: Transform.rotate(
            key: Key('connections_list_send_icon_transform_$userId'),
            angle: 315 * (3.141592653589793 / 180),
            child: Icon(
              Icons.send,
              key: Key('connections_list_send_icon_$userId'),
              size: 23,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
