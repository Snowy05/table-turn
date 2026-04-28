import 'package:flutter/material.dart';

class FriendlyMessageDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final IconData icon;
  final Color iconColor;
  final String secondaryActionLabel;
  final VoidCallback? onSecondaryPressed;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryPressed;

  const FriendlyMessageDialog({
    super.key,
    required this.title,
    required this.content,
    this.icon = Icons.info_rounded,
    this.iconColor = Colors.brown,
    this.secondaryActionLabel = 'Close',
    this.onSecondaryPressed,
    this.primaryActionLabel,
    this.onPrimaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 10),
          Expanded(child: Text(title)),
        ],
      ),
      content: content,
      actions: [
        TextButton(
          onPressed: onSecondaryPressed ?? () => Navigator.of(context).pop(),
          child: Text(secondaryActionLabel),
        ),
        if (primaryActionLabel != null && onPrimaryPressed != null)
          ElevatedButton(
            onPressed: onPrimaryPressed,
            child: Text(primaryActionLabel!),
          ),
      ],
    );
  }
}
