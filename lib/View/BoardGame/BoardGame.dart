import 'package:flutter/material.dart';
import 'package:tableturn_project0/Model/Options/gameOptions.dart';
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
  Set<String> selectedTags = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Board Games')),
      //updates in real time for boardgames
      body: Column(
        children: [
          Wrap(
            spacing: 8,
            children: allTags
                .map<Widget>(
                  (tag) => FilterChip(
                    label: Text(tag),
                    selected: selectedTags.contains(tag),
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          selectedTags.add(tag);
                        } else {
                          selectedTags.remove(tag);
                        }
                      });
                    },
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: StreamBuilder<List<GameModel>>(
              stream: Gameservice().getGames(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: \\${snapshot.error}'));
                }
                final games = snapshot.data ?? [];




                // Filter games based on selected tags
                //NEED TO FIX FILTER MULTI SELECTION
                List<GameModel> filteredGames = games.where((game) {
                if (selectedTags.isEmpty) return true;
                return game.tags.any((tag) => selectedTags.contains(tag));
                }).toList();
            
                 if (filteredGames.isEmpty) {
                return const Center(child: Text('No games found.'));
                }
                return ListView.builder(
                  itemCount: filteredGames.length,
                  itemBuilder: (context, index) {
                  final game = filteredGames[index];
                  return BoardGameCard(game: game);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/bookings');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/dashboard');
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
