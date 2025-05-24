import 'package:flutter_vibrate/flutter_vibrate.dart';

class VibrationService {
  bool _vibrationEnabled = true;
  bool _canVibrate = false;

  // Initialize vibration service
  Future<void> init() async {
    try {
      _canVibrate = await Vibrate.canVibrate;
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
    if (!_vibrationEnabled || !_canVibrate) return;
    
    try {
      Vibrate.feedback(FeedbackType.success);
    } catch (e) {
      print('Error vibrating for correct answer: $e');
    }
  }

  // Vibrate for wrong answer
  Future<void> vibrateWrong() async {
    if (!_vibrationEnabled || !_canVibrate) return;
    
    try {
      Vibrate.feedback(FeedbackType.error);
    } catch (e) {
      print('Error vibrating for wrong answer: $e');
    }
  }

  // Vibrate for button click
  Future<void> vibrateClick() async {
    if (!_vibrationEnabled || !_canVibrate) return;
    
    try {
      Vibrate.feedback(FeedbackType.selection);
    } catch (e) {
      print('Error vibrating for button click: $e');
    }
  }
}
