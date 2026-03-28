

import 'package:flutter/material.dart';
import 'package:tableturn_project0/Model/gameModel.dart';

class BoardGameCardOpen extends StatelessWidget {
  final GameModel game;

  const BoardGameCardOpen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
child: Padding(padding:   const EdgeInsets.all(16.0),
child: Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    if(game.imageAsset.isNotEmpty)
    Image.asset(game.imageAsset, width: double.infinity, fit: BoxFit.cover,),
    if (game.imageUrl.isNotEmpty)
    Image.network(game.imageUrl, width: double.infinity, fit: BoxFit.cover,),
    SizedBox(height: 16.0,),
    Center(child: Text(game.gameName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),)),
    SizedBox(height: 8.0,),
    Text('Players: ${game.minPlayers} - ${game.maxPlayers}'),
    Text( 'Playtime: ${game.playTimes} minutes'),
    Text( 'Complexity: ${game.complexity}'),
    Text ( 'Age Group: ${game.ageGroups.join(',')}'),
    Text( 'Tags: ${game.tags.join(', ')}'),
    Text('Availability: ${game.isAvailable ? 'Available' : 'Not Available'}'),
    SizedBox(height: 8.0,),
    Text(game.description),
    SizedBox(height: 16.0,),
    Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Close'),
      ),
    )
  ]
),
)

);
  }
}