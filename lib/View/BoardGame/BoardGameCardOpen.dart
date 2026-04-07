import 'package:flutter/material.dart';
import 'package:tableturn_project0/Model/gameModel.dart';

class BoardGameCardOpen extends StatelessWidget {
  // Helper for color-coding tags
  static Color tagColor(String tag, BuildContext context) {
    switch (tag.toLowerCase()) {
      case 'strategy game':
        return const Color(0xFF1976D2);
      case 'party game':
        return const Color(0xFFD81B60);
      case 'cooperative game':
        return const Color(0xFF43A047);
      case 'card game':
        return const Color(0xFF8E24AA);
      case 'dice game':
        return const Color(0xFFFFB300);
      case 'word game':
        return const Color(0xFF00ACC1);
      case 'trivia':
        return const Color(0xFFFDD835);
      case 'drawing game':
        return const Color(0xFFEC407A);
      case 'for kids':
        return const Color(0xFF1E88E5);
      case 'long-haul':
        return const Color(0xFF66BB6A);
      case 'roleplaying game':
        return const Color(0xFF3949AB);
      case 'classic':
        return const Color(0xFFFFCA28);
      default:
        final colors = [
          Color(0xFFEC407A),
          Color(0xFF26A69A),
          Color(0xFFFF7043),
          Color(0xFFAB47BC),
          Color(0xFF29B6F6),
          Color(0xFFFFCA28),
          Color(0xFF66BB6A),
        ];
        final idx = tag.hashCode.abs() % colors.length;
        return colors[idx];
    }
  }

  final GameModel game;
  //custom card widget to display detailed game information in a pop-up dialog with tabs for details and instructions
  const BoardGameCardOpen({super.key, required this.game});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'Tutorial'),
              ],
              labelColor: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 500,
              child: TabBarView(
                children: [
                  // Details tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            game.gameName,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (game.imageAsset.isNotEmpty)
                          Image.asset(
                            game.imageAsset,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        if (game.imageUrl.isNotEmpty)
                          Image.network(
                            game.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        const SizedBox(height: 16),
                        Text(game.description),
                        const SizedBox(height: 16),
                        Text(
                          'Players: ${game.minPlayers} - ${game.maxPlayers}',
                        ),
                        Text('Complexity: ${game.complexity}'),
                        // Categories removed from GameModel; use tags or other fields if needed
                        Text('Age Groups: ${game.ageGroups.join(', ')}'),
                        Text('Play Times: ${game.playTimes.join(', ')}'),
                        Text(
                          'Availability: ${game.isAvailable ? 'Available' : 'Not Available'}',
                        ),
                        const SizedBox(height: 16),
                        //tg Chips moved to the very bottom for visual clarity
                        if (game.tags.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: game.tags.map((tag) {
                                  final color = BoardGameCardOpen.tagColor(
                                    tag,
                                    context,
                                  );
                                  return Chip(
                                    label: Text(
                                      tag,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: color,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                        bottomLeft: Radius.circular(24),
                                        bottomRight: Radius.circular(24),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  //tutorial tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      game.tutorial,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
