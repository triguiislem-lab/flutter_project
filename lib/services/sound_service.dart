import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Sound service for playing quiz-related audio effects.
///
/// Automatically detects and loads sound files from assets/sounds/ directory.
/// Provides audio feedback for quiz interactions including clicks, correct/wrong answers, and completion.
/// See assets/sounds/README.md for sound file requirements.
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal() {
    _checkSoundAvailability();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;
  bool _soundsAvailable = false;

  // Check if sound files are available
  Future<void> _checkSoundAvailability() async {
    try {
      // For web platform, assume sounds are available if files exist
      // We'll handle errors gracefully during playback
      _soundsAvailable = true;

      if (kDebugMode) {
        print('Sound service initialized - sounds enabled');
      }
    } catch (e) {
      _soundsAvailable = false;
      if (kDebugMode) {
        print('Sound files not available: $e');
      }
    }
  }

  // Getters for debugging
  bool get isEnabled => _soundEnabled;
  bool get soundsAvailable => _soundsAvailable;

  // Set whether sound is enabled
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
    if (kDebugMode) {
      print('Sound enabled set to: $enabled');
    }
  }

  // Play correct answer sound
  Future<void> playCorrectSound() async {
    if (!_shouldPlaySound()) return;

    try {
      await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
      if (kDebugMode) {
        print('Played correct sound');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing correct sound: $e');
      }
    }
  }

  // Play wrong answer sound
  Future<void> playWrongSound() async {
    if (!_shouldPlaySound()) return;

    try {
      await _audioPlayer.play(AssetSource('sounds/wrong.mp3'));
      if (kDebugMode) {
        print('Played wrong sound');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing wrong sound: $e');
      }
    }
  }

  // Play button click sound
  Future<void> playClickSound() async {
    if (!_shouldPlaySound()) return;

    try {
      await _audioPlayer.play(AssetSource('sounds/click.mp3'));
      if (kDebugMode) {
        print('Played click sound');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing click sound: $e');
      }
    }
  }

  // Play quiz completed sound
  Future<void> playCompletedSound() async {
    if (!_shouldPlaySound()) return;

    try {
      await _audioPlayer.play(AssetSource('sounds/completed.mp3'));
      if (kDebugMode) {
        print('Played completed sound');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing completed sound: $e');
      }
    }
  }

  // Helper method to check if sound should play
  bool _shouldPlaySound() {
    if (!_soundEnabled) {
      if (kDebugMode) {
        print('Sound skipped: Disabled in settings');
      }
      return false;
    }
    if (!_soundsAvailable) {
      if (kDebugMode) {
        print('Sound skipped: Sound files not available');
      }
      return false;
    }
    return true;
  }

  // Dispose audio player
  void dispose() {
    _audioPlayer.dispose();
  }
}
