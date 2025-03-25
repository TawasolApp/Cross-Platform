import 'package:flutter/material.dart';
import '../provider/connections_provider.dart';
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
      icon: Icon(
        Icons.more_vert,
        size: 20,
        color: const Color.fromARGB(255, 30, 30, 30),
      ),
      onPressed: () {
        _popUpMenuUser(context);
      },
    );
  }

  void _popUpMenuUser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 30, 30, 30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                ),
              ),

              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.person_remove_alt_1),
                  color: const Color.fromARGB(255, 30, 30, 30),
                  onPressed: () {},
                ),
                title: Text('Remove connection'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RemoveConnectionDialog(
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
