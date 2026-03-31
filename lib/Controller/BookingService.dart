import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/bookingModel.dart';

class BookingService {
  final CollectionReference bookingsCollection = FirebaseFirestore.instance
      .collection('bookings');
//CRUD operations for bookings
  Future<String> createBooking(BookingModel booking) async {
    final docRef = await bookingsCollection.add({
      'userId': booking.userId,
      'tableId': booking.tableId,
      'boardGameId': booking.boardGameId,
      'bookingStartTime': booking.bookingStartTime,
      'bookingEndTime': booking.bookingEndTime,
      'numberOfPeople': booking.numberOfPeople,
      'specialRequests': booking.specialRequests,
      'status': booking.status,
      'createdAt': booking.createdAt,
    });
    return docRef.id;
  }

  Future<List<BookingModel>> getUserBookings(String userId) async {
    final query = await bookingsCollection
        .where('userId', isEqualTo: userId)
        .get();
    return query.docs
        .map(
          (doc) =>
              BookingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await bookingsCollection.doc(bookingId).update({'status': status});
  }

  Future<void> deleteBooking(String bookingId) async {
    await bookingsCollection.doc(bookingId).delete();
  }
}
