import 'package:flutter/material.dart';
import 'package:tableturn_project0/Controller/app_localizations.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isHighContrast =
        Theme.of(context).colorScheme.primary == Colors.black;
    final localizations = AppLocalizations.of(context)!;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: isHighContrast ? Colors.black : null,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.book),
          label: localizations.get('bookings'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: localizations.get('home'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: localizations.get('profile'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.card_giftcard),
          label: localizations.get('loyalty'),
        ),
      ],
    );
  }
}
