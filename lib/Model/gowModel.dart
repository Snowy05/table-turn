import 'package:cloud_firestore/cloud_firestore.dart';

class GowModel {
  final String uid;
  final String gameId;
  final String gameName;
  final String weekId;
  final DateTime startDate;
  final DateTime endDate;
  final String bannerUrl;
  final DateTime createdAt;

  GowModel({
    required this.uid,
    required this.gameId,
    required this.gameName,
    required this.weekId,
    required this.startDate,
    required this.endDate,
    required this.bannerUrl,
    required this.createdAt,
  });

  factory GowModel.fromMap(Map<String, dynamic> data, String documentId) {
    return GowModel(
      uid: documentId,
      gameId: documentId,
      gameName: data['gameName'] ?? '',
      weekId: data['weekId'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      bannerUrl: data['bannerUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,

      'gameName': gameName,
      'weekId': weekId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'bannerUrl': bannerUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
