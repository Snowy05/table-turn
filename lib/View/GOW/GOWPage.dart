import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Controller/GowService.dart';
import '../../Model/boardgame_samples.dart';
import '../../Model/gameModel.dart';
import '../../Theme/app_theme_constants.dart';

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

  Widget _buildHeroPanel(BuildContext context, bool isPrototype) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This week\'s winner',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: kSecondaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Here is the current Game of the Week winner based on the votes recorded for this week.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.45,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildMetaChip(getCurrentWeekId()),
                  _buildMetaChip('Winner'),
                ],
              ),
            ],
          );

          final badge = Container(
            height: 84,
            width: 84,
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x338C3F23),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              size: 38,
              color: Colors.white,
            ),
          );

          return compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    content,
                    const SizedBox(height: 20),
                    Align(alignment: Alignment.centerLeft, child: badge),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: content),
                    const SizedBox(width: 24),
                    badge,
                  ],
                );
        },
      ),
    );
  }

  Widget _buildMetaChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE7DB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: kSecondaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildWinnerPanel(
    BuildContext context,
    GameModel game,
    int votes,
    bool isPrototype,
  ) {
    final theme = Theme.of(context);
    final playTime = game.playTimes.isNotEmpty
        ? game.playTimes.first
        : 'Flexible length';
    final description = game.description.trim();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          final content = Column(
            crossAxisAlignment: compact
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: compact ? WrapAlignment.center : WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6E6DC),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.workspace_premium_rounded,
                          size: 16,
                          color: kSecondaryColor,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Top Pick',
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isPrototype)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4CF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Winner',
                        style: TextStyle(
                          color: Color(0xFF6A4B00),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                game.gameName,
                textAlign: compact ? TextAlign.center : TextAlign.left,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: kSecondaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                alignment: compact ? WrapAlignment.center : WrapAlignment.start,
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildInfoChip(
                    Icons.how_to_vote_rounded,
                    'Votes this week: $votes',
                  ),
                  _buildInfoChip(
                    Icons.people_alt_outlined,
                    '${game.minPlayers}-${game.maxPlayers} players',
                  ),
                  _buildInfoChip(Icons.timer_outlined, playTime),
                ],
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(
                  description,
                  textAlign: compact ? TextAlign.center : TextAlign.left,
                  maxLines: compact ? 5 : 4,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          );

          return compact
              ? Column(
                  children: [
                    _buildWinnerImage(
                      game,
                      width: double.infinity,
                      height: 230,
                    ),
                    const SizedBox(height: 20),
                    content,
                  ],
                )
              : Row(
                  children: [
                    SizedBox(
                      width: 320,
                      child: _buildWinnerImage(game, width: 320, height: 360),
                    ),
                    const SizedBox(width: 24),
                    Expanded(child: content),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildWinnerImage(
    GameModel game, {
    required double width,
    required double height,
  }) {
    Widget image;

    if (game.imageAsset.isNotEmpty) {
      image = Image.asset(
        game.imageAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageFallback(),
      );
    } else if (game.imageUrl.isNotEmpty) {
      image = Image.network(
        game.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageFallback(),
      );
    } else {
      image = _buildImageFallback();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF4E2D2), Color(0xFFE8C9B6)],
            ),
          ),
          child: image,
        ),
      ),
    );
  }

  Widget _buildImageFallback() {
    return const ColoredBox(
      color: Color(0xFFF4E2D2),
      child: Center(
        child: Icon(Icons.casino_outlined, size: 56, color: kSecondaryColor),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6E6DC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: kSecondaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: kSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
  }) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 42, color: kPrimaryColor),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: kSecondaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Game of the Week')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF9D46A), Color(0xFFFFF1E7), Color(0xFFFFFFFF)],
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _winnerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _buildStateCard(
                context,
                icon: Icons.error_outline_rounded,
                title: 'Could not load this week\'s result',
                message: 'Please try again in a moment.',
              );
            }

            final winner = snapshot.data ?? _prototypeWinner();
            final game = winner['game'] as GameModel;
            final votes = winner['votes'] as int;
            final isPrototype = winner['isPrototype'] as bool? ?? false;
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroPanel(context, isPrototype),
                        const SizedBox(height: 24),
                        Text(
                          'Winning game spotlight',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: kSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'The winner card highlights the current top-voted game for this week.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildWinnerPanel(context, game, votes, isPrototype),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
