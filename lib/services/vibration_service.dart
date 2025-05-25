import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';

class VibrationService {
  static final VibrationService _instance = VibrationService._internal();
  factory VibrationService() => _instance;
  VibrationService._internal();

  bool _vibrationEnabled = true;
  bool _canVibrate = false;
  bool _isInitialized = false;

  // Initialize vibration service
  Future<void> init() async {
    if (_isInitialized) return;

    // Skip vibration initialization on web platform
    if (kIsWeb) {
      _canVibrate = false;
      _isInitialized = true;
      return;
    }

    try {
      final hasVibrator = await Vibration.hasVibrator();
      _canVibrate = hasVibrator == true;
      if (kDebugMode) {
        print('Vibration service initialized: canVibrate=$_canVibrate');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing vibration: $e');
      }
      _canVibrate = false;
    }
    _isInitialized = true;
  }

  // Getters for debugging
  bool get isInitialized => _isInitialized;
  bool get canVibrate => _canVibrate;
  bool get isEnabled => _vibrationEnabled;

  // Set whether vibration is enabled
  void setVibrationEnabled(bool enabled) {
    _vibrationEnabled = enabled;
    if (kDebugMode) {
      print('Vibration enabled set to: $enabled');
    }
  }

  // Vibrate for correct answer
  Future<void> vibrateCorrect() async {
    if (!_shouldVibrate()) return;
    try {
      await Vibration.vibrate(duration: 100);
      if (kDebugMode) {
        print('Vibrated for correct answer');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error vibrating for correct answer: $e');
      }
    }
  }

  // Vibrate for wrong answer
  Future<void> vibrateWrong() async {
    if (!_shouldVibrate()) return;
    try {
      await Vibration.vibrate(duration: 300);
      if (kDebugMode) {
        print('Vibrated for wrong answer');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error vibrating for wrong answer: $e');
      }
    }
  }

  // Vibrate on button tap
  Future<void> vibrateOnTap() async {
    if (!_shouldVibrate()) return;
    try {
      await Vibration.vibrate(duration: 50);
      if (kDebugMode) {
        print('Vibrated on tap');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error vibrating on tap: $e');
      }
    }
  }

  // Helper method to check if vibration should occur
  bool _shouldVibrate() {
    if (kIsWeb) {
      if (kDebugMode) {
        print('Vibration skipped: Web platform');
      }
      return false;
    }
    if (!_isInitialized) {
      if (kDebugMode) {
        print('Vibration skipped: Not initialized');
      }
      return false;
    }
    if (!_vibrationEnabled) {
      if (kDebugMode) {
        print('Vibration skipped: Disabled in settings');
      }
      return false;
    }
    if (!_canVibrate) {
      if (kDebugMode) {
        print('Vibration skipped: Device cannot vibrate');
      }
      return false;
    }
    return true;
  }
}
