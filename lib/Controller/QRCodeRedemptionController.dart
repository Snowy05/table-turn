import 'package:firebase_auth/firebase_auth.dart';
import 'QRCodeService.dart';
import 'LoyaltyService.dart';

class QRCodeRedemptionController {
  final QRCodeService _qrCodeService = QRCodeService();
//takes scanned code id redeems it and adds points to user if valid returns points added or null if invalid
  Future<int?> redeemScannedCode(String codeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    final points = await _qrCodeService.redeemQRCode(
      codeId: codeId,
      userId: user.uid,
    );
    if (points != null && points > 0) {
      await LoyaltyService().addPoints(points);
    }
    return points;
  }
}
