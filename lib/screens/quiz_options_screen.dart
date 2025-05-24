import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_application/models/category.dart';
import 'package:project_application/models/quiz_options.dart';
import 'package:project_application/providers/quiz_provider.dart';
import 'package:project_application/screens/quiz_screen.dart';
import 'package:project_application/services/sound_service.dart';
import 'package:project_application/services/vibration_service.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';
import 'package:project_application/widgets/category_selector.dart';
import 'package:project_application/widgets/difficulty_selector.dart';

class QuizOptionsScreen extends StatefulWidget {
  const QuizOptionsScreen({super.key});

  @override
  State<QuizOptionsScreen> createState() => _QuizOptionsScreenState();
}

class _QuizOptionsScreenState extends State<QuizOptionsScreen> {
  final SoundService _soundService = SoundService();
  final VibrationService _vibrationService = VibrationService();

  int? _selectedCategoryId;
  String _selectedDifficulty = 'any';
  int _numberOfQuestions = 10;
  String _selectedType = 'multiple';

  @override
  void initState() {
    super.initState();
    // Initialize quiz provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.get('quizOptions'))),
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
                        quizProvider.initialize();
                      },
                      child: Text(localizations.get('retry')),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category selection
                    Text(
                      localizations.get('category'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    CategorySelector(
                      categories: quizProvider.categories,
                      selectedCategoryId: _selectedCategoryId,
                      onCategorySelected: (categoryId) {
                        setState(() {
                          _selectedCategoryId = categoryId;
                        });
                        _soundService.playClickSound();
                        _vibrationService.vibrateClick();
                      },
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),

                    // Difficulty selection
                    Text(
                      localizations.get('difficulty'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    DifficultySelector(
                      selectedDifficulty: _selectedDifficulty,
                      onDifficultySelected: (difficulty) {
                        setState(() {
                          _selectedDifficulty = difficulty;
                        });
                        _soundService.playClickSound();
                        _vibrationService.vibrateClick();
                      },
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),

                    // Number of questions
                    Text(
                      localizations.get('numberOfQuestions'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Wrap(
                      spacing: AppConstants.smallPadding,
                      children:
                          AppConstants.questionAmounts.map((amount) {
                            return ChoiceChip(
                              label: Text(amount.toString()),
                              selected: _numberOfQuestions == amount,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _numberOfQuestions = amount;
                                  });
                                  _soundService.playClickSound();
                                  _vibrationService.vibrateClick();
                                }
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),

                    // Question type
                    Text(
                      localizations.get('questionType'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Wrap(
                      spacing: AppConstants.smallPadding,
                      children: [
                        ChoiceChip(
                          label: Text(localizations.get('multiple')),
                          selected: _selectedType == 'multiple',
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedType = 'multiple';
                              });
                              _soundService.playClickSound();
                              _vibrationService.vibrateClick();
                            }
                          },
                        ),
                        ChoiceChip(
                          label: Text(localizations.get('boolean')),
                          selected: _selectedType == 'boolean',
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedType = 'boolean';
                              });
                              _soundService.playClickSound();
                              _vibrationService.vibrateClick();
                            }
                          },
                        ),
                        ChoiceChip(
                          label: Text(localizations.get('any')),
                          selected: _selectedType == 'any',
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedType = 'any';
                              });
                              _soundService.playClickSound();
                              _vibrationService.vibrateClick();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.largePadding * 2),

                    // Start quiz button
                    SizedBox(
                      width: double.infinity,
                      height: AppConstants.buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          _startQuiz(context);
                        },
                        child: Text(
                          localizations.get('startQuiz'),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  void _startQuiz(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    final options = QuizOptions(
      categoryId: _selectedCategoryId,
      difficulty: _selectedDifficulty,
      numberOfQuestions: _numberOfQuestions,
      type: _selectedType,
    );

    _soundService.playClickSound();
    _vibrationService.vibrateClick();

    quizProvider.startQuiz(options).then((_) {
      if (quizProvider.status == QuizStatus.inProgress) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizScreen()),
        );
      }
    });
  }
}
