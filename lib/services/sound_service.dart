import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;

  // Set whether sound is enabled
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  // Play correct answer sound
  Future<void> playCorrectSound() async {
    if (!_soundEnabled) return;
    
    try {
      await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
    } catch (e) {
      print('Error playing correct sound: $e');
    }
  }

  // Play wrong answer sound
  Future<void> playWrongSound() async {
    if (!_soundEnabled) return;
    
    try {
      await _audioPlayer.play(AssetSource('sounds/wrong.mp3'));
    } catch (e) {
      print('Error playing wrong sound: $e');
    }
  }

  // Play button click sound
  Future<void> playClickSound() async {
    if (!_soundEnabled) return;
    
    try {
      await _audioPlayer.play(AssetSource('sounds/click.mp3'));
    } catch (e) {
      print('Error playing click sound: $e');
    }
  }

  // Play quiz completed sound
  Future<void> playCompletedSound() async {
    if (!_soundEnabled) return;
    
    try {
      await _audioPlayer.play(AssetSource('sounds/completed.mp3'));
    } catch (e) {
      print('Error playing completed sound: $e');
    }
  }

  // Dispose audio player
  void dispose() {
    _audioPlayer.dispose();
  }
}
