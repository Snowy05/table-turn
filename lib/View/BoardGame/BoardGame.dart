import 'package:flutter/material.dart';
import 'package:tableturn_project0/Model/Options/gameOptions.dart';
import 'package:tableturn_project0/View/BoardGame/BoardGameCardOpen.dart';
import 'package:tableturn_project0/GlobalWidgets/BottomNav.dart';
import '../../Model/gameModel.dart';
import '../../Controller/GameService.dart';
import 'BoardGameCard.dart';
import 'TagButton.dart';

class BoardGame extends StatefulWidget {
  const BoardGame({super.key});

  @override
  State<BoardGame> createState() => _BoardGameState();
}

class _BoardGameState extends State<BoardGame> {
  Set<String> selectedTags = {};
  String? selectedComplexity;
  String? selectedAgeGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Board Games')),
      body: Container(
        
          decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF), 
                        Color(0xFFF9E6C1), 


          ],
        ),
      ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Tagbttn(
                      selectedTags: selectedTags,
                      allTags: allTags,
                      onApply: (newTags) {
                        setState(() {
                          selectedTags = newTags;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: selectedComplexity,
                    hint: const Text('Complexity'),
                    items: [
                      DropdownMenuItem<String>(value: null, child: Text('All')),
                      ...allComplexities
                          .map(
                            (complexity) => DropdownMenuItem(
                              value: complexity,
                              child: Text(complexity),
                            ),
                          )
                          .toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedComplexity = value;
                      });
                    },
                    isExpanded: false,
                    underline: Container(height: 2, color: Colors.brown),
                    style: TextStyle(
                      fontSize: 16 * MediaQuery.textScaleFactorOf(context),
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: selectedAgeGroup,
                    hint: const Text('Age Group'),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Ages'),
                      ),
                      ...allAgeGroups
                          .map(
                            (ageGroup) => DropdownMenuItem<String>(
                              value: ageGroup,
                              child: Text(ageGroup),
                            ),
                          )
                          .toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedAgeGroup = value;
                      });
                    },
                    isExpanded: false,
                    underline: Container(height: 2, color: Colors.brown),
                    style: TextStyle(
                      fontSize: 16 * MediaQuery.textScaleFactorOf(context),
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
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
        
                  // Multi-criteria filtering
                  List<GameModel> filteredGames = games.where((game) {
                    if (selectedAgeGroup != null &&
                        selectedAgeGroup!.isNotEmpty &&
                        !game.ageGroups.contains(selectedAgeGroup)) {
                      return false;
                    }
                    if (selectedComplexity != null &&
                        selectedComplexity!.isNotEmpty &&
                        game.complexity != selectedComplexity) {
                      return false;
                    }
                    if (selectedTags.isNotEmpty &&
                        !game.tags.any((tag) => selectedTags.contains(tag))) {
                      return false;
                    }
                    return true;
                  }).toList();
        
                  if (filteredGames.isEmpty) {
                    return const Center(child: Text('No games found.'));
                  }
                  return ListView.builder(
                    itemCount: filteredGames.length,
                    itemBuilder: (context, index) {
                      final game = filteredGames[index];
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                Dialog(child: BoardGameCardOpen(game: game)),
                          );
                        },
                        child: BoardGameCard(game: game),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/bookings');
              break;
            case 1:
              // Already on boardgames, do nothing
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/loyalty');
              break;
          }
        },
      ),
    );
  }
}
