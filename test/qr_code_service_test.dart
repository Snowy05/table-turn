import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tableturn_project0/Controller/QRCodeService.dart';

void main() {
  group('QRCodeService', () {
    late FakeFirebaseFirestore firestore;
    late QRCodeService service;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      service = QRCodeService(firestore: firestore);
    });

    test('creates a QR code with initial metadata', () async {
      final codeId = await service.createQRCode(points: 25, label: 'Welcome');

      final snapshot = await firestore.collection('qrCodes').doc(codeId).get();

      expect(codeId, isNotEmpty);
      expect(snapshot.data()?['points'], 25);
      expect(snapshot.data()?['label'], 'Welcome');
      expect(snapshot.data()?['usedBy'], isEmpty);
    });

    test('redeems a valid code once per user', () async {
      await firestore.collection('qrCodes').doc('code-1').set({
        'points': 15,
        'label': 'Easter Egg',
        'usedBy': <String>[],
      });

      final firstRedemption = await service.redeemQRCode(
        codeId: 'code-1',
        userId: 'user-1',
      );
      final secondRedemption = await service.redeemQRCode(
        codeId: 'code-1',
        userId: 'user-1',
      );
      final snapshot = await firestore
          .collection('qrCodes')
          .doc('code-1')
          .get();

      expect(firstRedemption, 15);
      expect(secondRedemption, isNull);
      expect(snapshot.data()?['usedBy'], contains('user-1'));
    });

    test('returns null for a missing QR code', () async {
      final result = await service.redeemQRCode(
        codeId: 'missing-code',
        userId: 'user-1',
      );

      expect(result, isNull);
    });
  });
}
