import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double heightFactor;
  const GlassCard({super.key, required this.child, this.heightFactor = 0.5});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: size.width,
        height: size.height * heightFactor,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size.width * 0.2),
            topRight: Radius.circular(size.width * 0.2),
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
        child: child,
      ),
    );
  }
}
