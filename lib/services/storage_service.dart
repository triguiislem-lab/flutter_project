import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_application/models/quiz_result.dart';

class StorageService {
  static const String _resultsKey = 'quiz_results';
  static const String _settingsKey = 'app_settings';

  // Save quiz result to local storage
  Future<void> saveQuizResult(QuizResult result) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final resultsJson = prefs.getStringList(_resultsKey) ?? [];
      
      resultsJson.add(jsonEncode(result.toJson()));
      await prefs.setStringList(_resultsKey, resultsJson);
    } catch (e) {
      throw Exception('Error saving quiz result: $e');
    }
  }

  // Get all quiz results from local storage
  Future<List<QuizResult>> getQuizResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final resultsJson = prefs.getStringList(_resultsKey) ?? [];
      
      return resultsJson
          .map((json) => QuizResult.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      throw Exception('Error getting quiz results: $e');
    }
  }

  // Clear all quiz results from local storage
  Future<void> clearQuizResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_resultsKey);
    } catch (e) {
      throw Exception('Error clearing quiz results: $e');
    }
  }

  // Save app settings to local storage
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_settingsKey, jsonEncode(settings));
    } catch (e) {
      throw Exception('Error saving settings: $e');
    }
  }

  // Get app settings from local storage
  Future<Map<String, dynamic>> getSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);
      
      if (settingsJson == null) {
        return {
          'darkMode': false,
          'soundEnabled': true,
          'vibrationEnabled': true,
          'language': 'en',
          'notificationsEnabled': true,
        };
      }
      
      return jsonDecode(settingsJson);
    } catch (e) {
      throw Exception('Error getting settings: $e');
    }
  }
}
