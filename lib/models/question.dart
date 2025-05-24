class Question {
  final String id;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String category;
  final String difficulty;
  final String type;
  
  Question({
    required this.id,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.category,
    required this.difficulty,
    required this.type,
  });

  List<String> get allAnswers {
    final answers = List<String>.from(incorrectAnswers);
    answers.add(correctAnswer);
    answers.shuffle();
    return answers;
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      question: json['question'] ?? '',
      correctAnswer: json['correct_answer'] ?? '',
      incorrectAnswers: json['incorrect_answers'] != null
          ? List<String>.from(json['incorrect_answers'])
          : [],
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'correct_answer': correctAnswer,
      'incorrect_answers': incorrectAnswers,
      'category': category,
      'difficulty': difficulty,
      'type': type,
    };
  }
}
