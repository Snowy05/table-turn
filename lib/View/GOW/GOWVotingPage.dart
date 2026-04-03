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
    final voted = await GowService().hasVotedThisWeek(weekId);
    setState(() {
      _hasVoted = voted;
    });
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
      setState(() {
        _hasVoted = true;
        _voteMessage = 'Vote submitted!';
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_hasVoted)
                  const Text(
                    'You have already voted this week.',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (_voteMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _voteMessage!,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                if (!_hasVoted) ...[
                  const Text('Select a game to vote for:'),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        final game = games[index];
                        return RadioListTile<String>(
                          title: Text(game.gameName),
                          value: game.uid,
                          groupValue: _selectedGameId,
                          onChanged: (val) {
                            setState(() {
                              _selectedGameId = val;
                            });
                          },
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
              ],
            ),
          );
        },
      ),
    );
  }
}
