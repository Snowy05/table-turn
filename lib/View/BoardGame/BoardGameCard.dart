import 'package:flutter/material.dart';
import '../../../Model/gameModel.dart';

class BoardGameCard extends StatelessWidget {
  final GameModel game;
  const BoardGameCard({super.key, required this.game});

  @override
  // Custom card widget to display game information in the list
  Widget build(BuildContext context) {
    final isHighContrast =
        Theme.of(context).colorScheme.primary == Colors.black;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
      elevation: 4,
      color: isHighContrast ? Colors.black : null,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Game image if available, else show placeholder
            if (game.imageAsset.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  game.imageAsset,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.videogame_asset, size: 48),
                ),
              )
            else if (game.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  game.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.videogame_asset, size: 48),
                ),
              )
            else
              Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.videogame_asset, size: 48),
              ),
            const SizedBox(height: 12),
            // Game name
            Text(
              game.gameName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Players and playtime
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Text(
                  '${game.minPlayers}-${game.maxPlayers} players',
                  style: TextStyle(
                    fontSize: 13 * MediaQuery.textScaleFactorOf(context),
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.timer, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Text(
                  game.playTimes.isNotEmpty ? game.playTimes.first : '-',
                  style: TextStyle(
                    fontSize: 13 * MediaQuery.textScaleFactorOf(context),
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
