import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Controller/GowService.dart';
import '../../Model/boardgame_samples.dart';
import '../../Model/gameModel.dart';
import '../BoardGame/BoardGameCard.dart';

class GOWPage extends StatefulWidget {
  const GOWPage({Key? key}) : super(key: key);

  @override
  State<GOWPage> createState() => _GOWPageState();
}

class _GOWPageState extends State<GOWPage> {
  late Future<Map<String, dynamic>> _winnerFuture;

  String getCurrentWeekId() {
    final now = DateTime.now();
    final week = ((now.day - 1) ~/ 7) + 1;
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-W$week';
  }

  Map<String, dynamic> _prototypeWinner() {
    return {
      'game': GameModel.fromMap(boardgameSamples.first, 'prototype-pandemic'),
      'votes': 18,
      'isPrototype': true,
    };
  }

  Future<Map<String, dynamic>> _fetchWinnerWithVotes() async {
    final prototypeWinner = _prototypeWinner();

    try {
      final weekId = getCurrentWeekId();
      final gow = await GowService().getGameOfTheWeek(weekId);
      if (gow == null) {
        return prototypeWinner;
      }

      final gameDoc = await FirebaseFirestore.instance
          .collection('boardgames')
          .doc(gow.gameId)
          .get();
      if (!gameDoc.exists || gameDoc.data() == null) {
        return prototypeWinner;
      }

      final game = GameModel.fromMap(gameDoc.data()!, gameDoc.id);
      final votesSnap = await FirebaseFirestore.instance
          .collection('votes')
          .where('weekId', isEqualTo: weekId)
          .where('gameId', isEqualTo: gow.gameId)
          .get();

      return {'game': game, 'votes': votesSnap.size, 'isPrototype': false};
    } catch (_) {
      return prototypeWinner;
    }
  }

  @override
  void initState() {
    super.initState();
    _winnerFuture = _fetchWinnerWithVotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game of the Week')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFFF9D46A), Color(0xFFFFFFFF)],
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _winnerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final winner = snapshot.data ?? _prototypeWinner();
            final game = winner['game'] as GameModel;
            final votes = winner['votes'] as int;
            final isPrototype = winner['isPrototype'] as bool? ?? false;
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: BoardGameCard(game: game),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isPrototype
                          ? 'Sample votes this week: $votes'
                          : 'Votes this week: $votes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18 * MediaQuery.textScaleFactorOf(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
