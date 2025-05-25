import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_application/models/quiz_result.dart';
import 'package:project_application/providers/quiz_provider.dart';
import 'package:project_application/services/sound_service.dart';
import 'package:project_application/services/storage_service.dart';
import 'package:project_application/services/vibration_service.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';
import 'package:project_application/widgets/app_navigation_drawer.dart';
import 'package:intl/intl.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final SoundService _soundService = SoundService();
  final VibrationService _vibrationService = VibrationService();
  List<QuizResult> _allResults = [];
  List<QuizResult> _filteredResults = [];
  bool _isLoading = true;
  String? _selectedCategory;
  List<String> _availableCategories = [];

  // Selection mode variables
  bool _isSelectionMode = false;
  Set<String> _selectedResultIds = <String>{};

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

    // Extract unique categories
    final categories = results.map((r) => r.category).toSet().toList();
    categories.sort();

    setState(() {
      _allResults = results;
      _availableCategories = ['All Categories', ...categories];
      _selectedCategory ??= 'All Categories';
      _isLoading = false;
    });

    _applyFilter();
  }

  void _applyFilter() {
    setState(() {
      if (_selectedCategory == null || _selectedCategory == 'All Categories') {
        _filteredResults = List.from(_allResults);
      } else {
        _filteredResults =
            _allResults
                .where((result) => result.category == _selectedCategory)
                .toList();
      }
      // Clear selection when filter changes
      _selectedResultIds.clear();
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedResultIds.clear();
      }
    });
    _soundService.playClickSound();
    _vibrationService.vibrateOnTap();
  }

  void _toggleResultSelection(String resultId) {
    setState(() {
      if (_selectedResultIds.contains(resultId)) {
        _selectedResultIds.remove(resultId);
      } else {
        _selectedResultIds.add(resultId);
      }
    });
    _soundService.playClickSound();
    _vibrationService.vibrateOnTap();
  }

  void _selectAllVisible() {
    setState(() {
      _selectedResultIds.addAll(
        _filteredResults.map((result) => _getResultId(result)),
      );
    });
    _soundService.playClickSound();
    _vibrationService.vibrateOnTap();
  }

  String _getResultId(QuizResult result) {
    // Create unique ID using dateTime and score
    return '${result.dateTime.millisecondsSinceEpoch}_${result.score}_${result.category}';
  }

  void _clearSelection() {
    setState(() {
      _selectedResultIds.clear();
    });
    _soundService.playClickSound();
    _vibrationService.vibrateOnTap();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title:
            _isSelectionMode
                ? Text(
                  '${_selectedResultIds.length} ${localizations.get('selected')}',
                )
                : Text(localizations.get('leaderboard')),
        leading:
            _isSelectionMode
                ? IconButton(
                  onPressed: _toggleSelectionMode,
                  icon: const Icon(Icons.close),
                  tooltip: localizations.get('cancel'),
                )
                : null,
        actions:
            _isSelectionMode
                ? [
                  // Select all button
                  IconButton(
                    onPressed:
                        _filteredResults.isEmpty
                            ? null
                            : () {
                              if (_selectedResultIds.length ==
                                  _filteredResults.length) {
                                _clearSelection();
                              } else {
                                _selectAllVisible();
                              }
                            },
                    icon: Icon(
                      _selectedResultIds.length == _filteredResults.length
                          ? Icons.deselect
                          : Icons.select_all,
                    ),
                    tooltip:
                        _selectedResultIds.length == _filteredResults.length
                            ? localizations.get('deselectAll')
                            : localizations.get('selectAll'),
                  ),
                  // Delete selected button
                  IconButton(
                    onPressed:
                        _selectedResultIds.isEmpty
                            ? null
                            : () => _showDeleteSelectedDialog(context),
                    icon: const Icon(Icons.delete),
                    tooltip: localizations.get('deleteSelected'),
                  ),
                ]
                : [
                  // Selection mode button
                  IconButton(
                    onPressed:
                        _allResults.isEmpty ? null : _toggleSelectionMode,
                    icon: const Icon(Icons.checklist),
                    tooltip: localizations.get('selectItems'),
                  ),
                  // Clear all scores button
                  IconButton(
                    onPressed:
                        _allResults.isEmpty
                            ? null
                            : () => _showClearConfirmationDialog(context),
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: localizations.get('clearAllScores'),
                  ),
                ],
      ),
      drawer:
          _isSelectionMode
              ? null
              : AppNavigationDrawer(currentRoute: 'leaderboard'),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _allResults.isEmpty
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
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  // Category filter
                  Container(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: AppConstants.smallPadding),
                        Text(
                          '${localizations.get('category')}:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: AppConstants.smallPadding),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            items:
                                _availableCategories.map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(
                                      category == 'All Categories'
                                          ? localizations.get('allCategories')
                                          : category,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCategory = newValue;
                              });
                              _applyFilter();
                              _soundService.playClickSound();
                              _vibrationService.vibrateOnTap();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Results count
                  if (_filteredResults.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding,
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedCategory == 'All Categories'
                                ? '${_filteredResults.length} ${localizations.get('results')}'
                                : '${_filteredResults.length} of ${_allResults.length} ${localizations.get('results')}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  // Results list
                  Expanded(
                    child:
                        _filteredResults.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search_off,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    height: AppConstants.defaultPadding,
                                  ),
                                  Text(
                                    localizations.get('noResultsForCategory'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.all(
                                AppConstants.defaultPadding,
                              ),
                              itemCount: _filteredResults.length,
                              itemBuilder: (context, index) {
                                final result = _filteredResults[index];
                                final dateFormat = DateFormat(
                                  'yyyy-MM-dd HH:mm',
                                );

                                final resultId = _getResultId(result);
                                final isSelected = _selectedResultIds.contains(
                                  resultId,
                                );

                                return Card(
                                  margin: const EdgeInsets.only(
                                    bottom: AppConstants.smallPadding,
                                  ),
                                  color:
                                      isSelected && _isSelectionMode
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer
                                          : null,
                                  child: ListTile(
                                    leading:
                                        _isSelectionMode
                                            ? Checkbox(
                                              value: isSelected,
                                              onChanged: (bool? value) {
                                                _toggleResultSelection(
                                                  resultId,
                                                );
                                              },
                                            )
                                            : CircleAvatar(
                                              backgroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
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
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${localizations.get('difficulty')}: ${_capitalizeFirst(result.difficulty)}',
                                        ),
                                        Text(
                                          '${localizations.get('date')}: ${dateFormat.format(result.dateTime)}',
                                        ),
                                      ],
                                    ),
                                    trailing:
                                        _isSelectionMode
                                            ? null
                                            : Text(
                                              '${((result.score / result.questions.length) * 100).toStringAsFixed(0)}%',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: _getScoreColor(
                                                  result.score /
                                                      result.questions.length,
                                                ),
                                              ),
                                            ),
                                    isThreeLine: true,
                                    onTap:
                                        _isSelectionMode
                                            ? () =>
                                                _toggleResultSelection(resultId)
                                            : null,
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
      floatingActionButton:
          _isSelectionMode && _selectedResultIds.isNotEmpty
              ? FloatingActionButton.extended(
                onPressed: () => _showDeleteSelectedDialog(context),
                icon: const Icon(Icons.delete),
                label: Text(
                  '${localizations.get('delete')} (${_selectedResultIds.length})',
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              )
              : null,
    );
  }

  void _showDeleteSelectedDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(localizations.get('deleteSelected')),
            content: Text(
              '${localizations.get('confirmDeleteSelected')} ${_selectedResultIds.length} ${localizations.get('items')}?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _soundService.playClickSound();
                  _vibrationService.vibrateOnTap();
                },
                child: Text(localizations.get('cancel')),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _deleteSelectedResults(quizProvider);
                  _soundService.playClickSound();
                  _vibrationService.vibrateOnTap();
                },
                child: Text(localizations.get('delete')),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteSelectedResults(QuizProvider quizProvider) async {
    // Get the results that should remain (not selected)
    final remainingResults =
        _allResults.where((result) {
          return !_selectedResultIds.contains(_getResultId(result));
        }).toList();

    // Clear all results and save only the remaining ones
    await quizProvider.clearQuizResults();

    // Save the remaining results back
    final storageService = StorageService();
    for (final result in remainingResults) {
      await storageService.saveQuizResult(result);
    }

    // Clear selection and reload
    setState(() {
      _isSelectionMode = false;
      _selectedResultIds.clear();
    });

    await _loadResults();
  }

  void _showClearConfirmationDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(localizations.get('clearAllScores')),
            content: Text(localizations.get('confirmClearAll')),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _soundService.playClickSound();
                  _vibrationService.vibrateOnTap();
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
                  _vibrationService.vibrateOnTap();
                },
                child: Text(localizations.get('delete')),
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
