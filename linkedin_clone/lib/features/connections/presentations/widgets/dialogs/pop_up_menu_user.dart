import 'package:flutter/material.dart';
import '../../provider/connections_provider.dart';
import 'remove_connection_dialog.dart';

class PopUpMenuUser extends StatelessWidget {
  final String userId;
  final String userName;
  final ConnectionsProvider connectionsProvider;
  const PopUpMenuUser({
    super.key,
    required this.userId,
    required this.userName,
    required this.connectionsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const ValueKey('remove_connection_menu_button'),
      icon: Icon(
        Icons.more_vert,
        size: 20,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
      onPressed: () {
        _popUpMenuUser(context);
      },
    );
  }

  void _popUpMenuUser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          key: const Key('key_popupmenuuser_modal_padding'),
          padding: EdgeInsets.all(16),
          child: Column(
            key: const Key('key_popupmenuuser_modal_column'),
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Padding(
                key: const Key('key_popupmenuuser_handle_padding'),
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  key: const Key('key_popupmenuuser_drag_handle'),
                  width:
                      MediaQuery.of(context).size.width * 0.3 > 80
                          ? 80
                          : MediaQuery.of(context).size.width * 0.3,
                  height:
                      MediaQuery.of(context).size.height * 0.03 > 10
                          ? 10
                          : MediaQuery.of(context).size.width * 0.03,
                  decoration: BoxDecoration(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                ),
              ),

              ListTile(
                key: const Key('key_popupmenuuser_remove_tile'),
                leading: IconButton(
                  key: const ValueKey('remove_connection_button'),
                  icon: Icon(Icons.person_remove_alt_1),
                  color: Theme.of(context).iconTheme.color,
                  onPressed: () {},
                ),
                title: Text(
                  'Remove connection',
                  key: const Key('key_popupmenuuser_remove_text'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RemoveConnectionDialog(
                        key: const Key('key_popupmenuuser_remove_dialog'),
                        userId: userId,
                        userName: userName,
                        connectionsProvider: connectionsProvider,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
