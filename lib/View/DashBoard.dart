import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tableturn_project0/GlobalWidgets/BottomNav.dart';
import 'package:tableturn_project0/GlobalWidgets/WidgetMenuBttn.dart';
import 'package:tableturn_project0/Model/userModel.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),

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
                  WidgetMenubttn(
                    label: 'View Board Games',
                    imageAsset: 'assets/images/minimalistboardgame d.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/boardgames');
                    },
                  ),
                  WidgetMenubttn(
                    label: 'Book a Table',
                    imageAsset: 'assets/images/minimalistBook.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/bookings');
                    },
                  ),
                  WidgetMenubttn(
                    label: 'View Menu',
                    imageAsset: 'assets/images/minimalistMenuD.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/menu');
                    },
                  ),
                  WidgetMenubttn(
                    label: 'Vote for Game of the Week',
                    imageAsset: 'assets/images/gow.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/gow');
                    },
                  ),
                  WidgetMenubttn(
                    label: 'View Game of the Week',
                    imageAsset: 'assets/images/friesMenu.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/gowresults');
                    },
                  ),
                  WidgetMenubttn(
                    label: 'qr code',
                    imageAsset: 'assets/images/hamburgerMenu.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/qr');
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
