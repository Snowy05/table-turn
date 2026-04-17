import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isHighContrast =
        Theme.of(context).colorScheme.primary == Colors.black;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: isHighContrast ? Colors.black : null,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          label: 'Loyalty Card',
        ),
      ],
    );
  }
}
