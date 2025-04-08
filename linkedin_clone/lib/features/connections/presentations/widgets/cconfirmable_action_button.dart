// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';
import 'error_dialog.dart';

class ConfirmableActionButton extends StatelessWidget {
  final String buttonText;
  final Future<dynamic> Function()? confirmAction; //like unfollow for example
  final Future<dynamic> Function()?
  conrifmDialogCancelAction; //usually pop dialog
  final Future<dynamic> Function()? errorDialogAction; //usually pop dialog
  final Future<dynamic> Function()? afterConfirmAction; //like refresh the page
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
    this.conrifmDialogCancelAction,
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
          showDialog(
            context: context,
            builder:
                (context) => ConfirmationDialog(
                  title: confirmTitle!,
                  message: confirmMessage!,
                  confirmButtonText: confirmButtonText!,
                  cancelButtonText: cancelButtonText!,
                  onConfirm: () async {
                    if (confirmAction != null) {
                      result = await confirmAction!();
                    }
                  },
                ),
          );
        } else {
          if (confirmAction != null) {
            result = await confirmAction!();
          }
        }
        if (!result) {
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
        } else {
          Navigator.of(context).pop(); // Close dialog
          if (afterConfirmAction != null) {
            afterConfirmAction!(); // Perform the action after confirmation
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
