import '../findYourGameModels.dart';

final List<GameQuestion> questionnaire = [
  //questionnaire for find your game, each question has a list of answers, each answer has a list of tags, the tags will be used to filter the games
  GameQuestion(
    question: "What kind of vibe are you feeling today?",
    answers: [
      GameAnswer(
        text: "Let’s get silly and laugh!",
        tags: ["Party Game", "Family Favorite", "New"],
      ),
      GameAnswer(
        text: "I’m ready for some friendly competition.",
        tags: ["Strategy Game", "Card Game", "Dice Game", "Classic"],
      ),
      GameAnswer(
        text: "I want to work together and chill.", // need to widen the list
        tags: ["Cooperative Game", "Family", "For Kids"],
      ),
      GameAnswer(
        text: "Give me a brain teaser or mystery!",
        tags: ["Trivia", "Word Game", "Drawing Game"],
      ),
      GameAnswer(
        text: "Something quick and easy, please.",
        tags: ["Under 30 minutes", "Easy", "Party Game", "Card Game"],
      ),
      GameAnswer(
        text: "I’m in the mood for a deep, strategic battle.",
        tags: ["Strategy Game", "Hard", "Expert", "Long-Haul"],
      ),
    ],
  ),
  GameQuestion(
    question: "How many legends are joining you at the table?",
    answers: [
      GameAnswer(text: "Just me and one other", tags: ["2p"]),
      GameAnswer(text: "3–4 of us", tags: ["3-4p"]),
      GameAnswer(text: "We’ve got a whole crew (5+)", tags: ["5p+"]),
    ],
  ),
  GameQuestion(
    question: "How much time do you want to spend on this adventure?",
    answers: [
      GameAnswer(
        text: "Just a quick round (15–30 min)",
        tags: ["Under 30 minutes"],
      ),
      GameAnswer(text: "A solid session (30–60 min)", tags: ["30-60 minutes"]),
      GameAnswer(
        text: "All night long! (1+ hour)",
        tags: ["1-2 hours", "Over 2 hours"],
      ),
    ],
  ),
  GameQuestion(
    question: "How do you feel about rules?",
    answers: [
      GameAnswer(text: "Keep it super simple", tags: ["Easy"]),
      GameAnswer(
        text: "I can handle a little complexity",
        tags: ["Medium"],
      ), //done
      GameAnswer(text: "Bring on the challenge!", tags: ["Hard", "Expert"]),
    ],
  ),
  GameQuestion(
    question: "Who’s playing?",
    answers: [
      GameAnswer(text: "Kids only", tags: ["Kids"]),
      GameAnswer(text: "Teens", tags: ["Teens"]),
      GameAnswer(text: "Adults", tags: ["Adults"]), //done
      GameAnswer(text: "A mix of ages", tags: ["Family"]),
    ],
  ),
];
