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
  final tags = selectedTags.expand((t) => t).toList();
  final scored = games.map((game) {
    final matchCount = game.tags.where((tag) => tags.contains(tag)).length;
    return MapEntry(game, matchCount);
  }).toList();
  scored.sort((a, b) => b.value.compareTo(a.value));
  return scored.where((e) => e.value > 0).map((e) => e.key).toList();
}
