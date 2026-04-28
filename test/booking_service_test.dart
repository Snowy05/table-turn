import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
//using mock firestore to test booking service functions without needing a real database connection
import 'package:flutter_test/flutter_test.dart';
import 'package:tableturn_project0/Controller/BookingService.dart';
import 'package:tableturn_project0/Model/bookingModel.dart';

void main() {
  group('BookingService', () {
    late FakeFirebaseFirestore firestore;
    late BookingService service;
//setting up a fresh instance of the fake firestore and booking service before each test
    setUp(() {
      firestore = FakeFirebaseFirestore();
      service = BookingService(firestore: firestore);
    });

    BookingModel buildBooking() {
      final start = DateTime(2026, 4, 27, 14);
      return BookingModel(
        uid: '',
        userId: 'user-1',
        tableId: 'table1',
        boardGameId: 'game-1',
        bookingStartTime: start,
        bookingEndTime: start.add(const Duration(hours: 2)),
        numberOfPeople: 4,
        specialRequests: 'Quiet corner',
        status: 'pending',
        createdAt: DateTime(2026, 4, 27, 12),
      );
    }

    test('creates and retrieves bookings for a user', () async {
      final bookingId = await service.createBooking(buildBooking());

      final bookings = await service.getUserBookings('user-1');
      //here we check that the booking was created and can be retrieved with the righht  details
      expect(bookingId, isNotEmpty);
      expect(bookings, hasLength(1));
      expect(bookings.first.tableId, 'table1');
      expect(bookings.first.boardGameId, 'game-1');
    });

    test('updates booking status', () async {
      final bookingId = await service.createBooking(buildBooking());

      await service.updateBookingStatus(bookingId, 'confirmed');

      final snapshot = await firestore
          .collection('bookings')
          .doc(bookingId)
          .get();
      expect(snapshot.data()?['status'], 'confirmed');
    });
    test('deletes a booking', () async {
      //testing delete
      final bookingId = await service.createBooking(buildBooking());

      await service.deleteBooking(bookingId);

      final snapshot = await firestore
          .collection('bookings')
          .doc(bookingId)
          .get();
      expect(snapshot.exists, isFalse);
    });

    test('marks booking ended and returns boardgame stock', () async {
      final bookingId = await service.createBooking(buildBooking());
      await firestore.collection('boardgames').doc('game-1').set({
        'quantityInStock': 2,
      });

      await service.endBookingAndReturnBoardgame(bookingId, 'game-1');

      final bookingSnapshot = await firestore
          .collection('bookings')
          .doc(bookingId)
          .get();
      final gameSnapshot = await firestore
          .collection('boardgames')
          .doc('game-1')
          .get();

      expect(bookingSnapshot.data()?['status'], 'ended');
      expect(gameSnapshot.data()?['quantityInStock'], 3);
    });
  });
}
