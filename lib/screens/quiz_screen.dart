import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_application/providers/quiz_provider.dart';
import 'package:project_application/screens/results_screen.dart';
import 'package:project_application/services/sound_service.dart';
import 'package:project_application/services/vibration_service.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';
import 'package:project_application/widgets/question_card.dart';
import 'package:project_application/widgets/timer_widget.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final SoundService _soundService = SoundService();
  final VibrationService _vibrationService = VibrationService();
  bool _isNavigatingToResults = false; // Prevent multiple navigations

  @override
  void initState() {
    super.initState();
    // Listen for quiz completion
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final quizProvider = Provider.of<QuizProvider>(context, listen: false);
        if (quizProvider.status == QuizStatus.completed &&
            !_isNavigatingToResults) {
          _navigateToResults();
        }
      }
    });
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final localizations = AppLocalizations.of(context);

    // Navigate to results screen if quiz is completed
    if (quizProvider.status == QuizStatus.completed &&
        !_isNavigatingToResults) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _navigateToResults();
        }
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final navigator = Navigator.of(context);
        // Show confirmation dialog before exiting quiz
        final shouldPop = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(localizations.get('cancel')),
                content: Text('Are you sure you want to exit the quiz?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(localizations.get('no')),
                  ),
                  TextButton(
                    onPressed: () {
                      quizProvider.resetQuiz();
                      Navigator.of(context).pop(true);
                    },
                    child: Text(localizations.get('yes')),
                  ),
                ],
              ),
        );
        if (shouldPop == true && mounted) {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${localizations.get('question')} ${quizProvider.currentQuestionIndex + 1}/${quizProvider.questions.length}',
          ),
          actions: [
            // Timer widget
            Padding(
              padding: const EdgeInsets.only(
                right: AppConstants.defaultPadding,
              ),
              child: TimerWidget(
                timeLeft: quizProvider.timeLeft,
                totalTime: AppConstants.questionTimeSeconds,
              ),
            ),
          ],
        ),
        body:
            quizProvider.status == QuizStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : quizProvider.status == QuizStatus.error
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        quizProvider.errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(localizations.get('back')),
                      ),
                    ],
                  ),
                )
                : quizProvider.currentQuestion == null
                ? Center(child: Text(localizations.get('loading')))
                : Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    children: [
                      // Question card
                      Expanded(
                        child: QuestionCard(
                          question: quizProvider.currentQuestion!,
                          onAnswerSelected: (answer) {
                            // Handle answer selection
                            if (answer ==
                                quizProvider.currentQuestion!.correctAnswer) {
                              _soundService.playCorrectSound();
                              _vibrationService.vibrateCorrect();
                            } else {
                              _soundService.playWrongSound();
                              _vibrationService.vibrateWrong();
                            }

                            quizProvider.answerQuestion(answer);
                          },
                        ),
                      ),

                      // Progress indicator
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.defaultPadding,
                        ),
                        child: LinearProgressIndicator(
                          value:
                              (quizProvider.currentQuestionIndex + 1) /
                              quizProvider.questions.length,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  void _navigateToResults() {
    if (_isNavigatingToResults || !mounted) return;

    _isNavigatingToResults = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResultsScreen()),
    );
  }
}
