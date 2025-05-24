import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';

class VibrationService {
  bool _vibrationEnabled = true;
  bool _canVibrate = false;

  // Initialize vibration service
  Future<void> init() async {
    // Skip vibration initialization on web platform
    if (kIsWeb) {
      _canVibrate = false;
      return;
    }

    try {
      _canVibrate = await Vibration.hasVibrator() ?? false;
    } catch (e) {
      print('Error initializing vibration: $e');
      _canVibrate = false;
    }
  }

  // Set whether vibration is enabled
  void setVibrationEnabled(bool enabled) {
    _vibrationEnabled = enabled;
  }

  // Vibrate for correct answer
  Future<void> vibrateCorrect() async {
    if (kIsWeb || !_vibrationEnabled || !_canVibrate) return;
    try {
      Vibration.vibrate(duration: 100);
    } catch (e) {
      print('Error vibrating for correct answer: $e');
    }
  }

  // Vibrate for wrong answer
  Future<void> vibrateWrong() async {
    if (kIsWeb || !_vibrationEnabled || !_canVibrate) return;
    try {
      Vibration.vibrate(duration: 300);
    } catch (e) {
      print('Error vibrating for wrong answer: $e');
    }
  }

  // Vibrate on button tap
  Future<void> vibrateOnTap() async {
    if (kIsWeb || !_vibrationEnabled || !_canVibrate) return;
    try {
      Vibration.vibrate(duration: 50);
    } catch (e) {
      print('Error vibrating on tap: $e');
    }
  }
}
