class GameQuestion {
  final String question;
  final List<GameAnswer> answers;

  GameQuestion({required this.question, required this.answers});
}
//model for find your game questionnaire, each question has a list of answers, each answer has a list of tags, the tags will be used to filter the games
class GameAnswer {
  final String text;
  final List<String> tags; // e.g. ["party", "quick", "simple"]

  GameAnswer({required this.text, required this.tags});
}

class BoardGame {
  final String name;
  final String description;
  final String imageAsset;
  final List<String> tags;

  BoardGame({
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.tags,
  });
}
