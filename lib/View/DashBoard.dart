import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tableturn_project0/GlobalWidgets/BottomNav.dart';
import 'package:tableturn_project0/GlobalWidgets/DashLongButton.dart';
import 'package:tableturn_project0/GlobalWidgets/dice_roll_loading.dart';

import 'package:tableturn_project0/Controller/app_localizations.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If the user is not logged in, show a message or redirect to login page
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return SizedBox.shrink(); // Return an empty widget while redirecting
    }
    // DEBUG: Button to add all sample games to Firestore
    // Widget debugAddGameButton = Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 12.0),
    //   child: ElevatedButton.icon(
    //     icon: const Icon(Icons.add_box),
    //     label: const Text('DEBUG: Add All Sample Games'),
    //     onPressed: () async {
    //       int added = 0;
    //       for (final game in boardgameSamples) {
    //         await FirebaseFirestore.instance.collection('boardgames').add(game);
    //         added++;
    //       }
    //       ScaffoldMessenger.of(
    //         context,
    //       ).showSnackBar(SnackBar(content: Text('$added sample games added!')));
    //     },
    //   ),
    // );
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.red),
          tooltip: 'Log out',
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
        ),
        title: Text(localizations.get('dashboard')),
      ),

      // Fetch user data from Firestore and display it in this case name
      // could have used .select() but firebase does not support it yet, so we fetch the whole
      //document and use only the name field, this is not ideal but it works for now, will need to be optimized
      //in the future when firebase supports .select() or we switch to another database that supports it
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DiceRollLoadingScreen(message: 'Loading dashboard...');
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return Center(child: Text('Failed to load user data'));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Center(child: Text('Welcome, ${appUser.name}!')),
                  const SizedBox(height: 20),

                  // Rectangle: Boardgames
                  DashLongButton(
                    label: localizations.get('boardgames'),
                    imageAsset: 'assets/images/boardgameCard.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/boardgames');
                    },
                    size: 120,
                    height: 250,
                  ),
                  const SizedBox(height: 16),

                  // Square: Menu, Find Your Game (same as other rows)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: DashLongButton(
                          label: localizations.get('menu'),
                          imageAsset: 'assets/images/menu.png',
                          onTap: () {
                            Navigator.pushNamed(context, '/menu');
                          },
                          size: 160,
                          height: 260,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DashLongButton(
                          label: localizations.get('findYourGame'),
                          imageAsset: 'assets/images/questionnaire.png',
                          onTap: () {
                            Navigator.pushNamed(context, '/findyourgame');
                          },
                          size: 160,
                          height: 260,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Rectangle: Book
                  DashLongButton(
                    label: localizations.get('bookNow'),
                    imageAsset: 'assets/images/booknow.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/bookings');
                    },
                    size: 120,
                    height: 250,
                  ),
                  const SizedBox(height: 16),

                  // Square: Settings, My bookings
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: DashLongButton(
                          label: localizations.get('settings'),
                          imageAsset: 'assets/images/settings.png',
                          onTap: () {
                            Navigator.pushNamed(context, '/settings');
                          },
                          size: 160,
                          height: 260,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DashLongButton(
                          label: localizations.get('mybookings'),
                          imageAsset: 'assets/images/mybooking.png',
                          onTap: () {
                            Navigator.pushNamed(context, '/mybookings');
                          },
                          size: 160,
                          height: 260,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Square: gow vote, gow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: DashLongButton(
                          label: localizations.get('votegow'),
                          imageAsset: 'assets/images/vote.png',
                          onTap: () {
                            Navigator.pushNamed(context, '/gow');
                          },
                          size: 160,
                          height: 260,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DashLongButton(
                          label: localizations.get('gameOfWeek'),
                          imageAsset: 'assets/images/gameoftheweek.png',
                          onTap: () {
                            Navigator.pushNamed(context, '/gowresults');
                          },
                          size: 160,
                          height: 260,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex:
            1, //current index to the dashboard //-1 will need to be used on not related pages, may cause issues if not handled properly
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/bookings');
              break;
            case 1:
              // Already on dashboard, do nothing
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/loyalty');
              break;
          }
        },
      ),
    );
  }
}
