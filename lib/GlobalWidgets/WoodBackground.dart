import 'package:flutter/material.dart';

class WoodBackground extends StatelessWidget {
  final Widget child;
  const WoodBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
