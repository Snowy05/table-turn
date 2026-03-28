import 'package:flutter/material.dart';
import 'package:tableturn_project0/Model/gameModel.dart';

class BoardGameCardOpen extends StatelessWidget {
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
                Tab(text: 'Instructions'),
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
                        Text('Categories: ${game.categories.join(', ')}'),
                        Text('Tags: ${game.tags.join(', ')}'),
                        Text('Age Groups: ${game.ageGroups.join(', ')}'),
                        Text('Play Times: ${game.playTimes.join(', ')}'),
                        Text(
                          'Availability: ${game.isAvailable ? 'Available' : 'Not Available'}',
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  // Instructions tab (using description as placeholder for instructions at the moment)
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      game.description,
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
