// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../dialogs/confirmation_dialog.dart';
import '../dialogs/error_dialog.dart';

class ConfirmableActionButton extends StatelessWidget {
  final String buttonText;
  final Future<bool> Function()? confirmAction;
  final Future<dynamic> Function()? errorDialogAction;
  final Future<dynamic> Function()? afterConfirmAction;
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
      key: const Key('key_confirmableaction_button'),
      onPressed: () async {
        final parentContext = context;
        bool result = false;
        if (confirmDialog) {
          // Step 1: Show confirmation dialog, wait for user response
          final shouldProceed = await showDialog<bool>(
            context: parentContext,
            barrierDismissible: true,
            builder:
                (context) => ConfirmationDialog(
                  key: const Key('key_confirmableaction_confirmation_dialog'),
                  title: confirmTitle!,
                  message: confirmMessage!,
                  confirmButtonText: confirmButtonText!,
                  cancelButtonText: cancelButtonText!,
                  onConfirm: () {
                    return Navigator.of(context).pop(true); // User confirmed
                  },
                ),
          );

          // Step 2: If user confirmed
          if (shouldProceed == true && confirmAction != null) {
            result = await confirmAction!();

            if (!result) {
              showDialog(
                context: parentContext,
                builder:
                    (context) => ErrorDialog(
                      key: const Key('key_confirmableaction_error_dialog'),
                      title: errorTitle,
                      message: errorMessage,
                      buttonText: errorButtonText,
                      onPressed: errorDialogAction,
                    ),
              );
            } else if (afterConfirmAction != null) {
              afterConfirmAction!();
            }
          }
        } else {
          // No confirmation dialog, run action directly
          if (confirmAction != null) {
            result = await confirmAction!();

            if (!result) {
              showDialog(
                context: parentContext,
                builder:
                    (context) => ErrorDialog(
                      key: const Key(
                        'key_confirmableaction_error_dialog_direct',
                      ),
                      title: errorTitle,
                      message: errorMessage,
                      buttonText: errorButtonText,
                      onPressed: errorDialogAction,
                    ),
              );
            } else if (afterConfirmAction != null) {
              afterConfirmAction!();
            }
          }
        }
      },
      child: Text(
        buttonText,
        key: const Key('key_confirmableaction_button_text'),
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
