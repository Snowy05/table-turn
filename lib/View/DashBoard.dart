import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tableturn_project0/GlobalWidgets/BottomNav.dart';
import 'package:tableturn_project0/GlobalWidgets/WidgetMenuBttn.dart';
import 'package:tableturn_project0/Model/boardgame_samples.dart';
import 'package:tableturn_project0/Model/userModel.dart';
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
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return Center(child: Text('Failed to load user data'));
          }
          final appUser = AppUser.fromMap(
            snapshot.data!.data() as Map<String, dynamic>,
            snapshot.data!.id,
          );

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: Text('Welcome, ${appUser.name}!')),
                  SizedBox(height: 20),
                  // debugAddGameButton, // Uncomment this line to show the debug button for adding sample games to Firestore
                  WidgetMenubttn(
                    label:
                        localizations.get('boardgames') ?? 'View Board Games',
                    imageAsset: 'assets/images/minimalistboardgamed.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/boardgames');
                    },
                  ),
                  WidgetMenubttn(
                    label: localizations.get('bookings') ?? 'Book a Table',
                    imageAsset: 'assets/images/minimalistBook.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/bookings');
                    },
                  ),
                  WidgetMenubttn(
                    label: localizations.get('menu') ?? 'View Menu',
                    imageAsset: 'assets/images/minimalistMenuD.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/menu');
                    },
                  ),
                  WidgetMenubttn(
                    label:
                        localizations.get('gameOfWeek') ??
                        'Vote for Game of the Week',
                    imageAsset: 'assets/images/gow.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/gow');
                    },
                  ),
                  WidgetMenubttn(
                    label:
                        localizations.get('gameOfWeek') ??
                        'View Game of the Week',
                    imageAsset: 'assets/images/friesMenu.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/gowresults');
                    },
                  ),
                  WidgetMenubttn(
                    label: localizations.get('qr') ?? 'qr code',
                    imageAsset: 'assets/images/hamburgerMenu.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/qr');
                    },
                  ),
                  WidgetMenubttn(
                    label:
                        localizations.get('findYourGame') ?? 'Find Your Game',
                    imageAsset: 'assets/images/questionnaire.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/findyourgame');
                    },
                  ),
                  WidgetMenubttn(
                    label: localizations.get('settings') ?? 'Settings',
                    imageAsset: 'assets/images/profileMenu.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  WidgetMenubttn(
                    label: localizations.get('mybookings') ?? 'My Bookings',
                    imageAsset: 'assets/images/profileMenu.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/mybookings');
                    },
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
