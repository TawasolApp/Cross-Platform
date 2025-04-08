// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';
import 'error_dialog.dart';

class ConfirmableActionButton extends StatelessWidget {
  final String buttonText;
  final Future<bool> Function()? confirmAction; // like unfollow for example
  final Future<dynamic> Function()? errorDialogAction; // usually pop dialog
  final Future<dynamic> Function()? afterConfirmAction; // like refresh the page
  final String? confirmTitle;
  final String? confirmMessage;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final String errorTitle;
  final String errorMessage;
  final String errorButtonText;
  final bool confirmDialog;

  const ConfirmableActionButton({
    super.key,
    required this.buttonText,
    this.confirmAction,
    this.afterConfirmAction,
    required this.errorDialogAction,
    this.confirmTitle,
    this.confirmMessage,
    this.confirmButtonText,
    this.cancelButtonText,
    required this.errorTitle,
    required this.errorMessage,
    required this.errorButtonText,
    this.confirmDialog = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        bool result = false;

        if (confirmDialog) {
          // Show confirmation dialog and wait for user response
          await showDialog(
            context: context,
            barrierDismissible: true,
            builder:
                (context) => ConfirmationDialog(
                  title: confirmTitle!,
                  message: confirmMessage!,
                  confirmButtonText: confirmButtonText!,
                  cancelButtonText: cancelButtonText!,
                  onConfirm: () async {
                    // Close the confirmation dialog

                    // Execute the action if provided
                    if (confirmAction != null) {
                      result = await confirmAction!();

                      // Handle result after action completes
                      if (!result) {
                        // Show error dialog if action failed
                        showDialog(
                          context: context,
                          builder:
                              (context) => ErrorDialog(
                                title: errorTitle,
                                message: errorMessage,
                                buttonText: errorButtonText,
                                onPressed: errorDialogAction,
                              ),
                        );
                      } else if (afterConfirmAction != null) {
                        // Execute after-action if provided and action succeeded
                        afterConfirmAction!();
                      }
                    }
                  },
                  onCancel: () {
                    // Close the confirmation dialog
                    //  Navigator.of(context).pop();
                  },
                ),
          );
        } else {
          // Execute action directly without confirmation
          if (confirmAction != null) {
            result = await confirmAction!();

            // Handle result after action completes
            if (!result) {
              // Show error dialog if action failed
              showDialog(
                context: context,
                builder:
                    (context) => ErrorDialog(
                      title: errorTitle,
                      message: errorMessage,
                      buttonText: errorButtonText,
                      onPressed: errorDialogAction,
                    ),
              );
            } else if (afterConfirmAction != null) {
              // Execute after-action if provided and action succeeded
              afterConfirmAction!();
            }
          }
        }
      },
      child: Text(
        buttonText,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
