import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tableturn_project0/Controller/BookingService.dart';
import 'package:tableturn_project0/View/Profile/BookingCard.dart';
import 'package:tableturn_project0/Model/bookingModel.dart';

class MyBookings extends StatelessWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Not logged in'));
    }
    debugPrint('Current user UID: \\${user.uid}'); // DEBUG
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: Container(
        decoration: 
        const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [           
             Color(0xFFFFFFFF), 

            Color(0xFFFFBA97), 
          ],
        ),
      ),
        child: FutureBuilder<List<BookingModel>>(
          future: BookingService().getUserBookings(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Failed to load bookings: \\${snapshot.error}'),
              );
            }
            final bookings = snapshot.data ?? [];
            debugPrint('Fetched bookings count: \\${bookings.length}'); // DEBUG
            if (bookings.isEmpty) {
              return Center(
                child: Text('No bookings found for userId: \\${user.uid}'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return BookingCard(
                  booking: bookings[index],
                  onTap: () {
                    // Optionally handle tap
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
