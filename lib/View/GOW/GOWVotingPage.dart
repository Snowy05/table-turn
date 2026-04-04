import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Controller/GowService.dart';
import '../../Model/gameModel.dart';

class GOWVotingPage extends StatefulWidget {
  const GOWVotingPage({Key? key}) : super(key: key);

  @override
  State<GOWVotingPage> createState() => _GOWVotingPageState();
}

class _GOWVotingPageState extends State<GOWVotingPage> {
  late Future<List<GameModel>> _gamesFuture;
  bool _hasVoted = false;
  String? _selectedGameId;
  GameModel? _votedGame;
  bool _loading = false;
  String? _voteMessage;

  String getCurrentWeekId() {
    final now = DateTime.now();
    final week = ((now.day - 1) ~/ 7) + 1;
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-W$week';
  }

  @override
  void initState() {
    super.initState();
    _gamesFuture = _fetchGames();
    _checkIfVoted();
  }

  Future<List<GameModel>> _fetchGames() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('boardgames')
        .get();
    return snapshot.docs
        .map((doc) => GameModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> _checkIfVoted() async {
    final weekId = getCurrentWeekId();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _hasVoted = false;
        _votedGame = null;
      });
      return;
    }
    final voteDoc = await FirebaseFirestore.instance
        .collection('votes')
        .doc('${user.uid}_$weekId')
        .get();
    if (voteDoc.exists) {
      final gameId = voteDoc['gameId'] as String?;
      if (gameId != null) {
        final games = await _gamesFuture;
        final votedGame = games.where((g) => g.uid == gameId).isNotEmpty
            ? games.firstWhere((g) => g.uid == gameId)
            : null;
        setState(() {
          _hasVoted = true;
          _votedGame = votedGame;
        });
      } else {
        setState(() {
          _hasVoted = true;
          _votedGame = null;
        });
      }
    } else {
      setState(() {
        _hasVoted = false;
        _votedGame = null;
      });
    }
  }

  Future<void> _vote() async {
    if (_selectedGameId == null) return;
    setState(() {
      _loading = true;
      _voteMessage = null;
    });
    final weekId = getCurrentWeekId();
    try {
      await GowService().voteForGame(gameId: _selectedGameId!, weekId: weekId);
      // find the voted game from the loaded games (safe nullable logic)
      final games = await _gamesFuture;
      final votedGame = games.where((g) => g.uid == _selectedGameId).isNotEmpty
          ? games.firstWhere((g) => g.uid == _selectedGameId)
          : null;
      setState(() {
        _hasVoted = true;
        _voteMessage = 'Vote submitted!';
        _votedGame = votedGame;
        _selectedGameId = null; // Prevent further voting in this session
      });
    } catch (e) {
      setState(() {
        _voteMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vote for Game of the Week')),
      body: FutureBuilder<List<GameModel>>(
        future: _gamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No games available for voting.'));
          }
          final games = snapshot.data!;
          if (_hasVoted && _votedGame != null) {
            // Show the voted game in the center with a message
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: 260,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_votedGame!.imageUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _votedGame!.imageUrl,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.videogame_asset, size: 48),
                              ),
                            ),
                          const SizedBox(height: 16),
                          Text(
                            _votedGame!.gameName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  //                                                                                           //
                  //Add randomised messages to make it more fun and engaging, instead of just "Vote submitted!"//
                  //                                                                                           //               
                  const Text(
                    'Fingers crossed yours will be the winner',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.brown,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (_hasVoted)
                //   const Text(
                //     'You have already voted this week.',
                //     style: TextStyle(
                //       color: Colors.green,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                if (_voteMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _voteMessage!,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                const Text('Select a game to vote for:'),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      final game = games[index];
                      final isSelected = _selectedGameId == game.uid;
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.brown
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedGameId = game.uid;
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (game.imageUrl.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      game.imageUrl,
                                      height: 80,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.videogame_asset,
                                                size: 48,
                                              ),
                                    ),
                                  ),
                                const SizedBox(height: 12),
                                Text(
                                  game.gameName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.brown,
                                    size: 28,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: ElevatedButton(
                    onPressed: _loading || _selectedGameId == null
                        ? null
                        : _vote,
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Text('Vote'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
