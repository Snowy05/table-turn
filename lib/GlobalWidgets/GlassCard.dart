import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double heightFactor;
  const GlassCard({super.key, required this.child, this.heightFactor = 0.5});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isHighContrast =
        Theme.of(context).colorScheme.primary == Colors.black;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: isHighContrast ? Colors.black : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size.width * 0.1),
            topRight: Radius.circular(size.width * 0.1),
            bottomLeft: const Radius.circular(0),
            bottomRight: const Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 0),
          child: IntrinsicHeight(child: child),
        ),
      ),
    );
  }
}
