import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Model/bookingModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  const BookingCard({
    Key? key,
    required this.booking,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  Future<String> _fetchBoardGameName(String boardGameId) async {
    if (boardGameId == 'No boardgame' || boardGameId.isEmpty) return '-';
    final doc = await FirebaseFirestore.instance
        .collection('boardgames')
        .doc(boardGameId)
        .get();
    if (doc.exists && doc.data() != null && doc.data()!['gameName'] != null) {
      return doc.data()!['gameName'] as String;
    }
    return '-';
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormat = DateFormat('HH:mm');
    final String date = dateFormat.format(booking.bookingStartTime);
    final String start = timeFormat.format(booking.bookingStartTime);
    final String end = timeFormat.format(booking.bookingEndTime);
    final int guests = booking.numberOfPeople;
    final bool isActive = booking.bookingEndTime.isAfter(DateTime.now());
    return Card(
      color: Colors.grey[50], // much lighter background
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.black, width: 2),
      ),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.event,
                size: 36,
                color: isActive ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$date  $start - $end',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Guests: $guests',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<String>(
                      future: _fetchBoardGameName(booking.boardGameId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Boardgame: ...');
                        }
                        return Text(
                          'Boardgame: ${snapshot.data ?? '-'}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green[50]
                          : Colors.grey[100], // lighter badge
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isActive ? 'Active' : 'Expired',
                      style: TextStyle(
                        color: isActive ? Colors.green[800] : Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete booking',
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
