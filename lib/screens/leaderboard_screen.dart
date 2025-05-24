import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_application/models/quiz_result.dart';
import 'package:project_application/providers/quiz_provider.dart';
import 'package:project_application/services/sound_service.dart';
import 'package:project_application/services/vibration_service.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';
import 'package:intl/intl.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final SoundService _soundService = SoundService();
  final VibrationService _vibrationService = VibrationService();
  List<QuizResult> _results = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadResults();
  }
  
  Future<void> _loadResults() async {
    setState(() {
      _isLoading = true;
    });
    
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final results = await quizProvider.getQuizResults();
    
    // Sort results by score (descending) and date (descending)
    results.sort((a, b) {
      final scoreComparison = b.score.compareTo(a.score);
      if (scoreComparison != 0) return scoreComparison;
      return b.dateTime.compareTo(a.dateTime);
    });
    
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('leaderboard')),
        actions: [
          // Clear scores button
          IconButton(
            onPressed: _results.isEmpty
                ? null
                : () => _showClearConfirmationDialog(context),
            icon: const Icon(Icons.delete),
            tooltip: localizations.get('clearScores'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      Text(
                        localizations.get('noScores'),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final result = _results[index];
                    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          '${result.score}/${result.questions.length} - ${result.category}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${localizations.get('difficulty')}: ${_capitalizeFirst(result.difficulty)}'),
                            Text('${localizations.get('date')}: ${dateFormat.format(result.dateTime)}'),
                          ],
                        ),
                        trailing: Text(
                          '${((result.score / result.questions.length) * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getScoreColor(result.score / result.questions.length),
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
  
  void _showClearConfirmationDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.get('clearScores')),
        content: Text(localizations.get('confirmClear')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _soundService.playClickSound();
              _vibrationService.vibrateClick();
            },
            child: Text(localizations.get('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              quizProvider.clearQuizResults().then((_) {
                _loadResults();
              });
              _soundService.playClickSound();
              _vibrationService.vibrateClick();
            },
            child: Text(localizations.get('ok')),
          ),
        ],
      ),
    );
  }
  
  Color _getScoreColor(double percentage) {
    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.6) return Colors.blue;
    if (percentage >= 0.4) return Colors.orange;
    return Colors.red;
  }
  
  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
