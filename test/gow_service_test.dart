import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tableturn_project0/Controller/GowService.dart';

void main() {
  group('GowService', () {
    late FakeFirebaseFirestore firestore;
    late MockFirebaseAuth auth;
    late GowService service;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'user-1', email: 'test@example.com'),
      );
      service = GowService(firestore: firestore, auth: auth);
    });

    test('stores a vote and reports that the user has voted', () async {
      await service.voteForGame(gameId: 'game-a', weekId: '2026-W17');

      expect(await service.hasVotedThisWeek('2026-W17'), isTrue);
    });

    test('returns the most voted game for a week', () async {
      await firestore.collection('votes').doc('user-1_2026-W17').set({
        'userId': 'user-1',
        'gameId': 'game-a',
        'weekId': '2026-W17',
      });
      await firestore.collection('votes').doc('user-2_2026-W17').set({
        'userId': 'user-2',
        'gameId': 'game-a',
        'weekId': '2026-W17',
      });
      await firestore.collection('votes').doc('user-3_2026-W17').set({
        'userId': 'user-3',
        'gameId': 'game-b',
        'weekId': '2026-W17',
      });

      final winner = await service.getMostVotedGame('2026-W17');

      expect(winner, 'game-a');
    });

    test('saves and retrieves the game of the week', () async {
      await service.setGameOfTheWeek(gameId: 'game-c', weekId: '2026-W18');

      final result = await service.getGameOfTheWeek('2026-W18');

      expect(result, isNotNull);
      expect(result!.gameId, 'game-c');
      expect(result.weekId, '2026-W18');
    });
  });
}
