import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String uid;
  final String userId;
  final String tableId;
  final DateTime bookingStartTime;
  final DateTime bookingEndTime;
  final int numberOfPeople;
  final String specialRequests;
  final String status;
  final DateTime createdAt;

  Booking({
    required this.uid,
    required this.userId,
    required this.tableId,
    required this.bookingStartTime,
    required this.bookingEndTime,
    required this.numberOfPeople,
    required this.specialRequests,
    required this.status,
    required this.createdAt,
  }) : assert(userId.isNotEmpty, 'userId cannot be empty'),
        assert(tableId.isNotEmpty, 'tableId cannot be empty'),
        assert(bookingStartTime.isBefore(bookingEndTime), 'bookingStartTime must be before bookingEndTime'),
        assert(numberOfPeople > 0, 'numberOfPeople must be greater than 0'),
        assert(status == 'pending' || status == 'confirmed' || status == 'cancelled', 'status must be one of: pending, confirmed, cancelled');

  factory Booking.fromMap(Map<String, dynamic> data, String documentId) {
    return Booking(
      uid: documentId,
      userId: data['userId'] ?? '',
      tableId: data['tableId'] ?? '',
      bookingStartTime: (data['bookingStartTime'] as Timestamp).toDate(),
      bookingEndTime: (data['bookingEndTime'] as Timestamp).toDate(),
      numberOfPeople: data['numberOfPeople'] ?? 0,
      specialRequests: data['specialRequests'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
    
  }
  Map <String, dynamic> toMap() {
    return {
      'bookingStartTime': bookingStartTime,
      'bookingEndTime': bookingEndTime,
      'numberOfPeople': numberOfPeople,
      'specialRequests': specialRequests,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
