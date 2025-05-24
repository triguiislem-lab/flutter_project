import 'package:flutter/material.dart';
import 'package:project_application/models/question.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';
import 'package:project_application/widgets/answer_option.dart';
import 'package:html_unescape/html_unescape.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final Function(String) onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final unescape = HtmlUnescape();

    // Decode HTML entities in the question text
    final decodedQuestion = unescape.convert(question.question);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category and difficulty
            Row(
              children: [
                Icon(
                  AppConstants
                      .categoryIcons[9], // Default icon if category not found
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Expanded(
                  child: Text(
                    question.category,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.smallPadding,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        AppConstants.difficultyColors[question.difficulty] ??
                        Colors.grey,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius / 2,
                    ),
                  ),
                  child: Text(
                    _capitalizeFirst(question.difficulty),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            // Question text
            Text(
              decodedQuestion,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppConstants.largePadding),

            // Answer options
            Expanded(
              child:
                  question.type == 'boolean'
                      ? _buildBooleanOptions(context, localizations)
                      : _buildMultipleChoiceOptions(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleChoiceOptions(BuildContext context) {
    final unescape = HtmlUnescape();
    final answers = question.allAnswers;

    if (answers.isEmpty) {
      return const Center(child: Text('No answers available'));
    }

    return ListView.builder(
      itemCount: answers.length,
      itemBuilder: (context, index) {
        if (index >= answers.length) return const SizedBox.shrink();

        final answer = answers[index];
        final decodedAnswer = unescape.convert(answer);

        return AnswerOption(
          answer: decodedAnswer,
          onTap: () => onAnswerSelected(answer),
        );
      },
    );
  }

  Widget _buildBooleanOptions(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: AnswerOption(
                answer: localizations.get('true'),
                onTap: () => onAnswerSelected('True'),
                color: Colors.green.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            Expanded(
              child: AnswerOption(
                answer: localizations.get('false'),
                onTap: () => onAnswerSelected('False'),
                color: Colors.red.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
