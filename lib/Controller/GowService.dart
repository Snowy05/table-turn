import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/gowModel.dart';

// service for handling Game of the Week voting and results
class GowService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String votesCollection = 'votes';
  final String gowCollection = 'gow';

  //  vote for a game (one per user per week)
  Future<void> voteForGame({
    required String gameId,
    required String weekId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    final voteDoc = _db.collection(votesCollection).doc('${user.uid}_$weekId');
    await voteDoc.set({
      'userId': user.uid,
      'gameId': gameId,
      'weekId': weekId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  //check if user has already voted this week
  Future<bool> hasVotedThisWeek(String weekId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    final doc = await _db
        .collection(votesCollection)
        .doc('${user.uid}_$weekId')
        .get();
    return doc.exists;
  }

  //get the most-voted game for a week
  Future<String?> getMostVotedGame(String weekId) async {
    final snapshot = await _db
        .collection(votesCollection)
        .where('weekId', isEqualTo: weekId)
        .get();
    final votes = <String, int>{};
    for (var doc in snapshot.docs) {
      final gameId = doc['gameId'] as String;
      votes[gameId] = (votes[gameId] ?? 0) + 1; //if gameId is null, skip it
    }
    if (votes.isEmpty) return null;
    votes.removeWhere((key, value) => key == null); // Remove null keys if any to prevent errors
    return votes.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  //save the Game of the Week winner
  
  Future<void> setGameOfTheWeek({
    required String gameId,
    required String weekId,
  }) async {
    try {
      final doc = _db.collection(gowCollection).doc(weekId);
      await doc.set({
        'gameId': gameId,
        'weekId': weekId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('GOW document created: weekId=$weekId, gameId=$gameId');
    } catch (e) {
      print('Failed to create GOW document: $e');
      rethrow;
    }
  }

  //get the Game of the Week for a given week
  Future<GowModel?> getGameOfTheWeek(String weekId) async {
    final doc = await _db.collection(gowCollection).doc(weekId).get();
    if (!doc.exists) return null;
    return GowModel.fromMap(doc.data()!, doc.id);
  }
}
