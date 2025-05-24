import 'package:flutter/material.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';

class TimerWidget extends StatelessWidget {
  final int timeLeft;
  final int totalTime;

  const TimerWidget({
    super.key,
    required this.timeLeft,
    required this.totalTime,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Calculate progress (inverted for countdown)
    final progress = timeLeft / totalTime;

    // Determine color based on time left
    Color timerColor;
    if (timeLeft > totalTime * 0.6) {
      timerColor = Colors.green;
    } else if (timeLeft > totalTime * 0.3) {
      timerColor = Colors.orange;
    } else {
      timerColor = Colors.red;
    }

    return Row(
      children: [
        // Time text
        Text(
          '$timeLeft ${localizations.get('seconds')}',
          style: TextStyle(fontWeight: FontWeight.bold, color: timerColor),
        ),
        const SizedBox(width: AppConstants.smallPadding),

        // Timer icon
        Stack(
          alignment: Alignment.center,
          children: [
            // Progress indicator
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 3,
                color: timerColor,
                backgroundColor: Colors.grey.withValues(alpha: 0.3),
              ),
            ),

            // Timer icon
            Icon(Icons.timer, size: 16, color: timerColor),
          ],
        ),
      ],
    );
  }
}
