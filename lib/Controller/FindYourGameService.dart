import '../Model/findYourGameModels.dart';
import '../Model/Options/findYourGameQuestions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//fetch board games from Firestore and map to BoardGame model
Future<List<BoardGame>> fetchBoardGamesFromFirestore() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('boardgames')
      .get();
  return snapshot.docs.map((doc) {
    final data = doc.data();
    return BoardGame(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageAsset: data['imageAsset'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
    );
  }).toList();
}

//returns a sorted list of recommended games from a given list
List<BoardGame> recommendGames(
  List<List<String>> selectedTags,
  List<BoardGame> games,
) {
  // Convert all tags to lowercase for case-insensitive matching
  final tags = selectedTags
      .expand((t) => t)
      .map((t) => t.toLowerCase())
      .toSet();

  // Define which tags are considered player count and age group (lowercase)
  const playerCountTags = {'2p', '3-4p', '5p+'};
  const ageGroupTags = {'kids', 'teens', 'adults', 'family'};

  // Separate selected tags
  final selectedPlayerCounts = tags.intersection(playerCountTags);
  final selectedAgeGroups = tags.intersection(ageGroupTags);
  final strictTags = tags.difference(playerCountTags).difference(ageGroupTags);

  final results = <BoardGame>[];
  for (final game in games) {
    final gameTags = game.tags.map((t) => t.toLowerCase()).toSet();

    // For BoardGame, we only have tags, but if you use GameModel, you can add:
    // final gameAgeGroups = (game.ageGroups ?? []).map((t) => t.toLowerCase()).toSet();
    // final gamePlayTimes = (game.playTimes ?? []).map((t) => t.toLowerCase()).toSet();
    // final gameComplexity = (game.complexity ?? '').toLowerCase();

    // Strict tag match (for tags not covered by fields)
    final strictMatches = strictTags
        .where((tag) => gameTags.contains(tag))
        .length;
    final strictOk =
        strictTags.isEmpty || strictMatches >= (strictTags.length - 1);

    // Player count match (tags only)
    final playerMatch =
        selectedPlayerCounts.isEmpty ||
        gameTags.intersection(selectedPlayerCounts).isNotEmpty;

    // Age group match: allow match if tag OR (if available) ageGroups field matches
    bool ageMatch = true;
    if (selectedAgeGroups.isNotEmpty) {
      // Try to match via tags (BoardGame)
      ageMatch = gameTags.intersection(selectedAgeGroups).isNotEmpty;
      // If you use GameModel, also check ageGroups field:
      // ageMatch = ageMatch || gameAgeGroups.intersection(selectedAgeGroups).isNotEmpty;
    }

    // Play time match: allow match if tag OR (if available) playTimes field matches
    bool playTimeMatch = true;
    final playTimeTags = {
      'under 30 minutes',
      '30-60 minutes',
      '1-2 hours',
      'over 2 hours',
      'medium',
    };
    final selectedPlayTimes = tags.intersection(playTimeTags);
    if (selectedPlayTimes.isNotEmpty) {
      playTimeMatch = gameTags.intersection(selectedPlayTimes).isNotEmpty;
      // If you use GameModel, also check playTimes field:
      // playTimeMatch = playTimeMatch || gamePlayTimes.intersection(selectedPlayTimes).isNotEmpty;
    }

    // Complexity match: allow match if tag OR (if available) complexity field matches
    bool complexityMatch = true;
    final complexityTags = {'easy', 'medium', 'hard', 'expert'};
    final selectedComplexities = tags.intersection(complexityTags);
    if (selectedComplexities.isNotEmpty) {
      complexityMatch = gameTags.intersection(selectedComplexities).isNotEmpty;
      // If you use GameModel, also check complexity field:
      // complexityMatch = complexityMatch || selectedComplexities.contains(gameComplexity);
    }

    final match =
        strictOk && playerMatch && ageMatch && playTimeMatch && complexityMatch;
    if (match) results.add(game);
  }
  return results;
}
