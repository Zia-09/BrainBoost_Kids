import 'dart:math' as math;
import '../models/question.dart';

class MathGeneratorService {
  static final math.Random _random = math.Random();

  static List<Question> generateQuiz({
    required String topic,
    required String difficulty,
    int count = 10,
  }) {
    List<Question> questions = [];
    Set<String> seenQuestions = {};

    while (questions.length < count) {
      final q = _generateSingleQuestion(topic, difficulty);
      if (!seenQuestions.contains(q.text)) {
        questions.add(q);
        seenQuestions.add(q.text);
      }
    }

    return questions;
  }

  static Question _generateSingleQuestion(String topic, String difficulty) {
    int a, b, correctAnswer;
    String text;

    // Difficulty number ranges
    int minRange = 1;
    int maxRange = 10;

    if (difficulty == "Medium") {
      maxRange = 50;
    } else if (difficulty == "Hard") {
      maxRange = 100;
    }

    switch (topic) {
      case "Addition":
        a = _random.nextInt(maxRange - minRange + 1) + minRange;
        b = _random.nextInt(maxRange - minRange + 1) + minRange;
        correctAnswer = a + b;
        text = "$a + $b = ?";
        break;

      case "Subtraction":
        a = _random.nextInt(maxRange - minRange + 1) + minRange;
        // Result always positive, b always less than a
        b = _random.nextInt(a) + 1;
        correctAnswer = a - b;
        text = "$a - $b = ?";
        break;

      case "Multiplication":
        int multMax = 5;
        if (difficulty == "Medium") multMax = 10;
        if (difficulty == "Hard") multMax = 15;
        
        a = _random.nextInt(multMax) + 1;
        b = _random.nextInt(multMax) + 1;
        correctAnswer = a * b;
        text = "$a × $b = ?";
        break;

      case "Division":
        int divMax = 5;
        if (difficulty == "Medium") divMax = 10;
        if (difficulty == "Hard") divMax = 15;
        
        // generate as answer × b = a
        int answer = _random.nextInt(divMax) + 1;
        b = _random.nextInt(divMax) + 1;
        a = answer * b;
        correctAnswer = answer;
        text = "$a ÷ $b = ?";
        break;

      default:
        a = _random.nextInt(maxRange) + 1;
        b = _random.nextInt(maxRange) + 1;
        correctAnswer = a + b;
        text = "$a + $b = ?";
    }

    // Wrong options rules
    List<int> wrongOptions = [];
    while (wrongOptions.length < 3) {
      int offset = _random.nextInt(31) - 15; // ±1 to ±15
      if (offset == 0) continue;
      
      int option = correctAnswer + offset;
      
      // Never negative, never duplicate, never equal correct answer
      if (option >= 0 && option != correctAnswer && !wrongOptions.contains(option)) {
        wrongOptions.add(option);
      }
    }

    List<String> allOptions = [
      correctAnswer.toString(),
      ...wrongOptions.map((e) => e.toString())
    ];

    // Shuffle all 4 options randomly
    allOptions.shuffle(_random);
    int correctOptionIndex = allOptions.indexOf(correctAnswer.toString());

    return Question(
      text: text,
      options: allOptions,
      correctOptionIndex: correctOptionIndex,
      topic: topic,
      difficulty: difficulty,
      subject: "Math",
    );
  }
}
