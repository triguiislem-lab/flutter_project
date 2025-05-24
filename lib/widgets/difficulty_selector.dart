import 'package:flutter/material.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';

class DifficultySelector extends StatelessWidget {
  final String selectedDifficulty;
  final Function(String) onDifficultySelected;
  
  const DifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onDifficultySelected,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Wrap(
      spacing: AppConstants.smallPadding,
      children: AppConstants.difficulties.map((difficulty) {
        // Get localized difficulty name
        String difficultyName;
        switch (difficulty) {
          case 'any':
            difficultyName = localizations.get('any');
            break;
          case 'easy':
            difficultyName = localizations.get('easy');
            break;
          case 'medium':
            difficultyName = localizations.get('medium');
            break;
          case 'hard':
            difficultyName = localizations.get('hard');
            break;
          default:
            difficultyName = difficulty;
        }
        
        // Get difficulty color
        Color? chipColor;
        if (difficulty != 'any') {
          chipColor = AppConstants.difficultyColors[difficulty];
        }
        
        return ChoiceChip(
          label: Text(
            difficultyName,
            style: TextStyle(
              color: selectedDifficulty == difficulty && chipColor != null
                  ? Colors.white
                  : null,
            ),
          ),
          selected: selectedDifficulty == difficulty,
          selectedColor: chipColor,
          onSelected: (selected) {
            if (selected) {
              onDifficultySelected(difficulty);
            }
          },
        );
      }).toList(),
    );
  }
}
