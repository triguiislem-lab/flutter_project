import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_application/providers/settings_provider.dart';
import 'package:project_application/services/vibration_service.dart';
import 'package:project_application/services/sound_service.dart';
import 'package:project_application/utils/constants.dart';

class VibrationTestScreen extends StatefulWidget {
  const VibrationTestScreen({super.key});

  @override
  State<VibrationTestScreen> createState() => _VibrationTestScreenState();
}

class _VibrationTestScreenState extends State<VibrationTestScreen> {
  final VibrationService _vibrationService = VibrationService();
  final SoundService _soundService = SoundService();
  String _statusMessage = 'Checking services status...';

  @override
  void initState() {
    super.initState();
    _checkServicesStatus();
  }

  void _checkServicesStatus() {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );
    setState(() {
      _statusMessage = '''
Services Status:

Vibration Service:
- Initialized: ${_vibrationService.isInitialized}
- Can Vibrate: ${_vibrationService.canVibrate}
- Enabled: ${_vibrationService.isEnabled}
- Settings Enabled: ${settingsProvider.vibrationEnabled}

Sound Service:
- Enabled: ${_soundService.isEnabled}
- Sounds Available: ${_soundService.soundsAvailable}
- Settings Enabled: ${settingsProvider.soundEnabled}

Platform: ${kIsWeb ? 'Web' : 'Mobile'}
      ''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound & Vibration Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Text(
                  _statusMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            ElevatedButton(
              onPressed: () {
                _vibrationService.vibrateOnTap();
                if (kDebugMode) {
                  print('Test tap vibration triggered');
                }
              },
              child: const Text('Test Tap Vibration (50ms)'),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            ElevatedButton(
              onPressed: () {
                _vibrationService.vibrateCorrect();
                if (kDebugMode) {
                  print('Test correct vibration triggered');
                }
              },
              child: const Text('Test Correct Answer (100ms)'),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            ElevatedButton(
              onPressed: () {
                _vibrationService.vibrateWrong();
                if (kDebugMode) {
                  print('Test wrong vibration triggered');
                }
              },
              child: const Text('Test Wrong Answer (300ms)'),
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            // Sound Tests
            Text(
              'Sound Tests:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppConstants.smallPadding),

            ElevatedButton(
              onPressed: () {
                _soundService.playClickSound();
                if (kDebugMode) {
                  print('Test click sound triggered');
                }
              },
              child: const Text('Test Click Sound'),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            ElevatedButton(
              onPressed: () {
                _soundService.playCorrectSound();
                if (kDebugMode) {
                  print('Test correct sound triggered');
                }
              },
              child: const Text('Test Correct Sound'),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            ElevatedButton(
              onPressed: () {
                _soundService.playWrongSound();
                if (kDebugMode) {
                  print('Test wrong sound triggered');
                }
              },
              child: const Text('Test Wrong Sound'),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            ElevatedButton(
              onPressed: () {
                _soundService.playCompletedSound();
                if (kDebugMode) {
                  print('Test completed sound triggered');
                }
              },
              child: const Text('Test Completed Sound'),
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            ElevatedButton(
              onPressed: () {
                _soundService.setSoundEnabled(!_soundService.isEnabled);
                _checkServicesStatus();
              },
              child: Text(
                _soundService.isEnabled ? 'Disable Sound' : 'Enable Sound',
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            ElevatedButton(
              onPressed: () {
                _vibrationService.setVibrationEnabled(
                  !_vibrationService.isEnabled,
                );
                _checkServicesStatus();
              },
              child: Text(
                _vibrationService.isEnabled
                    ? 'Disable Vibration'
                    : 'Enable Vibration',
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            ElevatedButton(
              onPressed: _checkServicesStatus,
              child: const Text('Refresh Status'),
            ),
          ],
        ),
      ),
    );
  }
}
