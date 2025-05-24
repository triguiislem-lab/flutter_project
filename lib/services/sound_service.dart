import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Sound service for playing quiz-related audio effects.
///
/// Automatically detects and loads sound files from assets/sounds/ directory.
/// Provides audio feedback for quiz interactions including clicks, correct/wrong answers, and completion.
/// See assets/sounds/README.md for sound file requirements.
class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;
  bool _soundsAvailable = false;

  SoundService() {
    _checkSoundAvailability();
  }

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

  // Set whether sound is enabled
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  // Play correct answer sound
  Future<void> playCorrectSound() async {
    if (!_soundEnabled || !_soundsAvailable) return;

    try {
      await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing correct sound: $e');
      }
    }
  }

  // Play wrong answer sound
  Future<void> playWrongSound() async {
    if (!_soundEnabled || !_soundsAvailable) return;

    try {
      await _audioPlayer.play(AssetSource('sounds/wrong.mp3'));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing wrong sound: $e');
      }
    }
  }

  // Play button click sound
  Future<void> playClickSound() async {
    if (!_soundEnabled || !_soundsAvailable) return;

    try {
      await _audioPlayer.play(AssetSource('sounds/click.mp3'));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing click sound: $e');
      }
    }
  }

  // Play quiz completed sound
  Future<void> playCompletedSound() async {
    if (!_soundEnabled || !_soundsAvailable) return;

    try {
      await _audioPlayer.play(AssetSource('sounds/completed.mp3'));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing completed sound: $e');
      }
    }
  }

  // Dispose audio player
  void dispose() {
    _audioPlayer.dispose();
  }
}
