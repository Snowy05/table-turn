import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/gameModel.dart';
import '../Model/Options/constants.dart' as options_constants;
import '../Model/bookingModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'TableAvailabilityService.dart' as table_availability;

class BookingHelpers {
  // Fetch available boardgames from Firestore
  static Future<List<GameModel>> fetchAvailableBoardgames() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('boardgames')
        .where('isAvailableForBooking', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => GameModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Get the slots needed for the booking duration
  static List<String> getSlotsForDuration(String startSlot, int duration) {
    final slotTimes = options_constants.defaultSlots;
    final startIdx = slotTimes.indexOf(startSlot);
    if (startIdx == -1) return [];
    return slotTimes.skip(startIdx).take(duration).toList();
  }

  // Fetch fullness for the next week
  static Future<Map<DateTime, double>> fetchFullnessForNextWeek(
    String? selectedTable,
  ) async {
    final Map<DateTime, double> result = {};
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final day = DateTime(now.year, now.month, now.day + i);
      final dateStr = day.toIso8601String().split('T')[0];
      final availableSlots = await table_availability.Tableavailabilityservice()
          .getAvailableSlots(dateStr, selectedTable ?? 'table1');
      final booked =
          options_constants.defaultSlots.length - availableSlots.length;
      final fullness = booked / options_constants.defaultSlots.length;
      result[DateTime(day.year, day.month, day.day)] = fullness;
    }
    return result;
  }

  // Booking submission logic (except UI feedback)
  static Future<String?> submitBooking({
    required BookingModel booking,
    required List<String> slotsNeeded,
    required String dateStr,
    required String tableId,
    String? boardGameId,
  }) async {
    try {
      // Create booking using BookingModel's toMap()
      await FirebaseFirestore.instance
          .collection('bookings')
          .add(booking.toMap());
      // Book slots
      for (final slot in slotsNeeded) {
        await table_availability.Tableavailabilityservice().bookSlot(
          dateStr,
          tableId,
          slot,
        );
      }
      // Decrement boardgame stock if needed
      if (boardGameId != null && boardGameId.isNotEmpty) {
        final gameRef = FirebaseFirestore.instance
            .collection('boardgames')
            .doc(boardGameId);
        await gameRef.update({'quantityInStock': FieldValue.increment(-1)});
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
