import 'package:cloud_firestore/cloud_firestore.dart';

class QRCodeService {
  final CollectionReference _codesCollection = FirebaseFirestore.instance
      .collection('qrCodes');

  //staff or admin create a new QR code entry in Firestore
  Future<String> createQRCode({required int points, String? label}) async {
    final doc = await _codesCollection.add({
      'points': points,
      'label': label ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'usedBy': [], //list of user IDs who have used this code
    });
    return doc.id; //to use the document ID as the QR code data
  }

  //validate and redeem a QR code for a user
  Future<int?> redeemQRCode({
    required String codeId,
    required String userId,
  }) async {
    final docRef = _codesCollection.doc(codeId);
    final doc = await docRef.get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    final usedBy = List<String>.from(data['usedBy'] ?? []);
    if (usedBy.contains(userId)) {
      //already used by this user
      return null;
    }
    final points = data['points'] as int?;
    if (points == null) return null;
    //mark as used by this user
    await docRef.update({
      'usedBy': FieldValue.arrayUnion([userId]),
    });
    return points;
  }
}
