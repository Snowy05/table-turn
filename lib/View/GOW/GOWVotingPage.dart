import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Controller/GowService.dart';
import '../../Model/gameModel.dart';
import '../../Theme/app_theme_constants.dart';

class GOWVotingPage extends StatefulWidget {
  const GOWVotingPage({Key? key}) : super(key: key);

  @override
  State<GOWVotingPage> createState() => _GOWVotingPageState();
}

class _GOWVotingPageState extends State<GOWVotingPage> {
  late Future<List<GameModel>> _gamesFuture;
  bool _hasVoted = false;
  String? _selectedGameId;
  GameModel? _votedGame;
  bool _loading = false;
  String? _voteMessage;

  String getCurrentWeekId() {
    final now = DateTime.now();
    final week = ((now.day - 1) ~/ 7) + 1;
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-W$week';
  }

  @override
  void initState() {
    super.initState();
    _gamesFuture = _fetchGames();
    _checkIfVoted();
  }

  Future<List<GameModel>> _fetchGames() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('boardgames')
        .get();
    return snapshot.docs
        .map((doc) => GameModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> _checkIfVoted() async {
    final weekId = getCurrentWeekId();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      setState(() {
        _hasVoted = false;
        _votedGame = null;
        _selectedGameId = null;
      });
      return;
    }
    final voteDoc = await FirebaseFirestore.instance
        .collection('votes')
        .doc('${user.uid}_$weekId')
        .get();
    if (!mounted) return;
    if (voteDoc.exists) {
      final gameId = voteDoc['gameId'] as String?;
      if (gameId != null) {
        final games = await _gamesFuture;
        final votedGame = games.where((g) => g.uid == gameId).isNotEmpty
            ? games.firstWhere((g) => g.uid == gameId)
            : null;
        if (!mounted) return;
        setState(() {
          _hasVoted = true;
          _votedGame = votedGame;
          _selectedGameId = null;
        });
      } else {
        setState(() {
          _hasVoted = true;
          _votedGame = null;
          _selectedGameId = null;
        });
      }
    } else {
      setState(() {
        _hasVoted = false;
        _votedGame = null;
      });
    }
  }

  Future<void> _vote() async {
    if (_selectedGameId == null) return;
    setState(() {
      _loading = true;
      _voteMessage = null;
    });
    final weekId = getCurrentWeekId();
    try {
      await GowService().voteForGame(gameId: _selectedGameId!, weekId: weekId);
      final games = await _gamesFuture;
      final votedGame = games.where((g) => g.uid == _selectedGameId).isNotEmpty
          ? games.firstWhere((g) => g.uid == _selectedGameId)
          : null;
      if (!mounted) return;
      setState(() {
        _hasVoted = true;
        _voteMessage = null;
        _votedGame = votedGame;
        _selectedGameId = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _voteMessage = 'Error: ${e.toString()}';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildHeroPanel(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = BoxDecoration(
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
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pick this week\'s winner',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: kSecondaryColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Choose one board game to feature as Game of the Week. Once you submit, your vote is locked for this week.',
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
            _buildMetaChip('1 vote per player'),
            _buildMetaChip(getCurrentWeekId()),
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
        Icons.how_to_vote_rounded,
        size: 38,
        color: Colors.white,
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;
        return Container(
          decoration: decoration,
          padding: const EdgeInsets.all(24),
          child: compact
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
                ),
        );
      },
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

  Widget _buildMessageBanner(BuildContext context, String message) {
    final isError = message.startsWith('Error:');
    final background = isError
        ? const Color(0xFFFFE6E1)
        : const Color(0xFFE7F7EA);
    final accent = isError ? const Color(0xFF9C3C2B) : const Color(0xFF2E7D32);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline_rounded : Icons.check_circle_outline,
            color: accent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVotedState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.black, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 28,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 72,
                width: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFE7F7EA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF2E7D32),
                  size: 40,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Your vote is locked in',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: kSecondaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _votedGame == null
                    ? 'Thanks for casting your vote for this week.'
                    : 'Thanks for backing ${_votedGame!.gameName} this week.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black87,
                  height: 1.45,
                ),
              ),
              if (_votedGame != null) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4EE),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 380;
                      return compact
                          ? Column(
                              children: [
                                _buildGameImage(
                                  _votedGame!,
                                  height: 180,
                                  width: double.infinity,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _votedGame!.gameName,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: kSecondaryColor,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                SizedBox(
                                  width: 160,
                                  child: _buildGameImage(
                                    _votedGame!,
                                    height: 140,
                                    width: 160,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    _votedGame!.gameName,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: kSecondaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Text(
                'Check back after voting closes to see this week\'s winner.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVotingGrid(BuildContext context, List<GameModel> games) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 980
            ? 3
            : width >= 640
            ? 2
            : 1;
        final childAspectRatio = switch (crossAxisCount) {
          1 => 2.15,
          2 => 1.0,
          _ => 0.82,
        };

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: games.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final game = games[index];
            return _buildGameCard(
              context,
              game,
              isSelected: _selectedGameId == game.uid,
            );
          },
        );
      },
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    GameModel game, {
    required bool isSelected,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth > 300;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFF2EC)
                : Colors.white.withOpacity(0.96),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? kPrimaryColor : Colors.black12,
              width: isSelected ? 2.2 : 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0x268C3F23)
                    : const Color(0x12000000),
                blurRadius: isSelected ? 22 : 14,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                setState(() {
                  _selectedGameId = game.uid;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: horizontal
                    ? Row(
                        children: [
                          _buildGameImage(game, height: 116, width: 116),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildGameDetails(
                              context,
                              game,
                              isSelected: isSelected,
                              centered: false,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGameImage(
                            game,
                            height: 138,
                            width: double.infinity,
                          ),
                          const SizedBox(height: 16),
                          _buildGameDetails(
                            context,
                            game,
                            isSelected: isSelected,
                            centered: true,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameDetails(
    BuildContext context,
    GameModel game, {
    required bool isSelected,
    required bool centered,
  }) {
    final theme = Theme.of(context);
    final playTime = game.playTimes.isNotEmpty
        ? game.playTimes.first
        : 'Flexible length';
    final statusStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isSelected ? kPrimaryColor : Colors.black54,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (centered)
          Text(
            game.gameName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: kSecondaryColor,
            ),
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  game.gameName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: kSecondaryColor,
                  ),
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 10),
                _buildSelectedPill(),
              ],
            ],
          ),
        if (centered && isSelected) ...[
          const SizedBox(height: 12),
          _buildSelectedPill(),
        ],
        const SizedBox(height: 12),
        Wrap(
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildInfoChip(
              Icons.people_alt_outlined,
              '${game.minPlayers}-${game.maxPlayers} players',
            ),
            _buildInfoChip(Icons.timer_outlined, playTime),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          isSelected ? 'Selected for this week' : 'Tap to choose this game',
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: statusStyle,
        ),
      ],
    );
  }

  Widget _buildSelectedPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 16, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'Selected',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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

  Widget _buildGameImage(
    GameModel game, {
    required double height,
    required double width,
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
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: height,
        width: width,
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Color(0xFFF4E2D2)),
          child: image,
        ),
      ),
    );
  }

  Widget _buildImageFallback() {
    return const ColoredBox(
      color: Color(0xFFF4E2D2),
      child: Center(
        child: Icon(Icons.casino_outlined, size: 44, color: kSecondaryColor),
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
      appBar: AppBar(title: const Text('Vote for Game of the Week')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF9D46A), Color(0xFFFFF1E7), Color(0xFFFFFFFF)],
          ),
        ),
        child: FutureBuilder<List<GameModel>>(
          future: _gamesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _buildStateCard(
                context,
                icon: Icons.error_outline_rounded,
                title: 'Could not load the ballot',
                message: 'Please try again in a moment.',
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildStateCard(
                context,
                icon: Icons.inbox_outlined,
                title: 'No games available',
                message: 'There are no board games ready to vote on right now.',
              );
            }

            final games = snapshot.data!;
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroPanel(context),
                        if (_voteMessage != null) ...[
                          const SizedBox(height: 18),
                          _buildMessageBanner(context, _voteMessage!),
                        ],
                        const SizedBox(height: 24),
                        if (_hasVoted)
                          _buildVotedState(context)
                        else ...[
                          Text(
                            'Select one game below to cast your vote.',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: kSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'The layout now adapts for mobile and larger screens, so the ballot stays readable wherever you open it.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildVotingGrid(context, games),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _loading || _selectedGameId == null
                                  ? null
                                  : _vote,
                              icon: _loading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.how_to_vote_rounded),
                              label: Text(
                                _loading
                                    ? 'Submitting vote...'
                                    : _selectedGameId == null
                                    ? 'Select a game to continue'
                                    : 'Submit vote',
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(58),
                              ),
                            ),
                          ),
                        ],
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
