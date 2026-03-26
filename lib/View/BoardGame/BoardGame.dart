import 'package:flutter/material.dart';
import 'package:tableturn_project0/Widgets/BottomNav.dart';
import '../../Model/gameModel.dart';
import '../../Controller/GameService.dart';
import 'BoardGameCard.dart';

class BoardGame extends StatefulWidget {
  const BoardGame({super.key});

  @override
  State<BoardGame> createState() => _BoardGameState();
}

class _BoardGameState extends State<BoardGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Board Games')),
      //updates in real time for boardgames
      body: StreamBuilder<List<GameModel>>(
        stream: Gameservice().getGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          }
          final games = snapshot.data ?? [];
          if (games.isEmpty) {
            return const Center(child: Text('No games found.'));
          }
          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              //using custom card 
              return BoardGameCard(game: game);
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex:
        -1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/bookings');
              break;
            case 1:
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
