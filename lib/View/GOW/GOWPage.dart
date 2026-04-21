import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Controller/GowService.dart';
import '../../Model/gowModel.dart';
import '../../Model/gameModel.dart';
import '../BoardGame/BoardGameCard.dart';

class GOWPage extends StatefulWidget {
  const GOWPage({Key? key}) : super(key: key);

  @override
  State<GOWPage> createState() => _GOWPageState();
}

class _GOWPageState extends State<GOWPage> {
  late Future<Map<String, dynamic>?> _winnerFuture;

  String getCurrentWeekId() {
    final now = DateTime.now();
    //use ISO week number for week-based GOW
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final daysOffset =
        firstDayOfYear.weekday -
        DateTime
            .monday; // Calculate offset to the first Monday of the year because ISO weeks start on Monday
    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
    final diff = now.difference(firstMonday).inDays;
    //floor division to get week number, add 1 because first week is W01
    final weekNumber = (diff / 7).floor() + 1;
    //format: 2026-W14 for year 2026, week 14
    return '${now.year}-W${weekNumber.toString().padLeft(2, '0')}';
  }
  // this

  Future<Map<String, dynamic>?> _fetchWinnerWithVotes() async {
    final weekId = getCurrentWeekId();
    final gow = await GowService().getGameOfTheWeek(weekId);
    if (gow == null) {
      return null;
    }
    //get game details
    final gameDoc = await FirebaseFirestore.instance
        .collection('boardgames')
        .doc(gow.gameId)
        .get();
    if (!gameDoc.exists) {
      return null;
    }
    final game = GameModel.fromMap(gameDoc.data()!, gameDoc.id);
    //count votes for this game this week
    final votesSnap = await FirebaseFirestore.instance
        .collection('votes')
        .where('weekId', isEqualTo: weekId)
        .where('gameId', isEqualTo: gow.gameId)
        .get();
    return {'game': game, 'votes': votesSnap.size};
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
            colors: [              Color(0xFFF9D46A),

              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _winnerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text(
                  'No Game of the Week selected yet.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            final game = snapshot.data!['game'] as GameModel;
            final votes = snapshot.data!['votes'] as int;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BoardGameCard(game: game),
                  const SizedBox(height: 24),
                  Text(
                    'Votes this week: $votes',
                    style: TextStyle(
                      fontSize: 18 * MediaQuery.textScaleFactorOf(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
