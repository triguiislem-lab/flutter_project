import 'package:flutter/material.dart';
import 'package:project_application/services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  bool _darkMode = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _language = 'en';
  bool _notificationsEnabled = true;
  
  bool get darkMode => _darkMode;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  
  // Initialize settings from storage
  Future<void> loadSettings() async {
    try {
      final settings = await _storageService.getSettings();
      
      _darkMode = settings['darkMode'] ?? false;
      _soundEnabled = settings['soundEnabled'] ?? true;
      _vibrationEnabled = settings['vibrationEnabled'] ?? true;
      _language = settings['language'] ?? 'en';
      _notificationsEnabled = settings['notificationsEnabled'] ?? true;
      
      notifyListeners();
    } catch (e) {
      print('Error loading settings: $e');
    }
  }
  
  // Save settings to storage
  Future<void> _saveSettings() async {
    try {
      await _storageService.saveSettings({
        'darkMode': _darkMode,
        'soundEnabled': _soundEnabled,
        'vibrationEnabled': _vibrationEnabled,
        'language': _language,
        'notificationsEnabled': _notificationsEnabled,
      });
    } catch (e) {
      print('Error saving settings: $e');
    }
  }
  
  // Toggle dark mode
  void toggleDarkMode() {
    _darkMode = !_darkMode;
    _saveSettings();
    notifyListeners();
  }
  
  // Toggle sound
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    _saveSettings();
    notifyListeners();
  }
  
  // Toggle vibration
  void toggleVibration() {
    _vibrationEnabled = !_vibrationEnabled;
    _saveSettings();
    notifyListeners();
  }
  
  // Set language
  void setLanguage(String language) {
    _language = language;
    _saveSettings();
    notifyListeners();
  }
  
  // Toggle notifications
  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    _saveSettings();
    notifyListeners();
  }
}
