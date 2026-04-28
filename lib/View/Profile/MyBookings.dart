import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tableturn_project0/Controller/BookingService.dart';
import 'package:tableturn_project0/GlobalWidgets/FriendlyMessageDialog.dart';
import 'package:tableturn_project0/View/Profile/BookingCard.dart';
import 'package:tableturn_project0/Model/bookingModel.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  bool showActive = true;
  bool dateAsc = false;

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFFFBA97)],
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
            var bookings = snapshot.data ?? [];
            debugPrint('Fetched bookings count: \\${bookings.length}'); // DEBUG
            if (bookings.isEmpty) {
              return Center(
                child: Text('No bookings found for userId: \\${user.uid}'),
              );
            }

            // Filter by active/expired
            final now = DateTime.now();
            bookings = bookings
                .where(
                  (b) => showActive
                      ? b.bookingEndTime.isAfter(now)
                      : b.bookingEndTime.isBefore(now),
                )
                .toList();

            // Sort by date
            bookings.sort(
              (a, b) => dateAsc
                  ? a.bookingStartTime.compareTo(b.bookingStartTime)
                  : b.bookingStartTime.compareTo(a.bookingStartTime),
            );

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            _SegmentButton(
                              text: 'Active',
                              selected: showActive,
                              onTap: () => setState(() => showActive = true),
                            ),
                            _SegmentButton(
                              text: 'Expired',
                              selected: !showActive,
                              onTap: () => setState(() => showActive = false),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            dateAsc = !dateAsc;
                          });
                        },
                        icon: Icon(
                          dateAsc ? Icons.arrow_upward : Icons.arrow_downward,
                        ),
                        label: const Text('Date'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return BookingCard(
                        booking: booking,
                        onTap: () {
                          // Optionally handle tap
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => FriendlyMessageDialog(
                              title: 'Delete Booking',
                              icon: Icons.warning_amber_rounded,
                              iconColor: Colors.redAccent,
                              secondaryActionLabel: 'Cancel',
                              onSecondaryPressed: () =>
                                  Navigator.of(ctx).pop(false),
                              primaryActionLabel: 'Delete',
                              onPrimaryPressed: () =>
                                  Navigator.of(ctx).pop(true),
                              content: const Text(
                                'Are you sure you want to delete this booking? This cannot be undone.',
                              ),
                            ),
                          );
                          if (confirm == true) {
                            await BookingService().deleteBooking(booking.uid);
                            setState(() {}); // Refresh list
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Booking deleted.')),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _SegmentButton({
    required this.text,
    required this.selected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.black87,
          ),
        ),
      ),
    );
  }
}
