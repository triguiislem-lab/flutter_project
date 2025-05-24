import 'package:project_application/models/question.dart';

class QuizResult {
  final List<Question> questions;
  final List<String> userAnswers;
  final int score;
  final DateTime dateTime;
  final String category;
  final String difficulty;

  QuizResult({
    required this.questions,
    required this.userAnswers,
    required this.score,
    required this.dateTime,
    required this.category,
    required this.difficulty,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
      userAnswers: List<String>.from(json['userAnswers']),
      score: json['score'],
      dateTime: DateTime.parse(json['dateTime']),
      category: json['category'],
      difficulty: json['difficulty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questions': questions.map((q) => q.toJson()).toList(),
      'userAnswers': userAnswers,
      'score': score,
      'dateTime': dateTime.toIso8601String(),
      'category': category,
      'difficulty': difficulty,
    };
  }
}
