import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String uid;
  final String userId;
  final String tableId;
  final String boardGameId;
  final DateTime bookingStartTime;
  final DateTime bookingEndTime;
  final int numberOfPeople;
  final String specialRequests;
  final String status;
  final DateTime createdAt;

  BookingModel({
    required this.uid,
    required this.userId,
    required this.tableId,
    required this.boardGameId,
    required this.bookingStartTime,
    required this.bookingEndTime,
    required this.numberOfPeople,
    required this.specialRequests,
    required this.status,
    required this.createdAt,
  }) : assert(userId.isNotEmpty, 'userId cannot be empty'),
       assert(tableId.isNotEmpty, 'tableId cannot be empty'),
       assert(
         bookingStartTime.isBefore(bookingEndTime),
         'bookingStartTime must be before bookingEndTime',
       ),
       assert(numberOfPeople > 0, 'numberOfPeople must be greater than 0'),
       assert(
         // for future, right now we wont use the status field
         status == 'pending' || status == 'confirmed' || status == 'cancelled',
         'status must be one of: pending, confirmed, cancelled',
       );

  factory BookingModel.fromMap(Map<String, dynamic> data, String documentId) {
    final boardGameId = (data['boardGameId'] ?? '').toString();
    return BookingModel(
      uid: documentId,
      userId: data['userId'] ?? '',
      tableId: data['tableId'] ?? '',
      boardGameId: boardGameId.isEmpty ? 'No boardgame' : boardGameId,
      bookingStartTime: (data['bookingStartTime'] as Timestamp).toDate(),
      bookingEndTime: (data['bookingEndTime'] as Timestamp).toDate(),
      numberOfPeople: data['numberOfPeople'] ?? 1,
      specialRequests: data['specialRequests'] ?? 'None',
      status: data['status'] ?? 'Pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tableId': tableId,
      'boardGameId': boardGameId,
      'bookingStartTime': bookingStartTime,
      'bookingEndTime': bookingEndTime,
      'numberOfPeople': numberOfPeople,
      'specialRequests': specialRequests,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
