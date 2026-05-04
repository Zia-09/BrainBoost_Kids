import 'dart:math' as math;
import '../models/question.dart';

class MathGenerator {
  static final math.Random _random = math.Random();

  static List<Question> generateQuestions({
    required String topic,
    required String difficulty,
    int count = 10,
  }) {
    List<Question> questions = [];
    int max;
    
    switch (difficulty) {
      case 'Easy':
        max = 10;
        break;
      case 'Medium':
        max = 50;
        break;
      case 'Hard':
        max = 100;
        break;
      default:
        max = 20;
    }

    for (int i = 0; i < count; i++) {
      questions.add(_generateSingleQuestion(topic, difficulty, max));
    }

    return questions;
  }

  static Question _generateSingleQuestion(String topic, String difficulty, int max) {
    int a, b, result;
    String operator;
    
    switch (topic) {
      case 'Addition':
        a = _random.nextInt(max) + 1;
        b = _random.nextInt(max) + 1;
        result = a + b;
        operator = '+';
        break;
      case 'Subtraction':
        a = _random.nextInt(max) + (max ~/ 2) + 1;
        b = _random.nextInt(a);
        result = a - b;
        operator = '-';
        break;
      case 'Multiplication':
        // Adjust max for multiplication to keep it reasonable
        int multMax = (difficulty == 'Hard') ? 12 : (difficulty == 'Medium' ? 10 : 5);
        a = _random.nextInt(multMax) + 1;
        b = _random.nextInt(multMax) + 1;
        result = a * b;
        operator = 'x';
        break;
      case 'Division':
        // Adjust for clean division
        int divMax = (difficulty == 'Hard') ? 12 : (difficulty == 'Medium' ? 10 : 5);
        b = _random.nextInt(divMax) + 1;
        result = _random.nextInt(divMax) + 1;
        a = result * b;
        operator = '/';
        break;
      default:
        a = _random.nextInt(max) + 1;
        b = _random.nextInt(max) + 1;
        result = a + b;
        operator = '+';
    }

    List<String> options = _generateOptions(result, difficulty, max);
    int correctIndex = options.indexOf(result.toString());

    return Question(
      text: "What is $a $operator $b?",
      options: options,
      correctOptionIndex: correctIndex,
      topic: topic,
      difficulty: difficulty,
      subject: "Math",
    );
  }

  static List<String> _generateOptions(int result, String difficulty, int max) {
    Set<int> optionSet = {result};
    int range = (difficulty == 'Hard') ? 15 : (difficulty == 'Medium' ? 10 : 5);

    while (optionSet.length < 4) {
      int offset = _random.nextInt(range * 2) - range;
      if (offset == 0) offset = range;
      int option = result + offset;
      if (option >= 0) {
        optionSet.add(option);
      }
    }

    List<int> optionsList = optionSet.toList()..shuffle();
    return optionsList.map((e) => e.toString()).toList();
  }
}
