class QuizOptions {
  final int? categoryId;
  final String difficulty;
  final int numberOfQuestions;
  final String type;

  QuizOptions({
    this.categoryId,
    this.difficulty = 'any',
    this.numberOfQuestions = 10,
    this.type = 'multiple',
  });

  Map<String, dynamic> toJson() {
    return {
      'category': categoryId,
      'difficulty': difficulty == 'any' ? null : difficulty,
      'amount': numberOfQuestions,
      'type': type == 'any' ? null : type,
    };
  }
}
