import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoyaltyService {
  LoyaltyService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  //add   a reward to the current users rewards list
  Future<void> addRewardToUser(String rewardId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final userRef = _firestore.collection('users').doc(user.uid);
    await userRef.update({
      'rewards': FieldValue.arrayUnion([rewardId]),
    });
  }

  //stream the full user document for real-time updates (name, points, etc)
  Stream<Map<String, dynamic>?> userStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    final userRef = _firestore.collection('users').doc(user.uid);
    return userRef.snapshots().map((snap) => snap.data());
  }

  //add points to the current user
  Future<void> addPoints(int points) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final userRef = _firestore.collection('users').doc(user.uid);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final currentPoints = (snapshot['loyaltyPoints'] ?? 0) as int;
      if (points > 1000 || points < 0) {
        throw Exception('Problem occured please contact support');
      }
      transaction.update(userRef, {'loyaltyPoints': currentPoints + points});
    });
  }

  //take points from the current user (for redeeming rewards)
  Future<void> takePoints(int points) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final userRef = _firestore.collection('users').doc(user.uid);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final currentPoints = (snapshot['loyaltyPoints'] ?? 0) as int;
      if (currentPoints < points) {
        throw Exception('Not enough points');
      }
      if (currentPoints - points < 0) {
        throw Exception('Not enough points');
      }
      transaction.update(userRef, {'loyaltyPoints': currentPoints - points});
    });
  }

  //set points directly (admin or reset and testing purposes)
  Future<void> setPoints(int points) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final userRef = _firestore.collection('users').doc(user.uid);
    await userRef.update({'loyaltyPoints': points});
  }

  //get current user's points (one-time fetch)
  Future<int> getPoints() async {
    final user = _auth.currentUser;
    if (user == null) return 0;
    final userRef = _firestore.collection('users').doc(user.uid);
    final snapshot = await userRef.get();
    return (snapshot['loyaltyPoints'] ?? 0) as int;
  }

  //listen to points changes (for real-time UI updates)
  Stream<int> pointsStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    final userRef = _firestore.collection('users').doc(user.uid);
    return userRef.snapshots().map(
      (snap) => (snap['loyaltyPoints'] ?? 0) as int,
    );
  }
}
