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
    // Robustly handle playTimes as List<String> or String
    List<String> playTimesList = [];
    final pt = data['playTimes'];
    if (pt is List) {
      playTimesList = pt.map((e) => e.toString()).toList();
    } else if (pt is String) {
      playTimesList = [pt];
    }
    return BoardGame(
      name: data['name'] ?? data['gameName'] ?? '',
      description: data['description'] ?? '',
      imageAsset: data['imageAsset'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      minPlayers: data['minPlayers'] ?? 1,
      maxPlayers: data['maxPlayers'] ?? 10,
      playTimes: playTimesList,
      tutorial: data['tutorial'] ?? '',
    );
  }).toList();
}

//returns a sorted list of recommended games from a given list
List<BoardGame> recommendGames(
  List<List<String>> selectedTags,
  List<BoardGame> games,
) {
  //convert all tags to lowercase and trim for case-insensitive, whitespace-robust matching
  final tags = selectedTags
      .expand((t) => t)
      .map((t) => t.trim().toLowerCase())
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
    //added robust tag processing for game tags as well
    final gameTags = game.tags.map((t) => t.trim().toLowerCase()).toSet();

    // Strict tag match (for tags not covered by fields)
    final strictMatches = strictTags
        .where((tag) => gameTags.contains(tag))
        .length;
    //more forgiving: at least one strict tag must match if any strict tags selected
    final strictOk = strictTags.isEmpty || strictMatches >= 1;

    // player count match (use minPlayers/maxPlayers)
    bool playerMatch = true;
    if (selectedPlayerCounts.isNotEmpty) {
      if (selectedPlayerCounts.contains('2p')) {
        playerMatch = game.minPlayers <= 2 && game.maxPlayers >= 2;
      } else if (selectedPlayerCounts.contains('3-4p')) {
        playerMatch = game.minPlayers <= 4 && game.maxPlayers >= 3;
      } else if (selectedPlayerCounts.contains('5p+')) {
        playerMatch = game.maxPlayers >= 5;
      }
    }

    // Age group match: allow match if tag OR (if available) ageGroups field matches
    bool ageMatch = true;
    if (selectedAgeGroups.isNotEmpty) {
      ageMatch = gameTags.intersection(selectedAgeGroups).isNotEmpty;
    }

    //plllay time match: use playTimes field (case-insensitive, whitespace-robust, supports multiple)
    bool playTimeMatch = true;
    final playTimeOptions = [
      'under 30 minutes',
      '30-60 minutes',
      '1-2 hours',
      'over 2 hours',
    ];
    final selectedPlayTimes = playTimeOptions
        .where((pt) => tags.contains(pt))
        .map((pt) => pt.trim().toLowerCase())
        .toSet();
    if (selectedPlayTimes.isNotEmpty) {
      final gamePlayTimes = game.playTimes
          .map((pt) => pt.trim().toLowerCase())
          .toSet();
      playTimeMatch = selectedPlayTimes.any((pt) => gamePlayTimes.contains(pt));
    }

    // Complexity match: allow match if tag OR (if available) complexity field matches
    bool complexityMatch = true;
    final complexityTags = {'Easy', 'Medium', 'Hard', 'Expert'};
    final selectedComplexities = tags.intersection(complexityTags);
    if (selectedComplexities.isNotEmpty) {
      complexityMatch = gameTags.intersection(selectedComplexities).isNotEmpty;
    }

    //relaxed: only require playerMatch and playTimeMatch, others are optional
    final match =
        playerMatch &&
        playTimeMatch &&
        (strictOk || ageMatch || complexityMatch);
    if (match) results.add(game);
  }
  return results;
}
