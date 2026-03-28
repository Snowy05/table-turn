import 'package:flutter/material.dart';
import 'package:tableturn_project0/Model/Options/gameOptions.dart';
import 'package:tableturn_project0/View/BoardGame/BoardGameCardOpen.dart';
import 'package:tableturn_project0/Widgets/BottomNav.dart';
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
      body: Column(
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
                  style: const TextStyle(fontSize: 16, color: Colors.brown),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: selectedAgeGroup,
                  hint: const Text('Age Group'),

                  items: [
                    DropdownMenuItem<String>(
                      //Option to show all age groups when no specific group is selected
                      value: null,
                      child: Text('All Ages'),
                    ),
                    // using spread operator to add age group options from the list "..."
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
                  style: const TextStyle(fontSize: 16, color: Colors.brown),
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
                  // Filter by age group if selected
                  if (selectedAgeGroup != null &&
                      selectedAgeGroup!.isNotEmpty &&
                      game.ageGroups != selectedAgeGroup) {
                    return false;
                  }
                  ;
                  // Filter by complexity if selected
                  if (selectedComplexity != null &&
                      selectedComplexity!.isNotEmpty &&
                      game.complexity != selectedComplexity) {
                    return false;
                  }
                  // Filter by tags if any selected
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
                    //here using the custom card for pop up
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
                    // return BoardGameCard(game: game);
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
