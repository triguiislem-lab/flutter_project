import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_application/models/category.dart';
import 'package:project_application/models/question.dart';
import 'package:project_application/models/quiz_options.dart';
import 'package:project_application/models/quiz_result.dart';
import 'package:project_application/services/api_service.dart';
import 'package:project_application/services/storage_service.dart';
import 'package:project_application/services/notification_service.dart';
import 'package:project_application/utils/constants.dart';

enum QuizStatus { initial, loading, error, ready, inProgress, completed }

class QuizProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();

  QuizStatus _status = QuizStatus.initial;
  List<Category> _categories = [];
  List<Question> _questions = [];
  List<String> _userAnswers = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = AppConstants.questionTimeSeconds;
  Timer? _timer;
  String _errorMessage = '';

  QuizStatus get status => _status;
  List<Category> get categories => _categories;
  List<Question> get questions => _questions;
  List<String> get userAnswers => _userAnswers;
  int get currentQuestionIndex => _currentQuestionIndex;
  Question? get currentQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex < _questions.length
          ? _questions[_currentQuestionIndex]
          : null;
  int get score => _score;
  int get timeLeft => _timeLeft;
  String get errorMessage => _errorMessage;

  // Initialize by loading categories
  Future<void> initialize() async {
    _status = QuizStatus.loading;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
      _status = QuizStatus.initial;
    } catch (e) {
      _errorMessage = 'Failed to load categories: $e';
      _status = QuizStatus.error;
    }

    notifyListeners();
  }

  // Start a new quiz with the given options
  Future<void> startQuiz(QuizOptions options) async {
    _status = QuizStatus.loading;
    _questions = [];
    _userAnswers = [];
    _currentQuestionIndex = 0;
    _score = 0;
    _errorMessage = '';
    notifyListeners();

    try {
      _questions = await _apiService.getQuestions(options);

      if (_questions.isEmpty) {
        _errorMessage = 'No questions found for the selected options';
        _status = QuizStatus.error;
      } else {
        _status = QuizStatus.inProgress;
        _startTimer();
      }
    } catch (e) {
      _errorMessage = 'Failed to load questions: $e';
      _status = QuizStatus.error;
    }

    notifyListeners();
  }

  // Answer the current question
  void answerQuestion(String answer) {
    if (_status != QuizStatus.inProgress || currentQuestion == null) return;

    _userAnswers.add(answer);

    if (answer == currentQuestion!.correctAnswer) {
      _score++;
    }

    _cancelTimer();

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _timeLeft = AppConstants.questionTimeSeconds;
      _startTimer();
    } else {
      _completeQuiz();
    }

    notifyListeners();
  }

  // Skip the current question (time ran out)
  void skipQuestion() {
    if (_status != QuizStatus.inProgress) return;

    _userAnswers.add('');

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _timeLeft = AppConstants.questionTimeSeconds;
      _startTimer();
    } else {
      _completeQuiz();
    }

    notifyListeners();
  }

  // Complete the quiz and save results
  void _completeQuiz() {
    _status = QuizStatus.completed;
    _cancelTimer();

    // Save quiz result
    final result = QuizResult(
      questions: _questions,
      userAnswers: _userAnswers,
      score: _score,
      dateTime: DateTime.now(),
      category: _questions.isNotEmpty ? _questions[0].category : '',
      difficulty: _questions.isNotEmpty ? _questions[0].difficulty : '',
    );

    _storageService.saveQuizResult(result);

    // Send quiz completion notification
    _notificationService.showQuizCompletionNotification(
      score: _score,
      totalQuestions: _questions.length,
    );
  }

  // Start the timer for the current question
  void _startTimer() {
    _cancelTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        skipQuestion();
      }
    });
  }

  // Cancel the timer
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Reset the quiz to initial state
  void resetQuiz() {
    _cancelTimer();
    _status = QuizStatus.initial;
    _questions = [];
    _userAnswers = [];
    _currentQuestionIndex = 0;
    _score = 0;
    _timeLeft = AppConstants.questionTimeSeconds;
    _errorMessage = '';
    notifyListeners();
  }

  // Get all saved quiz results
  Future<List<QuizResult>> getQuizResults() async {
    try {
      return await _storageService.getQuizResults();
    } catch (e) {
      _errorMessage = 'Failed to load quiz results: $e';
      return [];
    }
  }

  // Clear all saved quiz results
  Future<void> clearQuizResults() async {
    try {
      await _storageService.clearQuizResults();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to clear quiz results: $e';
    }
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
