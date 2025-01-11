import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  final Widget child; // The content of the modal
  final String title;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const CustomModal({
    super.key,
    required this.child,
    required this.title,
    this.onCancel,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: child,
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
