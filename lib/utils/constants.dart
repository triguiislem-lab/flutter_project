import 'package:flutter/material.dart';

class AppConstants {
  // API related
  static const int apiTimeoutSeconds = 30;
  
  // Quiz related
  static const List<int> questionAmounts = [5, 10, 15, 20];
  static const List<String> difficulties = ['any', 'easy', 'medium', 'hard'];
  static const List<String> questionTypes = ['any', 'multiple', 'boolean'];
  static const int defaultQuestionAmount = 10;
  static const int questionTimeSeconds = 30;
  
  // UI related
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 56.0;
  
  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
  
  // Languages
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('fr', 'FR'), // French
    Locale('ar', 'SA'), // Arabic
  ];
  
  // Difficulty colors
  static const Map<String, Color> difficultyColors = {
    'easy': Colors.green,
    'medium': Colors.orange,
    'hard': Colors.red,
  };
  
  // Category icons
  static const Map<int, IconData> categoryIcons = {
    9: Icons.book, // General Knowledge
    10: Icons.menu_book, // Books
    11: Icons.movie, // Film
    12: Icons.music_note, // Music
    13: Icons.theater_comedy, // Theatre
    14: Icons.tv, // Television
    15: Icons.videogame_asset, // Video Games
    16: Icons.science, // Board Games
    17: Icons.science, // Science & Nature
    18: Icons.computer, // Computers
    19: Icons.calculate, // Mathematics
    20: Icons.public, // Mythology
    21: Icons.sports_soccer, // Sports
    22: Icons.public, // Geography
    23: Icons.history_edu, // History
    24: Icons.account_balance, // Politics
    25: Icons.brush, // Art
    26: Icons.people, // Celebrities
    27: Icons.pets, // Animals
    28: Icons.directions_car, // Vehicles
    29: Icons.menu_book, // Comics
    30: Icons.science, // Gadgets
    31: Icons.animation, // Anime & Manga
    32: Icons.movie, // Cartoon & Animation
  };
}
