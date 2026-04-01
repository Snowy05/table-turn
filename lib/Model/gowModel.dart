import 'package:cloud_firestore/cloud_firestore.dart';

// model for voting each week for the game of the week
class GowModel {
  final String uid;
  final String gameId;
  final String weekId;
  final String WeekId;
  final DateTime createdAt;

  GowModel({
    required this.uid,
    required this.gameId,
    required this.weekId,
    required this.WeekId,
    required this.createdAt,
  });

  factory GowModel.fromMap(Map<String, dynamic> data, String documentId) {
    return GowModel(
      uid: documentId,
      gameId: documentId,
      weekId: data['weekId'] ?? '',
      WeekId: data['WeekId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,

      'weekId': weekId,
      'WeekId': WeekId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
