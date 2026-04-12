import 'package:flutter/material.dart';
import 'package:tableturn_project0/View/BoardGame/BoardGameCard.dart';
import 'package:tableturn_project0/View/BoardGame/BoardGameCardOpen.dart';
import '../Model/Options/findYourGameQuestions.dart';
import '../Controller/FindYourGameService.dart';
import '../Model/findYourGameModels.dart';
import '../Model/gameModel.dart';

class FindYourGameQuiz extends StatefulWidget {
  const FindYourGameQuiz({Key? key}) : super(key: key);

  @override
  State<FindYourGameQuiz> createState() => _FindYourGameQuizState();
}

class _FindYourGameQuizState extends State<FindYourGameQuiz> {
  int _currentStep = 0;
  final List<List<String>> _selectedTags = [];
  bool _loading = false;
  List<BoardGame>? _recommendations;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedTags.addAll(List.generate(questionnaire.length, (_) => []));
  }

  void _onAnswerSelected(int questionIdx, List<String> tags) {
    setState(() {
      _selectedTags[questionIdx] = tags;
    });
  }

  Future<void> _getRecommendations() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final games = await fetchBoardGamesFromFirestore();
      final recs = recommendGames(_selectedTags, games);
      setState(() {
        _recommendations = recs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch recommendations.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_recommendations != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your Game Matches')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _recommendations!.isEmpty
            ? const Center(child: Text('No games matched your answers.'))
            : ListView.builder(
                itemCount: _recommendations!.length,
                // convert BoardGame to GameModel for card widgets
                itemBuilder: (context, idx) {
                  final boardGame = _recommendations![idx];
                  // Convert BoardGame to GameModel for card widgets
                  final game = GameModel(
                    uid: '',
                    gameName: boardGame.name,
                    minPlayers: boardGame.minPlayers,
                    maxPlayers: boardGame.maxPlayers,
                    description: boardGame.description,
                    imageAsset: boardGame.imageAsset,
                    imageUrl: '',
                    ageGroups: [],
                    complexity: '',
                    playTimes: boardGame.playTimes,
                    tags: boardGame.tags,
                    tutorial: boardGame is dynamic && boardGame.tutorial != null
                        ? boardGame.tutorial
                        : '',
                    isAvailable: true,
                    isAvailableForBooking: true,
                    availabilityStatus: 'Available',
                    quantityInStock: 1,
                  );
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
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              _recommendations = null;
              _currentStep = 0;
            });
          },
          label: const Text('Restart Quiz'),
          icon: const Icon(Icons.refresh),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Find Your Game')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < questionnaire.length - 1) {
                  setState(() => _currentStep++);
                } else {
                  _getRecommendations();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep--);
                }
              },
              steps: List.generate(questionnaire.length, (idx) {
                final q = questionnaire[idx];
                return Step(
                  title: Text(q.question),
                  content: Column(
                    children: q.answers.map((a) {
                      final selected = _selectedTags[idx] == a.tags;
                      return ListTile(
                        title: Text(a.text),
                        leading: Radio<List<String>>(
                          value: a.tags,
                          groupValue: _selectedTags[idx],
                          onChanged: (val) => _onAnswerSelected(idx, val ?? []),
                        ),
                      );
                    }).toList(),
                  ),
                  isActive: _currentStep == idx,
                  state: _selectedTags[idx].isNotEmpty
                      ? StepState.complete
                      : StepState.indexed,
                );
              }),
              controlsBuilder: (context, details) {
                return Row(
                  children: [
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Back'),
                      ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _selectedTags[_currentStep].isNotEmpty
                          ? details.onStepContinue
                          : null,
                      child: Text(
                        _currentStep == questionnaire.length - 1
                            ? 'See Matches'
                            : 'Next',
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
