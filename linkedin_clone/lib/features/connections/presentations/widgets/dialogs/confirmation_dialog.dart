// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmButtonText,
    required this.cancelButtonText,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: const Key('key_confirmationdialog_dialog'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: Padding(
        key: const Key('key_confirmationdialog_padding'),
        padding: const EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 10.0,
          bottom: 10.0,
        ),
        child: Column(
          key: const Key('key_confirmationdialog_column'),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              key: const Key('key_confirmationdialog_title_text'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              key: Key('key_confirmationdialog_spacer1'),
              height: 10,
            ),
            Text(
              message,
              key: const Key('key_confirmationdialog_message_text'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              key: Key('key_confirmationdialog_spacer2'),
              height: 14,
            ),
            Row(
              key: const Key('key_confirmationdialog_buttons_row'),
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  key: const Key('key_confirmationdialog_cancel_button'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    cancelButtonText,
                    key: const Key('key_confirmationdialog_cancel_text'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(
                  key: const Key('key_confirmationdialog_confirm_button'),
                  onPressed: () {
                    onConfirm();
                  },
                  child: Text(
                    confirmButtonText,
                    key: const Key('key_confirmationdialog_confirm_text'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
