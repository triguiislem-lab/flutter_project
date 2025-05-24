import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_application/providers/quiz_provider.dart';
import 'package:project_application/screens/home_screen.dart';
import 'package:project_application/screens/quiz_options_screen.dart';
import 'package:project_application/services/sound_service.dart';
import 'package:project_application/services/vibration_service.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final SoundService _soundService = SoundService();
  final VibrationService _vibrationService = VibrationService();
  bool _showAnswers = false;

  @override
  void initState() {
    super.initState();
    _soundService.playCompletedSound();
    _vibrationService.vibrateCorrect();
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final localizations = AppLocalizations.of(context);

    // Calculate accuracy percentage
    final accuracy =
        quizProvider.questions.isEmpty
            ? 0.0
            : (quizProvider.score / quizProvider.questions.length) * 100;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        // Reset quiz and navigate to home
        quizProvider.resetQuiz();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.get('quizResults')),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Score display
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    children: [
                      Text(
                        localizations.get('score'),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Text(
                        '${quizProvider.score}/${quizProvider.questions.length}',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),

                      // Accuracy indicator
                      LinearProgressIndicator(
                        value: accuracy / 100,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Text(
                        '${accuracy.toStringAsFixed(1)}% ${localizations.get('accuracy')}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              // View answers toggle
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _showAnswers = !_showAnswers;
                  });
                  _soundService.playClickSound();
                  _vibrationService.vibrateClick();
                },
                icon: Icon(
                  _showAnswers ? Icons.visibility_off : Icons.visibility,
                ),
                label: Text(
                  _showAnswers
                      ? localizations.get('hideAnswers')
                      : localizations.get('viewAnswers'),
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              // Answers list
              if (_showAnswers)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: quizProvider.questions.length,
                  itemBuilder: (context, index) {
                    final question = quizProvider.questions[index];
                    final userAnswer =
                        index < quizProvider.userAnswers.length
                            ? quizProvider.userAnswers[index]
                            : '';
                    final isCorrect = userAnswer == question.correctAnswer;

                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: AppConstants.smallPadding,
                      ),
                      color:
                          isCorrect
                              ? Colors.green.withAlpha(25)
                              : Colors.red.withAlpha(25),
                      child: Padding(
                        padding: const EdgeInsets.all(
                          AppConstants.smallPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Q${index + 1}: ${question.question}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppConstants.smallPadding),
                            Text(
                              '${localizations.get('yourAnswer')}: ${userAnswer.isEmpty ? '-' : userAnswer}',
                              style: TextStyle(
                                color: isCorrect ? Colors.green : Colors.red,
                              ),
                            ),
                            if (!isCorrect)
                              Text(
                                '${localizations.get('correctAnswer')}: ${question.correctAnswer}',
                                style: const TextStyle(color: Colors.green),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: AppConstants.largePadding),

              // Action buttons
              Row(
                children: [
                  // Play again button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        quizProvider.resetQuiz();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizOptionsScreen(),
                          ),
                        );
                        _soundService.playClickSound();
                        _vibrationService.vibrateClick();
                      },
                      icon: const Icon(Icons.replay),
                      label: Text(localizations.get('playAgain')),
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),

                  // Home button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        quizProvider.resetQuiz();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false,
                        );
                        _soundService.playClickSound();
                        _vibrationService.vibrateClick();
                      },
                      icon: const Icon(Icons.home),
                      label: Text(localizations.get('returnToHome')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
