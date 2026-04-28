import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tableturn_project0/Controller/LoyaltyService.dart';

void main() {
  group('LoyaltyService', () {
    late FakeFirebaseFirestore firestore;
    late MockFirebaseAuth auth;
    late LoyaltyService service;

    setUp(() async {
      firestore = FakeFirebaseFirestore();
      // Setting up a mock authenticated user and a user document in firestore for the loyalty service tests
      auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'user-1', email: 'test@example.com'),
      );
      await firestore.collection('users').doc('user-1').set({
        'loyaltyPoints': 10,
        'rewards': <String>[],
      });
      service = LoyaltyService(firestore: firestore, auth: auth);
    });

    test('adds points to the current user', () async {
      await service.addPoints(15);
      //checking that points added correctly

      expect(await service.getPoints(), 25);
    });

    test('takes points from the current user', () async {
      await service.takePoints(4);

      expect(await service.getPoints(), 6);
    });

    test('throws when taking more points than available', () async {
      expect(() => service.takePoints(100), throwsException);
    });

    test('throws when adding an invalid amount of points', () async {
      expect(() => service.addPoints(1001), throwsException);
      expect(() => service.addPoints(-1), throwsException);
    });

    test('adds a reward to the user document', () async {
      await service.addRewardToUser('reward-1');
      //Checking that the reward was added to the users rewards list 

      final snapshot = await firestore.collection('users').doc('user-1').get();
      expect(snapshot.data()?['rewards'], contains('reward-1'));
    });
  });
}
