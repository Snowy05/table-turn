import 'package:flutter/material.dart';

/// A full-width booking button with centered text and padding
class BookingButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final TextStyle? textStyle;

  const BookingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    this.color,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: padding,
            backgroundColor: color ?? theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style:
                textStyle ??
                theme.textTheme.titleMedium?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
