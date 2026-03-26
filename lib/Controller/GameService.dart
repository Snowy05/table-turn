import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/gameModel.dart';

class Gameservice {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath = 'boardgames';

  // fitching all boardgames 
  Stream<List<GameModel>> getGames() {
    return _db
        .collection(collectionPath)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => GameModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
  Future<void> addGame(GameModel game) async {
    await _db.collection(collectionPath).add(game.toMap());
  }
}
