import 'package:flutter/material.dart';
import 'package:project_application/utils/constants.dart';

class AnswerOption extends StatelessWidget {
  final String answer;
  final VoidCallback onTap;
  final Color? color;
  
  const AnswerOption({
    super.key,
    required this.answer,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  answer,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
