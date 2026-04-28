import 'package:flutter_test/flutter_test.dart';
import 'package:tableturn_project0/Controller/FindYourGameService.dart';
import 'package:tableturn_project0/Model/findYourGameModels.dart';

BoardGame _game({
  required String name,
  required List<String> tags,
  required int minPlayers,
  required int maxPlayers,
  required List<String> playTimes,
}) {
  return BoardGame(
    name: name,
    description: '$name description',
    imageAsset: '$name.png',
    tags: tags,
    minPlayers: minPlayers,
    maxPlayers: maxPlayers,
    playTimes: playTimes,
  );
}

void main() {
  group('recommendGames', () {
    final games = [
      _game(
        name: 'Quick Party',
        tags: ['Party', 'Easy'],
        minPlayers: 2,
        maxPlayers: 6,
        playTimes: ['Under 30 Minutes'],
      ),
      _game(
        name: 'Long Strategy',
        tags: ['Strategy', 'Hard'],
        minPlayers: 2,
        maxPlayers: 4,
        playTimes: ['1-2 Hours'],
      ),
      _game(
        name: 'Big Group Party',
        tags: ['Party', 'Medium'],
        minPlayers: 5,
        maxPlayers: 10,
        playTimes: ['Under 30 Minutes'],
      ),
    ];

    test('matches player count, play time, and tags case-insensitively', () {
      final recommendations = recommendGames([
        [' 2P '],
        [' under 30 minutes '],
        ['PARTY'],
      ], games);

      expect(recommendations.map((game) => game.name), ['Quick Party']);
    });

    test('excludes games that do not match the selected player range', () {
      final recommendations = recommendGames([
        ['2p'],
        ['under 30 minutes'],
        ['party'],
      ], games);

      expect(
        recommendations.any((game) => game.name == 'Big Group Party'),
        isFalse,
      );
    });

    test('returns games that match longer play sessions', () {
      final recommendations = recommendGames([
        ['3-4p'],
        ['1-2 hours'],
        ['strategy'],
      ], games);

      expect(recommendations.map((game) => game.name), ['Long Strategy']);
    });
  });
}
