// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/confirmation_dialog.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/error_dialog.dart';

/// **Blocked Card** includes user data for blocked users
/// - User Data includes user image, name, headline, and online status
class BlockedCard extends StatelessWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final String headLine;
  final String profilePicture;
  final NetworksProvider networksProvider;

  const BlockedCard({
    super.key,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.headLine,
    required this.profilePicture,
    required this.networksProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// **Profile Image with Online Indicator**
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                          right: 8,
                          left: 8,
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage:
                              profilePicture != 'notavailable'
                                  ? NetworkImage(profilePicture)
                                  : null,
                          backgroundColor: const Color.fromARGB(
                            255,
                            214,
                            210,
                            200,
                          ),
                          child:
                              profilePicture == 'notavailable'
                                  ? Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Theme.of(context).primaryColor,
                                  )
                                  : null,
                        ),
                      ),

                      /// **User Details**
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            /// **Name**
                            Text(
                              '$firstName $lastName',
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                            ),

                            /// **Headline**
                            Text(
                              headLine,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),

                      /// **Unblock Button**
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => ConfirmationDialog(
                                  title: "Unblock $firstName $lastName?",
                                  message:
                                      "Are you sure you want to unblock $firstName $lastName?",
                                  confirmButtonText: "Block",
                                  cancelButtonText: "Cancel",
                                  onConfirm: () async {
                                    if (await networksProvider.unblockUser(
                                      userId,
                                    )) {
                                      networksProvider.getBlockedList(
                                        isInitial: true,
                                      );
                                      Navigator.pop(context); // Close dialog
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => ErrorDialog(
                                              title: "Error",
                                              message:
                                                  "Unable to unblock $firstName $lastName.",
                                              buttonText: "Cancel",
                                              onPressed: () {
                                                Navigator.pop(
                                                  context,
                                                ); // Close dialog
                                                Navigator.pop(
                                                  context,
                                                ); // Close dialog
                                              },
                                            ),
                                      );
                                    }
                                  },
                                  onCancel: () {
                                    Navigator.pop(context); // Close dialog
                                  },
                                ),
                          );
                        },
                        child: Text(
                          'Unblock',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
